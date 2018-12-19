<cfajaxproxy cfc="admin_flags_server" jsclassname="admin_proxy" />
<cfif Not IsDefined("Session.club_id")>
	<cfset session.goto = "admin_flags.cfm">
	<cflocation url="login.cfm" addtoken="no">
</cfif>

<cfif Not IsDefined("Session.permission")>
	<cflocation url="logout.cfm" addtoken="no">
<cfelseif Session.permission GT 1>
	<cflocation url="logout.cfm?message=permission" addtoken="no">
</cfif>

<cfif IsDefined("URL.race")>
	<cfset g_raceId = "#URL.race#">
<cfelse>
	<cfset g_raceId = "-1">
</cfif>
<html>
<head>
<title>Racing Club Manager - Manage Race Flags</title>
<link href='nav_list.css' rel='stylesheet' type='text/css'>
<link href='http://fonts.googleapis.com/css?family=Monda:400' rel='stylesheet' type='text/css'>
<style type="text/css">
	body {
		margin: 0px;
		font-family: 'Monda', sans-serif;
		font-size: 10pt;
	}
	
	select {
		font-family: 'Monda', sans-serif;
		font-size: 10pt;
	}
	
	input {
		font-family: 'Monda', sans-serif;
		font-size: 10pt;
	}
	
	td {
		font-size: 10pt;
	}
	
	a {
		text-decoration: none;
	}

	
	#divLoading {
		position: absolute;
		top: 200px;
	}
	
	.flag {
		border: 10px solid #333;
		display: inline-block;
		cursor: pointer;
	}
	
	#green {
		background-color: green;
	}
	
	#yellow {
		background-color: yellow;
	}
	
	#red {
		background-color: red;
	}
	
	#divRaceName {
		font-size: 32px;
	}
	
	.keyboardBtn {
		background-color: #ccc;
		border: 1px solid #333;
	}
	
	#help {
		padding: 10px;
	}
</style>
<script type="text/javascript" src="include/jquery-1.11.1.min.js"></script>
<script language='javascript' src='common.js' async></script>
<cfoutput>
<script type="text/javascript">
	var g_raceId = parseInt("#g_raceId#");
</script>
</cfoutput>
<script type="text/javascript">
	if(!String.prototype.trim) {
		String.prototype.trim=function(){return this.replace(/(?:(?:^|\n)\s+|\s+(?:$|\n))/g,'').replace(/\s+/g,' ');};
	}
	
	//var g_raceId = 135; // Deutsche Tourenwagen Masters! - Hockenheimring Full
	var g_arrFlags = ["warmup","green", "yellow", "red", "finish"];
	var g_currFlag = ["warmup", "warmup"]; // [current, changing to]
	var strHighlightFlag = "10px solid #1a8cff";
	var strDefaultFlag = "10px solid #333";
	var g_intTimesKeptAlive = 0;
	var sessionMins = 5;
	var maxSessionHours = 5;
	
	document.onkeyup = function(e) {
	  doKeyUp(e.keyCode);
	}
	
	function doKeyUp(key) {
		//alert("key: " + key);
		// 37 = left arrow
		// 38 = right arrow
		// 13 = ENTER
		
		if(key == 37) {
			highlightFlag(-1);
		} else if(key == 39) {
			highlightFlag(1);
		} else if(key == 13 || key == 32) {
			changeFlagToSelected();
		} else {
			//alert(key);
		}
		
	}
	
	// keep the session active
	var activeSessionTimer = setTimeout(doSessionActive, 1000*60*sessionMins); // every # minutes, fire off a server request to keep the session active
	
	function doSessionActive() {
		var instance = new admin_proxy();
		instance.setCallbackHandler(doSessionActive_callback);
		instance.keep_session_active();
	}
	
	function doSessionActive_callback(result) {
		var rows = getRows(result);
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E01" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		} else {
			// good!
			g_intTimesKeptAlive++;
			if(g_intTimesKeptAlive < (maxSessionHours*60)/sessionMins) {
				var div = document.getElementById("keepAliveData");
				//div.innerHTML += "<br /> " + g_intTimesKeptAlive.toString() + ": " + Date();
				activeSessionTimer = setTimeout(doSessionActive, 1000*60*sessionMins);
			} else {
				var errMsg = "Your session has been active for more than 5 hours and will timeout soon if you do not interact with the site. " + Date() + dlgCloseBtn;
				showLoadingDiv(true, errMsg);
			}
		}
	}
	
	function init() {
		doResize();
		getRaceInfo();
	}
	
	function doResize() {
		// get size of page
		var docWidth = parseInt(document.body.clientWidth);
		var docHeight = parseInt(document.body.clientHeight);
		
		// divide by ??
		var divW = docWidth/6;
		var divH = docHeight/3;
		
		// set flags to width and height
		document.getElementById("green").style.width = divW.toString() + "px";
		document.getElementById("green").style.height = divH.toString() + "px";
		
		document.getElementById("yellow").style.width = divW.toString() + "px";
		document.getElementById("yellow").style.height = divH.toString() + "px";
		
		document.getElementById("red").style.width = divW.toString() + "px";
		document.getElementById("red").style.height = divH.toString() + "px";
		
		document.getElementById("warmup").style.width = divW.toString() + "px";
		document.getElementById("warmup").style.height = divH.toString() + "px";
		
		document.getElementById("finish").style.width = divW.toString() + "px";
		document.getElementById("finish").style.height = divH.toString() + "px";
		
		var checkerHeight = divH/9;
		var tbls = [document.getElementById("tblWarmup"),document.getElementById("tblFinish")];
		for(var t=0; t<tbls.length; t++) {
			for(var i=0; i<tbls[t].rows.length; i++) {
				var thisRow = tbls[t].rows[i];
				for(var k=0; k<thisRow.cells.length; k++) {
					var thisCell = thisRow.cells[k];
					thisCell.style.height = checkerHeight + "px";
				}
			}
		}
		
	}
	
	function getRaceInfo() {
		var instance = new admin_proxy();
		instance.setCallbackHandler(getRaceInfo_callback);
		instance.get_race_info(g_raceId);
	}
	
	function getRaceInfo_callback(result) {
		var rows = getRows(result);
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E02" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		} else {
			if(rows.length > 0) {
				for(var i=0; i<rows.length; i++) {
					var fields = rows[i].split("|");
					var race_name = decodeString(fields[0]);
					document.getElementById("divRaceName").innerHTML = race_name;
				}
			} else {
				var errMsg = "This page encountered an error: E03" + dlgCloseBtn;
				showLoadingDiv(true, errMsg);
			}
		}
	}
	
	function changeFlags(color) {
		resetDivs();
		
		g_currFlag[1] = color;
		
		var instance = new admin_proxy();
		instance.setCallbackHandler(changeFlags_callback);
		instance.change_flags(g_raceId, color);
	}
	
	function changeFlags_callback(result) {
		var rows = getRows(result);
		if(rows[0] == "error") {
			resetDivs();
			var errMsg = "This page encountered an error: E04" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		} else {
			// good!
			g_currFlag[0] = g_currFlag[1];
			document.getElementById(g_currFlag[0]).style.border = strHighlightFlag;
		}
	}
	
	function changeFlagToSelected() {
		// figure out which flag is selected
		// change to that flag
		changeFlags(g_currFlag[1]);
	}
	
	function highlightFlag(intDirection) {
		// change pos in array
		resetDivs();
		
		var currColor = g_currFlag[1];// current higlighted flag, not current selected flag
		var currArrIdx = -1;
		
		for(var i=0; i<g_arrFlags.length; i++) {
			if(g_arrFlags[i] == currColor) {
				currArrIdx = i;
				break;
			}
		}
		
		var newArrIdx = currArrIdx + intDirection;
		
		if(newArrIdx > g_arrFlags.length-1) { // if we went right while already at last flag, set to first flag
			newArrIdx = 0;
		} else if(newArrIdx == -1) { // if we went left while on first flag, set to last flag
			newArrIdx = g_arrFlags.length-1;
		}
		
		// highlight flag at pos in array
		g_currFlag[1] = g_arrFlags[newArrIdx];
		document.getElementById(g_currFlag[1]).style.border = strHighlightFlag;
		
	}
	
	function resetDivs() {
		document.getElementById("green").style.border = strDefaultFlag;
		document.getElementById("yellow").style.border = strDefaultFlag;
		document.getElementById("red").style.border = strDefaultFlag;
		document.getElementById("warmup").style.border = strDefaultFlag;
		document.getElementById("finish").style.border = strDefaultFlag;
	}

