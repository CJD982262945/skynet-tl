local mongo = record

    MongoConf = record
		host : string
		port : number
		username : string
		password : string
		authmod : string
        authdb : string
        rs: {MongoConf} -- list
    end

    MongoWriteRet = record
        {any} -- TODO: writeConcernError writeErrors
        n: number
    end

    MongoCursor = record
        sort: function(MongoCursor, ...:any): MongoCursor
        skip: function(MongoCursor, number): MongoCursor
        limit: function(MongoCursor, number): MongoCursor
        count: function(MongoCursor, boolean): number
        hasNext: function(MongoCursor): boolean
        next: function(MongoCursor): MongoCursor
    end

    MongoCollection = record
        drop: function(MongoCollection): {any}
        dropIndex: function(MongoCollection, string): {any}
        safe_insert: function(MongoCollection, any): boolean, string, MongoWriteRet
        ensureIndex: function(MongoCollection, any, any)
        findOne: function(MongoCollection, any): {any: any}
        find: function(MongoCollection, any): MongoCursor
        delete: function(MongoCollection, any): boolean
    end

    MongoDB = record
        auth: function(MongoDB, string, string): boolean
        getCollection: function(MongoDB, string): MongoCollection
    end

    MongoClient = record
        getDB: function(MongoClient, string): MongoDB
        disconnect: function(MongoClient)
        genId: function(MongoClient): number
        runCommand: function(MongoClient, ...: any): any...
    end

    client: function(MongoConf): MongoClient
end

return mongo