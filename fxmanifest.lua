game "gta5"
fx_version "cerulean"

client_scripts  {
    "Config.lua",
    "client/controls.lua",
    "client/client.lua"
}

server_scripts  {
    "Config.lua",
    "@mysql-async/lib/MySQL.lua",
    "server/server.lua",
    "server/commands.lua"
}


ui_page "html/index.html"

files {
    "html/index.html",
    "html/styles.css",
    "html/main.js"
}