</script>
</head>
<body onload="init()">
<cfinclude template="include/navigation.cfm">
<cfinclude template="include/dialogs.cfm">

<br /><br />
<div style="width:100%;" align="center" id="pageContainer">
	
	<div id="divRaceName"></div>
	
	<div id="help">
		Click the flag you want your racers to see <br /> OR <br /> Use <span class="keyboardBtn">&larr;</span> <span class="keyboardBtn">&rarr;</span> to highlight a flag and use <span class="keyboardBtn">SPACE</span> or <span class="keyboardBtn">ENTER</span> to set the flag.
	</div>
	
	<div class="flag" id="warmup" onclick="changeFlags(this.id);">
		<cfset strColor = "green">
		<cfset idx = 0>
		<table width="100%" cellspacing="0" cellpadding="0" id="tblWarmup">
		<cfloop from="1" to="9" step="1" index="rows">
			<tr>
				<cfloop from="1" to="9" step="1" index="cols">
					<cfset idx = idx + 1>
					<cfif idx % 2 EQ 1>
						<cfset strColor = "yellow">
					<cfelse>
						<cfset strColor = "green">
					</cfif>
					<cfoutput>
					<td style="background-color: #strColor#" width="10%">
					</td>
					</cfoutput>
				</cfloop>
			</tr>
		</cfloop>
		</table>
	</div>
	
	<div class="flag" id="green" onclick="changeFlags(this.id);"></div>
	
	<div class="flag" id="yellow" onclick="changeFlags(this.id);"></div>
	
	<div class="flag" id="red" onclick="changeFlags(this.id);"></div>
	
	<div class="flag" id="finish" onclick="changeFlags(this.id);">
		<cfset strColor = "black">
		<cfset idx = 0>
		<table width="100%" cellspacing="0" cellpadding="0" id="tblFinish">
		<cfloop from="1" to="9" step="1" index="rows">
			<tr>
				<cfloop from="1" to="9" step="1" index="cols">
					<cfset idx = idx + 1>
					<cfif idx % 2 EQ 1>
						<cfset strColor = "white">
					<cfelse>
						<cfset strColor = "black">
					</cfif>
					<cfoutput>
					<td style="background-color: #strColor#" width="10%">
					</td>
					</cfoutput>
				</cfloop>
			</tr>
		</cfloop>
		</table>
	</div>
	
	<div id="keepAliveData">
	
	</div>
	
</div>


	
</body>
</html>