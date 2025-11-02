RegisterNetEvent('__root:logs:send', function (webhook, title, description, fields, options)
    local _LOGS <const> = Root.modules.Load('logs')
    _LOGS.Send(webhook, title, description, fields, options)
end)