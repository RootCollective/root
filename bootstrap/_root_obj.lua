---@class Root
---@field side 'server' | 'client'
---@field resource_name string
---@field lang string
---@field modules table<string, any>
---@field bridge table<string, any>
---@field locale table<string, string>
---@field LoadFile fun(self: Root, path: string, type?: 'lua'|'json'): any
local Root = {}

local _SIDE <const> = (IsDuplicityVersion() and 'server') or 'client'
local _RESOURCE_NAME <const> = GetCurrentResourceName()
local _LANG <const> = GetConvar('root:lang', 'en')

--- Load a file from the resource.
---@param path string
---@param type? 'lua'|'json'  -- defaults to 'lua'
---@return any?  -- returns nil + warning on failure
local function loadFile(path, type)
    if type and (type ~= 'lua' and type ~= 'json') then
        warn('Root.LoadFile: invalid type provided')
        return nil
    end

    type = (type == 'json') and 'json' or 'lua'

    local file_path = ('%s.%s'):format(path, type)
    local file = LoadResourceFile(_RESOURCE_NAME, file_path)

    if not file then
        warn(('Root.LoadFile: file not found at path ^3%s^7'):format(file_path))
        return nil
    end

    local ok, result
    if type == 'json' then
        ok, result = pcall(json.decode, file)
        if not ok then
            warn(('Root.LoadFile: JSON decode failed at path ^3%s^7'):format(file_path))
            return nil
        end
    else
        ok, result = pcall(load(file))
        if not ok or result == nil then
            warn(('Root.LoadFile: Lua load failed at path ^3%s^7'):format(file_path))
            return nil
        end
    end

    collectgarbage('collect')

    return result
end

local mt = {
    __index = {
        side          = _SIDE,
        resource_name = _RESOURCE_NAME,
        lang          = _LANG,
        LoadFile      = loadFile,
    },

    __newindex = rawset,

    __call = function(self)
        print(('[^5Root^7] initialized on ^3%s^7 side'):format(self.side))
    end,
}

setmetatable(Root, mt)

_ENV.Root = Root

Root()
