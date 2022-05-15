const notifyContainer = document.getElementById("notify-container");
const helpNotifyContainer = document.getElementById("helpnotify-container");

function Notify(title, description, _time) {
    let time = _time || 5000;
    let randomInt = Math.floor(Math.random() * 1000000);
    let color = title.match(/~[^~]*~/g);
    let color2 = description.match(/~[^~]*~/g);
    let openSpan = false
    let openSpan2 = false
    if (color) {
        for (let i = 0; i < color.length; i++) {
            let d = color[i].replace(/~/g, "");
            if (d == "reset") {
                d = "white";
            }
            if (i == 0) {
                title = title.replace(color[i], `<span style="color: ${d}">`);
            } else {
                title = title.replace(color[i], `</span><span style="color: ${d}">`);
                openSpan = true
            }
        }
        if (openSpan) {
            title = title + "</span>"
        }
    }
    if (color2) {
        for (let i = 0; i < color2.length; i++) {
            let d = color2[i].replace(/~/g, "");
            if (d == "reset") {
                d = "#5a6253";
            }
            if (i == 0) {
                description = description.replace(color2[i], `<span style="color: ${d}">`);
            } else {
                description = description.replace(color2[i], `</span><span style="color: ${d}">`);
                openSpan2 = true
            }
        }
        if (openSpan2) {
            description = description + "</span>"
        }
    }
    notifyContainer.innerHTML = `
        <div data-aos-anchor="#parent" class="notify" notify="${randomInt}">
            <div class="notify-img">
                <ion-icon name="notifications-outline"></ion-icon>
            </div>
            <div class="notify-text">
                <div class="notify-title">
                    <span>
                        ${title}
                    </span>
                </div>
                <div class="notify-description">
                    ${description}
                </div>
            </div>
        </div>
    ` + notifyContainer.innerHTML;
    document.querySelector(`.notify[notify="${randomInt}"]`).classList.add("notify-show");
    setTimeout(() => {
        document.querySelector(`.notify[notify="${randomInt}"]`).classList.remove("notify-show");
    }, 550);
    setTimeout(() => {
        document.querySelector(`.notify[notify="${randomInt}"]`).remove();
    }, time);
}

function HelpNotify(title, description, _time) {
    let time = _time || 5000;
    let randomInt = Math.floor(Math.random() * 1000000);
    helpNotifyContainer.innerHTML = `
        <div data-aos-anchor="#parent" class="hnotify" notify="${randomInt}">
            <div class="notify-img">
                <ion-icon name="notifications-outline"></ion-icon>
            </div>
            <div class="notify-text">
                <div class="notify-title">
                    ${title}
                </div>
                <div class="notify-description">
                    ${description}
                </div>
            </div>
        </div>
    ` + helpNotifyContainer.innerHTML;
    setTimeout(() => {
        document.querySelector(`.hnotify[notify="${randomInt}"]`).remove();
    }, time);
    //let time = _time || 5000;
    //$(".notify-title").html(title);
    //$(".notify-description").html(description);
    //$(".hnotify").show();
    //setTimeout(() => {
    //    $(".hnotify").hide();
    //}, time);
}

window.addEventListener("message", function(event) {
    var data = event.data;
    switch (data.action) {
        case "notify":
            Notify(data.title, data.description, data.time);
            break;
        case "helpnotify":
            HelpNotify(data.title, data.description, data.time);
            break;
    }
});