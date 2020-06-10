local skynet = require("skynet")

local mode = ...

if mode == "slave" then

local CMD: {string: function(...:any) } = {
    sum = function(n: number)
        skynet.error("for loop begin")
        local s = 0
        for i = 1, n do
            s = s + i
        end
        skynet.error("for loop end")
    end,
    blackhole = function()
    end
}

skynet.start(function()
	skynet.dispatch("lua", function(_: number, _: number, cmd: string, ...: any)
        local f = CMD[cmd] as function
        if f then
            f(...)
        end
	end)
end)

else

skynet.start(function()
	local slave = skynet.newservice("testoverload", "slave")
	for step = 1, 20 do
		skynet.error("overload test ".. step)
		for i = 1, 512 * step do
			skynet.send(slave, "lua", "blackhole")
		end
		skynet.sleep(step)
	end
	local n = 1000000000
	skynet.error(string.format("endless test n=%d", n))
	skynet.send(slave, "lua", "sum", n)
end)

end
