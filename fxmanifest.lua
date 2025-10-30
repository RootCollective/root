--- @author Atoshi (discord: atoshic17)
--- Created at 2025-30-10
--- Copyright (c) RootCollective - All Rights Reserved

-- Resource metadata (https://docs.fivem.net/docs/scripting-reference/resource-manifest/resource-manifest/)
fx_version 'cerulean'
game 'gta5'

lua54 'yes' -- (https://docs.fivem.net/docs/scripting-reference/resource-manifest/resource-manifest/#lua54)
use_experimental_fxv2_oal 'yes' -- (https://docs.fivem.net/docs/scripting-reference/resource-manifest/resource-manifest/#use_experimental_fxv2_oal)

name 'Root'
author 'RootCollective'
description 'Root - Modular and optimized framework for FiveM.'
version '1.0.0'

-- Resource dependency
dependency 'oxmysql'

files {
    'locales/*.json',
    'bridges/**/**/*.lua',
    'modules/**/*.lua'
}

shared_scripts 'bootstrap/*.lua'

server_script '@oxmysql/lib/MySQL.lua'