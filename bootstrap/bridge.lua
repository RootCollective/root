---@class Root.bridge
---@field loaded table<string, string>
---@field Load function
Root.bridge = {
    loaded = {}
}

--- Load a bridge file from the resource.
---@param bridge_name string
---@param bridge_type string
---@return any? bridgeModule The loaded bridge module or nil on failure
local function load(bridge_name, bridge_type)
    if type(bridge_name) ~= 'string' or type(bridge_type) ~= 'string' or bridge_name == '' or bridge_type == '' then
        warn(('Root.bridge.Load: invalid arguments (bridge_name: %s, bridge_type: %s)'):format(tostring(bridge_name), tostring(bridge_type)))
        return nil
    end

    local cache = Root.bridge.loaded[bridge_name] or {}
    Root.bridge.loaded[bridge_name] = cache

    if cache[bridge_type] ~= nil then
        return cache[bridge_type]
    end

    local path = ('bridges/%s/%s/%s'):format(bridge_name, bridge_type, Root.side)
    local bridgeModule = Root.LoadFile(path, 'lua')

    if not bridgeModule then
        warn(('Root.bridge.Load: failed to load bridge file for bridge ^3%s^7 of type ^3%s^7'):format(bridge_name, bridge_type))
        return nil
    end

    cache[bridge_type] = bridgeModule
    print(('[^5Root^7] Bridge ^3%s^7 of type ^3%s^7 loaded.'):format(bridge_name, bridge_type))
    return bridgeModule
end

setmetatable(Root.bridge, {
    __index = { Load = load },
    __newindex = rawset
})