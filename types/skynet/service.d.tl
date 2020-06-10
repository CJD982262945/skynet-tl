local service = record
    new: function(string, function(), ...:any): number
    query: function(string): number | nil
end

return service