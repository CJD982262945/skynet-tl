local socket = record
	listen: function(string, number, number): number
	open: function(string, number): number
	close: function(number)
	close_fd: function(number)
	shutdown: function(number)
	read: function(number, number): string
	readall: function(number): string
	readline: function(number, string): string
	block: function(number)
	write: function(number, string)
	lwrite: function(number, string)
	start: function(number, function(number, string))
	abandon: function(number)
	warning: function(number, function(number, string))

	udp: function (function(string, string), string, number) : number
	udp_connect: function (number, string, number, function(string, string))
	sendto: function(number, string, string)
	udp_address: function(string): string, number
end

return socket