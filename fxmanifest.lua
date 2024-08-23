fx_version 'cerulean'

games { "gta5" }

author "qwadebot"
version '0.0.1'

lua54 'yes'

ui_page 'html/index.html'

client_scripts {
    "client/*.lua"
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "server/*.lua"
}

shared_scripts {
    "@ox_lib/init.lua",
}

files {
    'modules/**/*.lua',
    'html/**',
}
