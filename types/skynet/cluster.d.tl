local cluster = record
	call: function(string, number|string, ...: any): any...
	send: function(string, number|string, ...: any)
	open: function(string| number)
	reload: function(any) 	-- TODO: declares  cluster conf
	proxy: function(string, number|string): number
	register: function(string, number|string)
	query: function(string, number|string)
end

return cluster