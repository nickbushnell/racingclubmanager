<cfajaxproxy cfc="flags_server" jsclassname="flags_proxy" />

<cfif IsDefined("URL.race")>
	<cfset g_raceId = "#URL.race#">
<cfelse>
	<cfset g_raceId = "-1">
</cfif>

<html>
<head>
<title>Racing Club Manager - Race Flags</title>
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
	
	.checkFlag {
		 position:absolute;
		 z-index: 2;
		 top: 0px;
		 width: 100%;
	}
	
	#divRaceName {
		font-size: 32px;
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
	var arrayDataDump = [];
	var pause = false;
	var myTimer;
	
	function init() {
		//var menuDiv = document.getElementById("divAllClubs");
		//menuDiv.style.backgroundColor = "#ccc";
		//menuDiv.style.opacity = ".80";
		//menuDiv.style.filter = "alpha(opacity=80)";
		//menuDiv.style.zIndex = "4";
		
		getRaceInfo();
	}
	
	function getRaceInfo() {
		var instance = new flags_proxy();
		instance.setCallbackHandler(getRaceInfo_callback);
		instance.get_race_info(g_raceId);
	}
	
	function getRaceInfo_callback(result) {
		var rows = getRows(result);
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E01" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		} else {
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				var race_name = decodeString(fields[0]);
				document.getElementById("divRaceName").innerHTML = race_name;
				
				getCurrentFlag();
			}
		}
	}
	
	function getCurrentFlag() {
		arrayDataDump.push(["START - get flag", Date()]);
		
		var instance = new flags_proxy();
		instance.setCallbackHandler(getCurrentFlag_callback);
		instance.get_current_flag(g_raceId);
	}
	
	function getCurrentFlag_callback(result) {
		var rows = getRows(result);
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E01" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		} else {
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				var flag_color = fields[0];
				
				if(flag_color == "warmup") {
					showFlag("finish",false);
					showFlag("warmup",true);
				} else if(flag_color == "finish") {
					showFlag("warmup",false);
					showFlag("finish", true);
				} else {
					showFlag("warmup",false);
					showFlag("finish",false);
					document.body.style.backgroundColor = flag_color;
				}
				
				arrayDataDump.push(["DONE - get flag: " + flag_color, Date()]);
				
				if(!pause) {
					setTimer();
				}
			}
		}
	}
	
	function showFlag(strId, bln) {
		var flag = document.getElementById(strId);
		var tbl = document.getElementById("tbl" + strId);
		document.body.style.backgroundColor = "white";
		if(bln) {
			flag.style.display = "";
			resizeCheckers(tbl);
		} else {
			flag.style.display = "none";
		}
	}
	
	function resizeCheckers(tbl) {
		var docHeight = parseInt(document.body.clientHeight);
		var checkerHeight = docHeight/9;
		for(var i=0; i<tbl.rows.length; i++) {
			var thisRow = tbl.rows[i];
			for(var k=0; k<thisRow.cells.length; k++) {
				var thisCell = thisRow.cells[k];
				thisCell.style.height = checkerHeight + "px";
			}
		}
	}
	
	function doPauseTimer() {
		var btn = document.getElementById("btnPause");
		
		if(!pause) {
			clearTimeout(myTimer);
			pause = true;
			btn.value = "Resume Auto Requests";
		} else {
			pause = false;
			setTimer();
			btn.value = "Pause Auto Requests";
		}
	}
	
	function setTimer() {
		myTimer = setTimeout(getCurrentFlag, 1000);
	}
	
	function doDataDump() {
		pause = false;
		doPauseTimer();
		var div = document.getElementById("divDataDump");
		div.innerHTML = ""; // clear current data
		for(var i=0; i<arrayDataDump.length; i++) {
			var newDiv = document.createElement("div");
			newDiv.innerHTML = "[" + arrayDataDump[i][1] + "]" + arrayDataDump[i][0];
			div.appendChild(newDiv); // NWB
		}
	}

</script>
</head>
<body onload="init()">
<!---
<cfinclude template="include/navigation.cfm">
--->
<cfinclude template="include/dialogs.cfm">

<br /><br />
<div style="width:100%;" align="center" id="pageContainer">
	
	<div style="position:relative; z-index: 3; width:50%; background-color: #ccc; padding: 10px; opacity:.80;filter: alpha(opacity=80);">
		<div id="divRaceName"></div>
		<!--
		<br />
		<input type="button" id="btnPause" value="Pause Auto Requests" onclick="doPauseTimer();" />
		
		<input type="button" id="btnDump" value="Dump Data Array" onclick="doDataDump();" />
		
		<div id="divDataDump"></div>
		-->
	</div>
	
	
	
	<div id="warmup" style="display: none;" class="checkFlag">
		<cfset strColor = "green">
		<cfset idx = 0>
		<table width="100%" id="tblwarmup" cellpadding="0" cellspacing="0">
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
	
	<div id="finish" style="display: none;" class="checkFlag">
		<cfset strColor = "black">
		<cfset idx = 0>
		<table width="100%" id="tblfinish" cellpadding="0" cellspacing="0">
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
	
</div>


	
</body>
</html>