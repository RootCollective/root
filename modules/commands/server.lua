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
    
    return RegisterCommand(name, callback, restricted or false), print(('[^5Root^7] Command ^3%s^7 registered in category ^3%s^7.'):format(name, category))
end

return {
    Register = register
}