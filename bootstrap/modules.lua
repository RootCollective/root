---@class Root.modules
---@field loaded table<string, any>
---@field Load function
Root.modules = {}
Root.modules.loaded = {}

--- Load a module from the resource.
---@param module string
local function load(module)
    if not module then
        return warn('Root.modules.Load: module is nil')
    end

    if Root.modules.loaded[module] then
        return Root.modules.loaded[module]
    end

    Root.modules.loaded[module] = Root.LoadFile(('modules/%s/%s'):format(module, Root.side))

    if not Root.modules.loaded[module] then
        return warn(('Root.modules.Load: module failed to load at path ^3modules/%s/%s.lua^7'):format(module, Root.side))
    end

    
    return Root.modules.loaded[module], print('[^5Root^7] Module ^3' .. module .. '^7 loaded.')
end

setmetatable(Root.modules, {
    __index = {
        Load = load
    },

    __newindex = function(self, key, value)
        rawset(self, key, value)
    end
})