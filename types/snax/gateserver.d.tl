local gateserver = record
    GateServerConf = record
    end

    GateServerOptions = record
        open: function(number, GateServerConf)
        message: function(number, any | string, number) -- TODO: userdata
        connect: function(number, string)
        disconnect: function(number)
        error: function(number, string)
        warning: function(number, number)
        command: function(string, ...: any): any...
    end

    openclient: function(number)
    closeclient: function(number)
    start: function(GateServerOptions)
end

return gateserver