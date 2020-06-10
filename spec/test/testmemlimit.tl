local skynet = require("skynet")

local libs = {
	["cluster"] = require("skynet.db.redis"),
}

-- set sandbox memory limit to 1M, must set here (at start, out of skynet.start)
skynet.memlimit(1 * 1024 * 1024)

skynet.start(function()
    local a = {}
    local limit: number
    function init()
        for i=1, 12355 do
            limit = i
            table.insert(a, {})
        end
    end
    init()
    skynet.error(limit)
    skynet.exit()
end)
