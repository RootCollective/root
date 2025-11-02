local _LOGS <const> = Root.modules.Load('logs')
local _L <const> = Root.locale.Load()

AddEventHandler('playerConnecting', function(name, _, deferrals)
    local identifiers = {
        id = source,
        license = GetPlayerIdentifierByType(source, 'license') or 'unknown',
        discord = GetPlayerIdentifierByType(source, 'discord') or 'unknown',
        steam = GetPlayerIdentifierByType(source, 'steam') or 'unknown',
        fivem = GetPlayerIdentifierByType(source, 'fivem') or 'unknown',
        ip = GetPlayerEndpoint(source) or 'unknown',
        xbl = GetPlayerIdentifierByType(source, 'xbl') or 'unknown'
    }

    _LOGS.Send('player_connecting', _L["player_connecting"], "", {
        {
            name = _L["temp_id"],
            value = identifiers.id,
            inline = false
        },
        {
            name = _L["license"],
            value = identifiers.license,
            inline = false
        },
        {
            name = _L["discord_id"],
            value = (identifiers.discord == 'unknown' and 'unknown' or "<@" .. identifiers.discord:gsub('^discord:', '') .. ">"),
            inline = false
        },
        {
            name = _L["steam_id"],
            value = identifiers.steam,
            inline = false
        },
        {
            name = _L["fivem_id"],
            value = identifiers.fivem,
            inline = false
        },
        {
            name = _L["ip"],
            value = identifiers.ip,
            inline = false
        },
        {
            name = _L["xbl"],
            value = identifiers.xbl,
            inline = false
        },
    })

    deferrals.defer()
    Wait(50)
    deferrals.done()
end)

--- cdr == client drop reason
AddEventHandler('playerDropped', function(reason, _, cdr)
    local identifiers = {
        id = source,
        license = GetPlayerIdentifierByType(source, 'license') or 'unknown',
        discord = GetPlayerIdentifierByType(source, 'discord') or 'unknown',
        steam = GetPlayerIdentifierByType(source, 'steam') or 'unknown',
        fivem = GetPlayerIdentifierByType(source, 'fivem') or 'unknown',
        ip = GetPlayerEndpoint(source) or 'unknown',
        xbl = GetPlayerIdentifierByType(source, 'xbl') or 'unknown'
    }

    _LOGS.Send('player_disconnecting', _L["player_disconnecting"], cdr, {
        {
            name = _L["id"],
            value = identifiers.id,
            inline = false
        },
        {
            name = _L["license"],
            value = identifiers.license,
            inline = false
        },
        {
            name = _L["discord_id"],
            value = (identifiers.discord == 'unknown' and 'unknown' or "<@" .. identifiers.discord:gsub('^discord:', '') .. ">"),
            inline = false
        },
        {
            name = _L["steam_id"],
            value = identifiers.steam,
            inline = false
        },
        {
            name = _L["fivem_id"],
            value = identifiers.fivem,
            inline = false
        },
        {
            name = _L["ip"],
            value = identifiers.ip,
            inline = false
        },
        {
            name = _L["xbl"],
            value = identifiers.xbl,
            inline = false
        },
    })
end)