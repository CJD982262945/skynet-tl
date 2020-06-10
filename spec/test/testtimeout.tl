local skynet = require("skynet")
local service = require("skynet.service")

local function test_service()
	local skynet = require "skynet"

	skynet.start(function()
		skynet.dispatch("lua", function()
			skynet.error("Wait for 1s")
			skynet.sleep(100)	-- response after 1s for any request
			skynet.ret()
		end)
	end)
end

local function timeout_call(ti: number, ...: any): any
	local token: thread
	local ret: any

	skynet.fork(function(...)
		ret = table.pack(pcall(skynet.call, ...))
		skynet.wakeup(token)
	end, ...)

	skynet.sleep(ti, token)

	local Packed = record
		{any}
		n: number
	end

	local res = ret as Packed
	if res then
		if res[1] then
			return table.unpack(res, 1, res.n)
		else
			error(res[2] as string)
		end
	else
		-- timeout
		return false
	end
end

skynet.start(function()
	local test = service.new("testtimeout", test_service)
	skynet.error("1", skynet.now())
	skynet.call(test, "lua")
	skynet.error("2", skynet.now())
	skynet.error(timeout_call(50, test, "lua"))
	skynet.error("3", skynet.now())
	skynet.error(timeout_call(150, test, "lua"))
	skynet.error("4", skynet.now())
	skynet.exit()
end)