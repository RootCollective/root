---@class Root.modules
---@field loaded table<string, any>
---@field Load function
---@field Unload function
Root.modules = {
    loaded = {}
}

--- Load a module from the resource.
---@param module string
---@return any? moduleObject
---@return string? message
local function load(module)
    if type(module) ~= 'string' or module:match('^%s*$') then
        warn('Root.modules.Load: module name must be a non-empty string')
        return nil, 'invalid module name'
    end

    if Root.modules.loaded[module] then
        return Root.modules.loaded[module], 'cached'
    end

    local path = ('modules/%s/%s'):format(module, Root.side)
    local chunk = Root.LoadFile(path)

    if not chunk then
        warn(('Root.modules.Load: module failed to load at path ^3%s^7'):format(path))
        return nil, 'load failed'
    end

    Root.modules.loaded[module] = chunk
    print(('[^5Root^7] Module ^3%s^7 loaded.'):format(module))
    return chunk, 'loaded'
end

--- Unload a module from the resource.
---@param module string
local function unload(module)
    if not module or type(module) ~= 'string' then
        return warn("Root.modules.Unload: module name must be a string")
    end

    if not Root.modules.loaded[module] then
        return warn("Root.modules.Unload: module not loaded")
    end

    Root.modules.loaded[module] = nil
    print(('[^5Root^7] Module ^3%s^7 unloaded.'):format(module))
end

setmetatable(Root.modules, {
    __index = { Load = load, Unload = unload },
    __newindex = rawset
})


if Root.side == "server" then
    Root.modules.Load('commands').Register('test', 'test', 'test', function(s, a, r)
        print('[^5Root^7] Command ^3test^7 executed by ^3console^7.')
    end, false)
end
