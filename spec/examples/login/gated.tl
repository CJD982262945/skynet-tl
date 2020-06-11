local skynet = require("skynet")
local msgserver = require("snax.msgserver")

local loginservice_s = ...
local loginservice = tonumber(loginservice_s)

local users = {}
local username_map = {}
local internal_id = 0

local servername: string

local server: msgserver.MsgServerOptions = {
    -- login server disallow multi login, so login_handler never be reentry
    -- call by login server
    login_handler = function (uid: string, secret: string): number
        if users[uid] then
            error(string.format("%s is already login", uid))
        end

        internal_id = internal_id + 1
        local id = internal_id	-- don't use internal_id directly
        local username = msgserver.username(uid, id, servername)

        -- you can use a pool to alloc new agent
        local agent = skynet.newservice "msgagent"
        local u = {
            username = username,
            agent = agent,
            uid = uid,
            subid = id,
        }

        -- trash subid (no used)
        skynet.call(agent, "lua", "login", uid, id, secret)

        users[uid] = u
        username_map[username] = u

        msgserver.login(username, secret)

        -- you should return unique subid
        return id
    end,

    -- call by agent
    logout_handler = function (uid: string, subid: number)
        local u = users[uid]
        if u then
            local username = msgserver.username(uid, subid, servername)
            assert(u.username == username)
            msgserver.logout(u.username)
            users[uid] = nil
            username_map[u.username] = nil
            skynet.call(loginservice, "lua", "logout",uid, subid)
        end
    end

    -- call by login server
    kick_handler = function (uid: string, subid: number)
        local u = users[uid]
        if u then
            local username = msgserver.username(uid, subid, servername)
            assert(u.username == username)
            -- NOTICE: logout may call skynet.exit, so you should use pcall.
            pcall(skynet.call, u.agent, "lua", "logout")
        end
    end

    -- call by self (when socket disconnect)
    disconnect_handler = function(username: string)
        local u = username_map[username]
        if u then
            skynet.call(u.agent, "lua", "afk")
        end
    end

    -- call by self (when recv a request from client)
    request_handler = function(username: string, msg: string): string
        local u = username_map[username]
        return skynet.tostring(skynet.rawcall(u.agent, "client", msg))
    end

    -- call by self (when gate open)
    register_handler = function (name: string)
        servername = name
        skynet.call(loginservice, "lua", "register_gate", servername, skynet.self())
    end
}

msgserver.start(server)

