local datacenter = record
	get: 	function(...: string): string
	set: 	function(...: string)
	wait: 	function(...: string): string
end

return datacenter