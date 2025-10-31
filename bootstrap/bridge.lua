---@class Root.bridge
---@field loaded table<string, any>
---@field Load function
Root.bridge = {}
Root.bridge.loaded = {}

--- Load a bridge file from the resource.
---@param bridge_name string
---@param bridge_type string
local function load(bridge_name, bridge_type)
    if not bridge_name or not bridge_type then
        return warn('Root.bridge.Load: bridge_name or bridge_type is nil')
    end

    if not Root.bridge.loaded[bridge_name] then
        Root.bridge.loaded[bridge_name] = {}
    end

    if Root.bridge.loaded[bridge_name][bridge_type] then
        return Root.bridge.loaded[bridge_name][bridge_type]
    end

    Root.bridge.loaded[bridge_name][bridge_type] = Root.LoadFile(('bridges/%s/%s/%s'):format(bridge_name, bridge_type, Root.side), 'lua')

    if not Root.bridge.loaded[bridge_name][bridge_type] then
        return warn('Root.bridge.Load: failed to load bridge file for bridge ^3' .. bridge_name .. '^7 of type ^3' .. bridge_type .. '^7')
    end

    return Root.bridge.loaded[bridge_name][bridge_type], print('[^5Root^7] Bridge ^3' .. bridge_name .. '^7 of type ^3' .. bridge_type .. '^7 loaded.')
end

setmetatable(Root.bridge, {
    __index = {
        Load = load
    },

    __newindex = function(self, key, value)
        rawset(self, key, value)
    end
})