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


//time in milliseconds
function notifyBeep(time) {
    var ctx = new (window.AudioContext || webkit.webkitAudioContext)();

    var gainCurve = [.75, .65, .2, .05, .0];
    var gainInterval = (time/gainCurve.length)/1000;
    var gNode = ctx.createGain();
    gNode.connect(ctx.destination);
    for (var i=0; i<gainCurve.length; i++) {
	gNode.gain.setValueAtTime(gainCurve[i], i*gainInterval);
    }

    var osc=ctx.createOscillator();
    osc.type = 'sine';
    osc.frequency.setValueAtTime(440, ctx.currentTime);
    osc.connect(gNode);
    osc.start();

    setTimeout(() => {
	osc.stop();
    }, time);
}

function initTicketTracker() {
    var tmp = [];
    for (var i=0; i<10; i++) { tmp[i]="0"; }
    GM_setValue("recentTickets", tmp);
}

function updateTracker() {
    var newTicketP = false;
    var tickets = [];
    $("div.x-grid3-row").each((i, e) => { tickets[i] = $(e).find("span[title|=Edit]").text(); });
    var knownTickets = GM_getValue("recentTickets");
    for (let i=0; i<10; i++) {
	if ( knownTickets[i] != tickets[i] ) {
	    newTicketP = true;
	    knownTickets[i] = tickets[i];
	}
    }
    GM_setValue("recentTickets", knownTickets);

    return newTicketP;
}

function scheduleReload(time) {
    setTimeout(() => {
	if (updateTracker()) {
	    notifyBeep(400);
	}
    }, time-(time/4));

    setTimeout(() => {
	var clickEvent = document.createEvent('MouseEvents');
	clickEvent.initEvent("click", true, true);
	$("a[title|='Refresh Homepage']")[0].dispatchEvent (clickEvent);
    },time);
}

function toggleReload() {
    if (GM_getValue("reloadFootprints") == false) {
	GM_setValue("reloadFootprints", true);
	scheduleReload(120000);
    } else {
	GM_setValue("reloadFootprints", false);
    }
}

function insertCheckBox() {
    console.log("Loaded Footprints Autoreload");
    var cbox = $("<input></input>", {id: "gm_autoreload", type: "checkbox"}).click(toggleReload);
    if (GM_getValue("reloadFootprints") == true) {
	$(cbox).attr("checked", true);
	if (!GM_getValue("recentTickets")) { initTicketTracker(); }
	scheduleReload(30000);
    }
    $("#TableActions").append(cbox);
}

insertCheckBox();
