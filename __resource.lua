client_scripts  {
    "client/controls.lua",
    "client/client.lua",
}

server_scripts  {
    "@mysql-async/lib/MySQL.lua",
    "server/server.lua",
    "server/commands.lua",
}


ui_page "html/index.html"

files {
    "html/index.html",
    "html/styles.css",
    "html/main.js",
}