---@class Root
---@field side 'server' | 'client'
---@field resource_name string
---@field lang string
---@field modules table<string, any>
---@field bridge table<string, any>
---@field locale table<string, string>
---@field LoadFile function
local Root = {}
local _side <const> = (IsDuplicityVersion() and 'server') or 'client'
local _resource_name <const> = GetCurrentResourceName()
local _lang = GetConvar('root:lang', 'en')

--- Load a file from the resource.
---@param path string
---@param type string
local function loadFile(path, type)
    if not path then
        return warn('loadFile: path is nil')
    end

    if not type then
        type = 'lua'
    end

    local file_path = ("%s.%s"):format(path, type)
    local file = LoadResourceFile(_resource_name, file_path)

    if not file then
        return warn('loadFile: file not found at path ^3' .. file_path .. '^7')
    end

    local _file

    if type == 'json' then
        _file = json.decode(file)
        if not _file then
            return warn('loadFile: failed to decode JSON at path ^3' .. file_path .. '^7')
        end
    else
        _file = load(file)()
        if not _file then
            return warn('loadFile: file failed to load at path ^3' .. file_path .. '^7')
        end
    end

    return _file
end

setmetatable(Root, {
    __index = {
        side = _side,
        resource_name = _resource_name,
        lang = _lang,

        LoadFile = loadFile,
    },

    __newindex = function(self, key, value)
        rawset(self, key, value)
    end,

    __call = function(self)
        if self.side then
            print('[^5Root^7] Root object initialized on ^3' .. self.side .. '^7 side.')
        end
    end
})

_ENV.Root = Root

Root()