// ==UserScript==
// @onlyonce
// ==/UserScript==

// Script from here:  https://gist.github.com/jscher2000/ad268422c3187dbcbc0d15216a3a8060?permalink_comment_id=3259657#gistcomment-3259657

let lastModifiedStyle = 0;

function reloadSS(chromepath) {
    // read file
    var fstream = Cc["@mozilla.org/network/file-input-stream;1"]
        .createInstance(Ci.nsIFileInputStream);
    fstream.init(chromepath, 0x01, 0, 0);

    var sstream = Cc["@mozilla.org/scriptableinputstream;1"]
        .createInstance(Ci.nsIScriptableInputStream);
    sstream.init(fstream);

    var css = sstream.read(sstream.available());
    sstream.close();
    fstream.close();

    // extract :root variables
    let vars = [...css.matchAll(/--([\w-]+)\s*:\s*([^;]+);/g)];

    let windows = Services.wm.getEnumerator("navigator:browser");
    while (windows.hasMoreElements()) {
        let win = windows.getNext();
        let root = win.document.documentElement;

        for (let v of vars) {
            root.style.setProperty(`--${v[1]}`, v[2].trim());
        }
    }

    console.log("updated stylesheet")   
}


var ds = Cc["@mozilla.org/file/directory_service;1"].getService(Ci.nsIProperties);
var chromepath = ds.get("UChrm", Ci.nsIFile);
chromepath.append("style.css");
reloadSS(chromepath)
console.log("Loaded stylesheet first time")

Services.obs.addObserver((_win, topic) => {
    if (topic !== "browser-delayed-startup-finished") {
        return;
    }

    var ds = Cc["@mozilla.org/file/directory_service;1"]
        .getService(Ci.nsIProperties);
    var chromepath = ds.get("UChrm", Ci.nsIFile);
    chromepath.append("style.css");

    reloadSS(chromepath);
}, "browser-delayed-startup-finished");
console.log("added new window listener");

setInterval(() => {

    var ds = Cc["@mozilla.org/file/directory_service;1"].getService(Ci.nsIProperties);
    var chromepath = ds.get("UChrm", Ci.nsIFile);
    chromepath.append("style.css");

    if (chromepath.lastModifiedTime === lastModifiedStyle) {
        return;
    }

    lastModifiedStyle = chromepath.lastModifiedTime;

    reloadSS(chromepath)
}, 1000);

console.log("Loaded stylesheet reloader")
