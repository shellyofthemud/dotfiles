// ==UserScript==
// @name        Footprints Autoreload
// @namespace   Violentmonkey Scripts
// @match       https://help.oakland.edu/MRcgi/MRhomepage.pl
// @grant       GM_setValue
// @grant       GM_getValue
// @version     1.0
// @author      Sarenord
// @require     https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js
// @require     https://gist.githubusercontent.com/BrockA/2625891/raw/9c97aa67ff9c5d56be34a55ad6c18a314e5eb548/waitForKeyElements.js
// @description Adds a checkbox to automatically reload the page in Footprints Core every 60 seconds
// ==/UserScript==


function scheduleReload() {
    setInterval(function() {
	var clickEvent = document.createEvent('MouseEvents');
	clickEvent.initEvent("click", true, true);
	$("a[title|='Refresh Homepage']")[0].dispatchEvent (clickEvent);
    },60000);
}

function triggerMouseEvent (node, eventType) {
    var clickEvent = document.createEvent('MouseEvents');
    clickEvent.initEvent (eventType, true, true);
    node.dispatchEvent (clickEvent);
}

function toggleReload() {
    if (GM_getValue("reloadFootprints") == false) {
	GM_setValue("reloadFootprints", true);
	scheduleReload()
    } else {
	GM_setValue("reloadFootprints", false);
    }
}

function insertCheckBox() {
    console.log("Loaded Footprints Autoreload");
    var cbox = $("<input></input>", {id: "gm_autoreload", type: "checkbox"}).click(toggleReload);
    if (GM_getValue("reloadFootprints") == true) {
	$(cbox).attr("checked", true);
	scheduleReload();
    }
    $("#TableActions").append(cbox);
}

insertCheckBox();
