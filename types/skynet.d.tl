
-- https://github.com/cloudwu/skynet/wiki/LuaAPI

local skynet = record

    -- 退出 skynet 进程
    abort: function()

    -- 给自身注册一个名字 (别名必须在 16 个字符以内）
    register: function(string)

    -- 为一个服务命名 skynet.name(name, skynet.self()) 和 skynet.register(name) 功能等价
    name: function(string, number)

    -- skynet.forward_type 将本服务实现为消息转发器，对一类消息进行转发。
    -- skynet.filter 过滤消息再处理。（注：filter 可以将 type, msg, sz, session, source 五个参数先处理过再返回新的 5 个参数。）
    -- skynet.monitor 给当前 skynet 进程设置一个全局的服务监控

    -- 每个服务都有一个 32bit 的数字地址，这个地址的高 8bit 表明了它所属的节点

    -- 获得服务自己的地址
    self: function(): number

    -- 用于获得服务所属的节点
    harbor: function(): number

    -- 用于把一个地址数字转换为一个可用于阅读的字符串
    address: function(number): string

    -- 用来查询一个 . 开头的名字对应的地址。它是一个非阻塞 API ，不可以查询跨节点的全局名字
    localname: function(string): number

    dispatch: function(typename: string, func: function(session: number, source: number, ...: any))

    PTYPE_TEXT : number
    PTYPE_RESPONSE : number
    PTYPE_MULTICAST : number
    PTYPE_CLIENT : number
    PTYPE_SYSTEM : number
    PTYPE_HARBOR : number
    PTYPE_SOCKET : number
    PTYPE_ERROR : number
    PTYPE_QUEUE : number
    PTYPE_DEBUG : number
    PTYPE_LUA : number
    PTYPE_SNAX : number
    PTYPE_TRACE : number

    Protocol = record
        name: string
        id: number
        pack: function(...: any): string
        unpack: function(...: any): string
    end

    -- 注册新的消息类别
    register_protocol: function(Protocol)

    -- 回应一个消息 它会将 message size 对应的消息附上当前消息的 session ，
    -- 以及 skynet.PTYPE_RESPONSE 这个类别，发送给当前消息的来源 source
    retpack: function(...:any): boolean
    pack: function(...:any): any, number
    ret: function(any, number): boolean --TODO: 处理 userdata
    -- 告诉框架你打算忽略这个 session 
    ignoreret: function()

    -- 返回的闭包可用于延迟回应。
    -- 调用它时，第一个参数通常是 true 表示是一个正常的回应，之后的参数是需要回应的数据。
    -- 如果是 false ，则给请求者抛出一个异常。它的返回值表示回应的地址是否还有效。
    -- 如果你仅仅想知道回应地址的有效性，那么可以在第一个参数传入 "TEST" 用于检测
    response: function(): function(...:any)

    -- 启动一个 C 服务
    launch: function(string, ...: any): number

    -- 用于启动一个新的 Lua 服务。
    -- name 是脚本的名字（不用写 .lua 后缀）。
    -- 只有被启动的脚本的 start 函数返回后，这个 API 才会返回启动的服务的地址，这是一个阻塞 API 。
    -- 如果被启动的脚本在初始化环节抛出异常，或在初始化完成前就调用 skynet.exit 退出，skynet.newservice 都会抛出异常。
    -- 如果被启动的脚本的 start 函数是一个永不结束的循环，那么 newservice 也会被永远阻塞住。
    newservice: function(string, ...: any): number

    -- 每个 skynet 服务都必须有一个启动函数。这一点和普通 Lua 脚本不同，传统的 Lua 脚本是没有专门的主函数，脚本本身即是主函数。
    -- 而 skynet 服务，你必须主动调用 skynet.start(function() ... end)
    start: function(function())

    -- 如果你想在 skynet.start 注册的函数之前做点什么，
    -- 可以调用 skynet.init(function() ... end)
    init: function( function())

    -- 用于退出当前的服务。skynet.exit 之后的代码都不会被运行。
    -- 而且，当前服务被阻塞住的 coroutine 也会立刻中断退出。
    -- 这些通常是一些 RPC 尚未收到回应。所以调用 skynet.exit() 请务必小心
    exit: function()
    
    --强行杀掉一个服务
    kill: function(number | string)
    
    -- 生成一个唯一 session 号
    genid: function(): number

    -- 这条 API 可以把一条类别为 typename 的消息发送给 address 。它会先经过事先注册的 pack 函数打包 ... 的内容
    send: function(...: any)

    -- 它会在内部生成一个唯一 session ，并向 address 提起请求，并阻塞等待对 session 的回应（可以不由 address --回应）。当消息回应后，还会通过之前注册的 unpack 函数解包。表面上看起来，就是发起了一次 RPC ，并阻塞等待回应。call 不支持超时，如果有超时的需求
    call: function(...: any): any...

    -- 它和 skynet.send 功能类似，但更细节一些。它可以指定发送地址（把消息源伪装成另一个服务），指定发送的消息的 session 。注：address 和 source --都必须是数字地址，不可以是别名。skynet.redirect 不会调用 pack ，所以这里的 ... 必须是一个编码过的字符串，或是 userdata 加一个长度。
    redirect: function(number | string, number, string, number, ...: any)

    rawcall: function(number | string, string, any, number): any...

    tostring: function(any, number): string -- 将这个 C 指针和长度翻译成 lua 的 string

    -- 带有 全局的 true 标示 暂时没用过
    uniqueservice: function(string, ...: any): number

    queryservice: function(string): number

    now: function(): number
    hpc: function(): number
    starttime: function(): number
    time: function(): number
    sleep: function(number, thread)

    timeout: function(number, function())

    fork: function(function(...: any), ...: any): thread
    wait: function(thread)
    wakeup: function(thread)

    error: function(...: any)
    trace: function(string)

    queue: function(): function(...: any)

    -- 1 MB = 1 * 1024 * 1024
    memlimit: function(number)

    stat: function(string): number | string
end

return skynet