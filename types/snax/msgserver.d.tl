

-- local msgserver: function(options: MsgServerOptions)

-- return msgserver

local msgserver = record
    MsgServerOptions = record
        login_handler: function(string, string): number
        logout_handler: function(string, number)
        kick_handler: function(string, number)
        disconnect_handler: function(string)
        request_handler: function(string, string): string
        register_handler: function (string)
    end

    start: function(options: MsgServerOptions)
    userid: function(string): string
    username: function(string, number, string): string
    logout: function(string)
    login: function(string, string)
    ip: function(string)
end

return msgserver