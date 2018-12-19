<cfajaxproxy cfc="404_server" jsclassname="ajax_proxy" />
<html>
<head>
<link href='http://fonts.googleapis.com/css?family=Monda:400' rel='stylesheet' type='text/css'>
<style type="text/css">
	body {
		background-color: #263248;
		font-family: 'Monda', sans-serif;
		color: #FF9800;
		font-size:12px;
		margin:0px;
	}
</style>
<script type="text/javascript" src="include/jquery-1.11.1.min.js"></script>
<script language='javascript' src='common.js'></script>
<script type="text/javascript">

$(window).resize(function () { init() });

function init() {
	var paths = window.location.href.split("=");
	var club_slug = paths[paths.length-1];
	findClubSlug(club_slug);
}

function show404() {
	document.getElementById("divIssues").style.display = "none";
	document.getElementById("divFailed").style.display = "";
	resizeText("divFailed", parseInt(document.body.offsetWidth), 12, 225, .99);
}

function resizeText(id, divWidth, fontControlSize, actualWidthAtCtrlSize, perc) {
	// font-size: 100px is actually 240px wide
	var logoMaxWidth = divWidth * perc; // get max width that the logo can be
	var ratio = logoMaxWidth / actualWidthAtCtrlSize;
	var newFontSize = Math.floor(ratio * fontControlSize);
	//alert(newFontSize);
	document.getElementById(id).style.fontSize = newFontSize + "px";
	//console.log(id + ": " + newFontSize);
}

function findClubSlug(club_slug) {
	var instance = new ajax_proxy();
	instance.setCallbackHandler(getClubSlug_callback);
	instance.get_club_slug(club_slug);
}

function getClubSlug_callback(result) {
	if(parseInt(result) > 0) {
		window.location.href = "club_home.cfm?club=" + result;
	} else {
		show404();
	}
}

</script>
</head>
<body onload="init()">
<cfinclude template="include/analytics.cfm" />
<cfinclude template="include/dialogs.cfm">

<div id="divIssues" align="center">
<!--
	<br /><br />
	<div style="font-size: 40px;">Loading...</h1>
	<br /><br />
	<div style="font-size: 20px;">
	Having issues? <a href="http://racingclubmanager.com/index.html?stay=yes" style="color:white;">Go Home</a> and search for the club you want, and we'll work on this issue. Sorry for the inconvenience.
	</h2>
-->
</div>

<div align="center" style="width: 100%;position:absolute;top:300px;display:none;" id="divFailed">
404 - PAGE NOT FOUND
<br />
<a href="/index.html?stay=yes" style="color: white;">Home</a>
</div>

</body>
</html>