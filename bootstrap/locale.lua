---@class Root.locale
---@field loaded table<string, table>
---@field Load fun(lang?: string): table?
Root.locale = {
    loaded = {},
    fallback = 'en'
}

--- Load a locale file from the resource.
---@param lang? string
---@return table? data
---@return string? err
local function load(lang)
    lang = lang or Root.lang or Root.locale.fallback

    if Root.locale.loaded[lang] then
        return Root.locale.loaded[lang]
    end

    local data, err = Root.LoadFile(('locales/%s'):format(lang), 'json')
    if not data then
        return nil, ('locale "%s" not found: %s'):format(lang, err or 'unknown')
    end

    Root.locale.loaded[lang] = data
    print(('[^5Root^7] Locale ^3%s^7 loaded.'):format(lang))
    return data
end

setmetatable(Root.locale, {
    __index = {
        Load = load
    },
    __newindex = rawset
})