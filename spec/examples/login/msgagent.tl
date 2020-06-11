local skynet = require("skynet")

skynet.register_protocol {
	name = "client",
	id = skynet.PTYPE_CLIENT,
	unpack = skynet.tostring,
}

local gate: number
local userid: string
local subid: number

local function logout()
    if gate then
        skynet.call(gate, "lua", "logout", userid, subid)
    end
    skynet.exit()
end

local CMD: {string: function(...:any): any... } = {

    login = function (source: number, uid: string, sid: number, secret: string)
        -- you may use secret to make a encrypted data stream
        skynet.error(string.format("%s is login", uid))
        gate = source
        userid = uid
        subid = sid
        -- you may load user data from database
    end

    logout = function (source: number)
        -- NOTICE: The logout MAY be reentry
        skynet.error(string.format("%s is logout", userid))
        logout()
    end

    afk = function (source: number)
        -- the connection is broken, but the user may back
        skynet.error(string.format("AFK"))
    end
}

skynet.start(function()
	-- If you want to fork a work thread , you MUST do it in CMD.login
	skynet.dispatch("lua", function(session: number, source: number, command: string, ...: any)
		local f = assert(CMD[command]) as function
		skynet.ret(skynet.pack(f(source, ...)))
	end)

	skynet.dispatch("client", function(_: number, _: number, msg: any)
		-- the simple echo service
		skynet.sleep(10)-- sleep a while
		skynet.ret(msg)
	end)
end)
