local redis = record
	RedisConf = record
		host: string
		port: number
		db: number
		auth: string
	end

	RedisClient = record
		del: function(RedisClient, string): number
		set: function(RedisClient, string, string): string
		sadd: function(RedisClient, string, string): number
		get: function(RedisClient, string): string
		hset: function(RedisClient, string, string, string): number
		hvals: function(RedisClient, string): {any} -- https://redis.io/commands/hvals
		multi: function(RedisClient): string
		exec: function(RedisClient): {any} -- https://redis.io/commands/exec
		exists: function(RedisClient, string): number
		sismember: function(RedisClient,string, string): number
		publish: function(RedisClient, string, string): number
		pipeline: function<T>(RedisClient, any, any): table
		hincrby: function(RedisClient, string, string, number): number
		hgetall: function<T>(RedisClient, string): {T}
		hmset: function(RedisClient, string, string, ...:string): string --return Simple Strings
		disconnect: function(RedisClient)
		dbsize: function(RedisClient): number
	end

	RedisWatcher = record
		subscribe: function(RedisWatcher, string)
		psubscribe: function(RedisWatcher, string)
		message: function(RedisWatcher): string
	end

	connect: function(RedisConf): RedisClient
	watch: function(RedisConf): RedisWatcher
end

return redis