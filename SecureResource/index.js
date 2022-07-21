const fs = require('fs');
const path = require('path');

const readline = require('readline').createInterface({
    input: process.stdin,
    output: process.stdout,
});

const ClientText = `RegisterNetEvent("CipeZen:sendFiles")
AddEventHandler("CipeZen:sendFiles",function (n,f)
    if n == "%s" then
        load(f)()
    end
end)`

function RequestPathResource() {
    readline.question(`Resource path (paste with right mouse): `, _path => {
        if (fs.existsSync(_path)) {
            let directory = fs.statSync(_path);
            if (directory.isDirectory()) {
                let directoryName = path.basename(_path);
                readline.question(`Resource Name \x1b[32m${directoryName}\x1b[0m (S/N):  `, correctName => {
                    correctName.replace(/\s/g, '');
                    if (correctName.toLowerCase() == "s") {
                        let allFiles = FindResouceLua(_path);
                        
                        if (allFiles) {
                            if (!allFiles.client_scripts) {
                                console.log("\x1b[31mNo client script\x1b[0m");
                                RequestPathResource();
                                return;
                            }
                            let countToReach = allFiles.client_scripts.length;
                            let count = 0;
                            let Config = JSON.parse(fs.readFileSync("ResourceConfig.json", "utf8"));
                            Config[directoryName] = { client: [] };
                            allFiles.client_scripts.forEach((script, index) => {
                                if (fs.existsSync(path.join(_path, script))) {
                                    let fileDir = path.dirname(script);
                                    let fileName = path.basename(script);

                                    if (script == fileName) fileDir = "";

                                    fs.mkdir(path.join("module", directoryName, fileDir), { recursive: true }, (err) => {
                                        if (err) throw err;
                                    });
                                    fs.copyFile(path.join(_path, script), path.join("module", directoryName, fileDir, fileName), (err) => {
                                        if (err) throw err;
                                        console.log(`- \x1b[32m${script} \x1b[33mCopied  from \x1b[33mclient\x1b[0m`);
                                        fs.writeFileSync(path.join(_path, script), ClientText.replace("%s", path.join(directoryName, script).replace(/\\/g, "/")), {
                                            encoding: 'utf8',
                                            flag: 'w'
                                        });
                                        Config[directoryName].client.push(path.join(directoryName, script).replace(/\\/g, "/"))
                                        console.log(`- \x1b[32m${script} \x1b[33mUpdated in the original resource\x1b[0m`);
                                        count++;

                                        if (count == countToReach) {
                                            fs.writeFileSync("ResourceConfig.json", JSON.stringify(Config), {
                                                encoding: 'utf8',
                                                flag: 'w'
                                            })
                                            console.log("\x1b[33mThe resource  \x1b[32m" + directoryName + "\x1b[33m has been secured\x1b[0m");
                                            RequestPathResource();
                                        }
                                    });
                                } else {
                                    count++
                                    if (count == countToReach) {
                                        fs.writeFileSync("ResourceConfig.json", JSON.stringify(Config), {
                                            encoding: 'utf8',
                                            flag: 'w'
                                        });
                                        console.log("\x1b[33mThe resource  \x1b[32m" + directoryName + "\x1b[33m has been secured\x1b[0m");
                                        RequestPathResource();
                                    }
                                }
                            });

                        } else {
                            console.log("\x1b[31mThe folder selected is not a resource\x1b[0m");
                            RequestPathResource();
                        }
                    } else {
                        RequestPathResource();
                    }
                });
            } else {
                console.log(`\x1b[33mYou have to select a folder !!\x1b[0m`);
                RequestPathResource();
            }
        } else {
            console.log(`\x1b[31mThe resource does not exist !!\x1b[0m`);
            RequestPathResource();
        }
    });
}

function FindResouceLua(_path) {
    let filePath = path.join(_path, "__resource.lua");
    let manifest = null;
    if (!fs.existsSync(filePath)) {
        filePath = path.join(_path, "fxmanifest.lua");
        if (!fs.existsSync(filePath)) {
            return false;
        } else {
            manifest = fs.readFileSync(filePath, 'utf8');
        }
    } else {
        manifest = fs.readFileSync(filePath, 'utf8');
    }

    let client_scripts = manifest.substring(manifest.indexOf("client_scripts") + 14);
    let server_scripts = null;

    if (manifest.indexOf("server_scripts") != -1) {
        server_scripts = manifest.substring(manifest.indexOf("server_scripts") + 15);
    } else if (manifest.indexOf("server_script") != -1) {
        server_scripts = manifest.substring(manifest.indexOf("server_script") + 14);
    }

    client_scripts = client_scripts.substring(client_scripts.indexOf("{") + 1);
    client_scripts = client_scripts.substring(0, client_scripts.indexOf("}"));
    server_scripts = server_scripts.substring(server_scripts.indexOf("{") + 1);
    server_scripts = server_scripts.substring(0, server_scripts.indexOf("}"));

    client_scripts = client_scripts.replace(/\s/g, '');
    client_scripts = client_scripts.replace(/\n/g, '');
    client_scripts = client_scripts.replace(/"/g, '');
    client_scripts = client_scripts.replace(/'/g, '');
    server_scripts = server_scripts.replace(/\s/g, '');
    server_scripts = server_scripts.replace(/\n/g, '');
    server_scripts = server_scripts.replace(/"/g, '');
    server_scripts = server_scripts.replace(/'/g, '');

    client_scripts = client_scripts.split(",").filter(Boolean);
    server_scripts = server_scripts.split(",").filter(Boolean);

    let equal_scripts = [];

    client_scripts.forEach((script) => {
        let fileDir = path.dirname(script);
        let fileName = path.basename(script);
        if (fileName == "*.lua") {
            fs.readdirSync(path.join(_path, fileDir)).forEach(file => {
                client_scripts.push(fileDir + "/" + file)
            })
            client_scripts.splice(client_scripts.indexOf(script), 1)
        }
    })

    server_scripts.forEach((script) => {
        let fileDir = path.dirname(script);
        let fileName = path.basename(script);
        if (fileName == "*.lua") {
            fs.readdirSync(path.join(_path, fileDir)).forEach(file => {
                server_scripts.push(fileDir + "/" + file)
            })
            server_scripts.splice(server_scripts.indexOf(script), 1)
        }
    })

    let clientDup = JSON.parse(JSON.stringify(client_scripts));

    client_scripts = [];

    for (let i = 0; i < clientDup.length; i++) {
        let script = clientDup[i];
        let index = server_scripts.indexOf(script)
        if (index != -1) {
            equal_scripts.push(script);
            server_scripts.splice(index, 1);
        }else {
            client_scripts.push(script);
        }
    }
    return { client_scripts, server_scripts, equal_scripts };
}

RequestPathResource()