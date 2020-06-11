local skynet = require("skynet")
local crypt = require("skynet.crypt")
local login = require("snax.loginserver")

local LoginUser = record
    address: number
    subid: string
    server: string
end

local server_list: {string: number} = {}
local user_online: {string: LoginUser} = {}
local user_login = {}

local CMD: {string: function(...:any): any... } = {
    register_gate = function (server: string, address: number)
        server_list[server] = address
    end

    logout = function (uid: string, subid: string)
        local u = user_online[uid]
        if u then
            print(string.format("%s@%s is logout", uid, u.server))
            user_online[uid] = nil
        end
    end
}

local server: LoginServerOptions = {
	host = "127.0.0.1",
	port = 8001,
	multilogin = false,	-- disallow multilogin
	name = "login_master",

    auth_handler = function(token: string): string, string
        -- the token is base64(user)@base64(server):base64(password)
        local user, server, password = token:match("([^@]+)@([^:]+):(.+)")
        user = crypt.base64decode(user)
        server = crypt.base64decode(server)
        password = crypt.base64decode(password)
        assert(password == "password", "Invalid password")
        return server, user
    end,

    login_handler = function(server: string, uid: string, secret: string): string
        print(string.format("%s@%s is login, secret is %s", uid, server, crypt.hexencode(secret)))
        local gameserver = assert(server_list[server], "Unknown server")
        -- only one can login, because disallow multilogin
        local last = user_online[uid]
        if last then
            skynet.call(last.address, "lua", "kick", uid, last.subid)
        end
        if user_online[uid] then
            error(string.format("user %s is already online", uid))
        end

        local subid = tostring(skynet.call(gameserver, "lua", "login", uid, secret))
        user_online[uid] = { address = gameserver, subid = subid , server = server}
        return subid
    end

    command_handler = function (command: string, ...): any...
        local f = assert(CMD[command]) as function
        return f(...)
    end
}

login(server)
