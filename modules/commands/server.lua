local _LOGS <const> = Root.modules.Load('logs')
local _L <const> = Root.locale.Load()

Root.commands = {}

--- Register a new command
---@param name string
---@param category string
---@param description string
---@param callback function
local function register(name, category, description, callback, restricted)
    if not name or type(name) ~= 'string' then
        return warn("Register command: name must be a string")
    end

    if not category or type(category) ~= 'string' then
        return warn("Register command: category must be a string")
    end

    if not description or type(description) ~= 'string' then
        return warn("Register command: description must be a string")
    end

    Root.commands[category] = Root.commands[category] or {}
    Root.commands[category][name] = {
        description = description,
        restricted = restricted or false
    }

    RegisterCommand(name, function(s, a, r)
        callback(s, a, r)
        
        _LOGS.Send("commands", _L["new_command_executed"], _L["player_used_command"], {
            {
                name = _L["command"],
                value = "/" .. name,
                inline = true
            },
            {
                name = _L["description"],
                value = description,
                inline = true
            },
            {
                name = _L["category"],
                value = category,
                inline = true
            },
            {
                name = _L["ID"],
                value = (s == 0 and _L["console"] or s),
                inline = true
            },
            {
                name = _L["player"],
                value = (s == 0 and _L["console"] or GetPlayerName(s)),
                inline = true
            }
        })
    end, restricted or false)

    print(('[^5Root^7] Command ^3%s^7 registered in category ^3%s^7.'):format(name, category))
end

return {
    Register = register
}