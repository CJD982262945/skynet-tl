local httpc = record
	dns: function()
	timeout: number
	request: function(string, string, string, any, any, any): number, any
	get: function(...: any): number, any -- TODO: 定义 resp 结构
	post: function(string, string, any, any): number, any
end

return httpc