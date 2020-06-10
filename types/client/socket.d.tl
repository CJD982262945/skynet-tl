local socket = record
    connect: function(string, number): number
    send: function(number, string)
    recv: function(number): string
    usleep: function(number, number)
    close: function(number)
end

return socket