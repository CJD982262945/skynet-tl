global LoginServerOptions = record
    host: string
    port: number
    multilogin: boolean
    name: string
    auth_handler: function(string): string, string
    login_handler: function(string, string, string): string
    command_handler: function(string, ...: any): any...
end

local loginserver: function(options: LoginServerOptions)

return loginserver