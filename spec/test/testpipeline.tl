local skynet = require("skynet")
local redis = require("skynet.db.redis")

local conf: redis.RedisConf = {
    host = "127.0.0.1",
	port = 6379,
	db = 0
}

local function read_table<T, K, V>(list: {T}): {K:V}
    local result:{K:V} = { }
    for i = 1, #list, 2 do 
        result[list[i]] = list[i + 1]
    end
    return result
end

skynet.start(function()
    local db = redis.connect(conf)
    print("test table")
    local ret = db:pipeline({
        {"hincrby", "hello", 1, 1}, -- return number
        {"del", "hello"}, -- return number
        {"hmset", "hello", 1, 1, 2, 2, 3, 3}, -- return string
        {"hgetall", "hello"}, -- list{T}        
    }, {}) -- offer a {T} for result
    
    -- TODO: tl 目前支持 as 强转 只不过需要测试
    print(ret[1] as number)
    print(ret[2] as number)
    print(ret[3] as string)

    for k, v in pairs(read_table(ret[4] as {any})) do
        print(k, v)
    end

    db:disconnect()
    skynet.exit()
end)