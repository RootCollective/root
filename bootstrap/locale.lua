---@class Root.locale
---@field loaded table<string, string>
---@field Load function
Root.locale = {}
Root.locale.loaded = {}

--- Load a locale file from the resource.
---@param lang string
local function load(lang)
    if not lang then
        lang = Root.lang
    end

    if Root.locale.loaded[lang] then
        return Root.locale.loaded[lang]
    end

    Root.locale.loaded[lang] = Root.LoadFile(('locales/%s'):format(lang), 'json')

    if not Root.locale.loaded[lang] then
        return warn('Root.locale.Load: failed to load locale file for language ^3' .. lang .. '^7')
    end

    return Root.locale.loaded[lang], print('[^5Root^7] Locale ^3' .. lang .. '^7 loaded.')
end

setmetatable(Root.locale, {
    __index = {
        Load = load
    },

    __newindex = function(self, key, value)
        rawset(self, key, value)
    end
})