local _GC <const> = GetConvar

local _DEFAULT_CONFIG <const> = {
    thumbnail = _GC('root:logs:thumbnail', 'https://i.imgur.com/ByFcoBF.png'),
    footer = {
        text = _GC('root:logs:footer:text', "Root Collective - Logs System"),
        icon_url = _GC('root:logs:footer:icon', "https://cdn.discordapp.com/attachments/1234567890/1234567890/root-icon.png")
    },
    color = GetConvarInt('root:logs:color', 15409736)
}

---@param url string
---@return boolean
local function isValidWebhook(url)
    if not url or type(url) ~= 'string' then
        return false
    end
    return url:match('^https://discord%.com/api/webhooks/%d+/[%w%-_]+$') ~= nil
end

---@param title string
---@param description string
---@param fields? table[]
---@param color? number
---@return table
local function buildEmbed(title, description, fields, color)
    local embed = {
        title = title or "Root Framework Log",
        description = description or "",
        color = color or _DEFAULT_CONFIG.color,
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        thumbnail = {
            url = _DEFAULT_CONFIG.thumbnail
        },
        footer = _DEFAULT_CONFIG.footer,
        fields = fields or {}
    }
    
    return embed
end

---@param webhookUrl string
---@param payload table
local function sendToDiscord(webhookUrl, payload)
    if not isValidWebhook(webhookUrl) then
        return warn('Root.logs: Invalid webhook URL provided')
    end
    
    local jsonPayload = json.encode(payload)
    
    PerformHttpRequest(webhookUrl, function(statusCode, response, headers)
        if statusCode == 204 then
            -- Success
        elseif statusCode == 429 then
            warn('Root.logs: Rate limited by Discord API')
        elseif statusCode >= 400 then
            warn(('Root.logs: Discord API error %d: %s'):format(statusCode, response or 'Unknown error'))
        end
    end, 'POST', jsonPayload, {
        ['Content-Type'] = 'application/json',
        ['User-Agent'] = 'Root-Framework/1.0'
    })
end

---@param webhook string
---@param title string
---@param description string
---@param fields? table[]
---@param options? table
local function send(webhook, title, description, fields, options)
    if not webhook or type(webhook) ~= 'string' then
        return warn('Root.logs.Send: webhook must be a string')
    end
    
    if not title or type(title) ~= 'string' then
        return warn('Root.logs.Send: title must be a string')
    end
    
    if not description or type(description) ~= 'string' then
        return warn('Root.logs.Send: description must be a string')
    end
    
    local webhookUrl = Root.cache.webhooks[webhook]
    if not webhookUrl then
        return warn(('Root.logs.Send: webhook "%s" not found in cache'):format(webhook))
    end
    
    if fields and type(fields) ~= 'table' then
        return warn('Root.logs.Send: fields must be a table')
    end
    
    if fields then
        for i, field in ipairs(fields) do
            if type(field) ~= 'table' or not field.name or not field.value then
                return warn(('Root.logs.Send: field %d must have name and value'):format(i))
            end
            
            if #field.name > 256 then
                field.name = field.name:sub(1, 253) .. "..."
            end
            if #field.value > 1024 then
                field.value = field.value:sub(1, 1021) .. "..."
            end
        end
    end
    
    options = options or {}
    local color = options.color or _DEFAULT_CONFIG.color
    
    local embed = buildEmbed(title, description, fields, color)
    
    local payload = {
        embeds = { embed }
    }
    
    sendToDiscord(webhookUrl, payload)
end

return {
    Send = send
}
