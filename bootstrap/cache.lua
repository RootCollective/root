---@class Root.cache
---@field webhooks table<string, string>
---@field ranks table<string, table>
---@field garages table<string, table>
---@field blips table<string, table>
Root.cache = {}

if Root.side == 'server' then
    Root.cache = {
        webhooks = Root.LoadFile('data/webhooks', 'json'),
        ranks = Root.LoadFile('data/ranks', 'json'),
        garages = Root.LoadFile('data/garages', 'json')
    }
elseif Root.side == 'client' then
    Root.cache = {
        blips = Root.LoadFile('data/blips', 'json')
    }
end

setmetatable(Root.cache, {
    __index = { Load = load },
    __newindex = rawset
})