local crypt = record
    hashkey: function(string): string
    randomkey: function(): string
    desencode: function(string): string
    desdecode: function(string): string
    hexencode: function(string): string
    hexdecode: function(string): string
    -- hmac64: function()
    -- hmac64_md5: function()
    -- dhexchange: function()
    -- dhsecret: function()
    -- base64encode: function()
    -- base64decode: function()
    sha1: function(string): string
    hmac_sha1: function(string, string): string
    -- hmac_hash: function()
    -- xor_str: function()
end

return crypt