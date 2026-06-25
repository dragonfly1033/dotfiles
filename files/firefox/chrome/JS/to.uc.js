function do_thing () {
    var d = new Date();
    var hour = d.getHours();
    var min = d.getMinutes();

    return 0;   

    if (
        // !(hour === 7 && 35 <= min && min <= 55) &&
        // !(hour === 12 && 30 <= min && min <= 55) &&
        // !(hour === 13 && 0 <= min && min <= 30) &&
        // !(hour === 16 && 20 <= min && min <= 55) &&
        // !(hour === 18 && 30 <= min && min <= 55) &&
        // !(hour === 19 && 30 <= min && min <= 59) &&
        !(hour === 21 && 30 <= min && min <= 59) &&
        !(hour >= 22)
        ){
            // cp.execSync("notify-send \"Not allowed during this time.\" \"Allowed times are: morning tea, afternoon tea, evening\"")
            window.close();
    } else {
        console.log("Good to go! Not Closing!")
    }
}



if (gBrowserInit.delayedStartupFinished) {
    do_thing();
} else {
    let delayedListener = (subject, topic) => {
        if (topic == "browser-delayed-startup-finished" && subject == window) {
            Services.obs.removeObserver(delayedListener, topic);
            do_thing();
        }
    };
    Services.obs.addObserver(delayedListener, "browser-delayed-startup-finished");
}
