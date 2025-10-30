---@class Root
---@field side 'server' | 'client'
local Root = {}
local _side <const> = (IsDuplicityVersion() and 'server') or 'client'

setmetatable(Root, {
    __index = {
        side = _side
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