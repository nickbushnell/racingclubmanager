<cfajaxproxy cfc="races_server" jsclassname="races_proxy" />
<cfif IsDefined("URL.club")>
	<cfset g_clubId = "#URL.club#">
<cfelse>
	<cfif IsDefined("Cookie.defaultClub") is "True">
		<cfset g_clubId = "#Cookie.defaultClub#">
	<cfelse>
		<cfset g_clubId = "1">
	</cfif>
</cfif>
<html>
<head>
<title>Racing Club Manager - Upcoming Races</title>
<link href='http://fonts.googleapis.com/css?family=Monda:400' rel='stylesheet' type='text/css'>
<link href='nav_list.css' rel='stylesheet' type='text/css'>
<style type="text/css">
	body {
		margin: 0px;
		font-family: 'Monda', sans-serif;
		font-size: 10pt;
	}
	
	td {
		font-size: 10pt;
	}
	
	a {
		text-decoration: none;
	}
	
	#divRaceDetails {
		position: absolute;
		z-index: 500;
		top: 50px;
		width: 100%;
	}
</style>
<script type="text/javascript" src="include/jquery-1.11.1.min.js"></script>
<script language='javascript' src='common.js'></script>
<script>
	<cfoutput>
	var g_clubId = parseInt("#g_clubId#");
	</cfoutput>
	
	$(window).resize(function () { resizeOverlay() });
	
	function init() {
		getUpcomingRaces();
	}
	
	function getUpcomingRaces() {
		var instance = new races_proxy();
		instance.setCallbackHandler(fillUpcomingRaces);
		instance.get_all_upcoming_races(g_clubId);
	}
	
	function fillUpcomingRaces(result) {
		var tbl = document.getElementById("tblUpcoming");
		
		if(result.length > 0) {
			result = result + "<row>";
			var rows = result.split("<row>");
			rows.pop();
			for(var i=0; i<rows.length; i++) {
				
				var fields = rows[i].split("|");
				var race_id = fields[0]
				var race_name = decodeString(fields[1]);
				var series_name = decodeString(fields[2]);
				var race_date = displayDate(fields[3]);
				var track_name = decodeString(fields[4]);
				var length_type = fields[5];
				var length_value = fields[6];
				var dist_units = fields[7];
				var strRaceLen = "";
				
				if(length_type == "Distance") {
					strRaceLen = formatDistanceToString(length_value) + " " + dist_units;
				} else if(length_type == "Time") {
					strRaceLen = formatTimeToString(length_value);
				}
				
				if(series_name != "Individual Races") {
					race_name = series_name + " - " + race_name;
				}
				
				var row = tbl.insertRow(-1);
				row.style.backgroundColor = getRowColor(i);
				
				var cell = row.insertCell(-1);
				cell.innerHTML = race_date;
				
				cell = row.insertCell(-1);
				cell.innerHTML = "<a href='javascript:getRaceDetails(true," + race_id + ")' title='View details for this race'>" + race_name + "</a>";
				
				cell = row.insertCell(-1);
				cell.innerHTML = track_name;
				
				cell = row.insertCell(-1);
				cell.align = "left";
				cell.innerHTML = strRaceLen;
			}
		} else {
			var row = tbl.insertRow(-1);
			var cell = row.insertCell(-1);
			cell.align = "center";
			cell.colSpan = "4";
			cell.innerHTML = "There are no future races scheduled.";
		}
	}
	
	function viewAllFutureRaces() {
		window.location = "all_future_races.cfm?club=" + g_clubId;
	}
	
	function goBack() {
		window.location = "races_tab.cfm?club=" + g_clubId;
	}
	
	function getRaceDetails(bln, race_id) {
		if(bln) {
			var ptsHeight = parseInt(screen.availHeight)/1.5;
			var dlg = document.getElementById("divDialog");
			var frame = document.getElementById("frameDialog");

			dlg.style.display = "";
			frame.style.height = ptsHeight+"px";
			//document.getElementById("tblDialog").style.width = "900px";
			frame.style.width = "935px";
			dlg.style.top = "100px";
			
			var frameSrc = "race_details.cfm?club=" + g_clubId + "&race=" + race_id + "&dlg=1";
			frame.src = frameSrc;
			
			document.getElementById("spanDialogName").innerHTML = "Race Details";
			document.getElementById("linkDialogClose").setAttribute("onclick", "getRaceDetails(false,null)");
			showOverlay(true);
		} else {
			displayId('divDialog', 'none');
			showOverlay(false);
		}
	}
	
	function formatTimeToString(timeVal) {
		var timeArr = timeVal.split(":");
		var retVal = "";
		var h1 = "";
		var h2 = "";
		var m1 = "";
		var m2 = "";
		
		if(timeArr.length == 2) {
			var h = parseInt(timeArr[0]);
			var m = parseInt(timeArr[1]);

			if(h == 0) {
				h1 = "";
				h2 = "";
			} else if(h == 1) {
				h1 = "1";
				h2 = "h";
			} else if(h > 1) {
				h1 = h;
				h2 = "h";
			}
			
			if(m == 0) {
				m1 = "";
				m2 = "";
			} else if(m == 1) {
				m1 = "1";
				m2 = "m";
			} else if(m > 1) {
				m1 = m;
				m2 = "m";
			}
			
			retVal = h1 + "" + h2 + "" + m1 + "" + m2;
		} else {
			retVal = timeArr[0] + "m";
		}
		
		return retVal;
	}
	
	function formatDistanceToString(distVal) {
		var distArr = distVal.split(".");
		var retVal = "";
		
		if(distArr.length == 2) {
			// has a decimal
			// if everything after decimal = 0, don't show .000
			if(parseInt(distArr[1]) == 0) {
				retVal = distArr[0];
			} else {
				retVal = distVal;
			}
		} else {
			// just show [0]
			retVal = distArr[0];
		}
		
		return retVal;
	}

</script>

</head>
<body onload="init();">
<cfinclude template="include/navigation.cfm">
<cfinclude template="include/dialogs.cfm">

<div id="divRaceDetails" align="center" style="display: none;z-index:3000;">
	<table border="0" style="background-color: white;border: 2px solid #ccc;width: 60%;">
		<tr>
			<td align="right">
				<a href="javascript:displayId('divRaceDetails', 'none');showOverlay(false);">Close</a>
			</td>
		</tr>
		<tr>
			<td id="raceDetails">
				
			</td>
		</tr>
	</table>
</div>

<div style="width:100%;" align="center">
<h2>All Scheduled Races</h2>
<a href="javascript:goBack();">Back</a>
<table id="tblUpcoming" border="0" cellspacing="2" cellpadding="3" width="75%">
	<tr class="dataHeaderBG">
		<td align="center" class="dataHeaderTxt">
			<b>Date</b>
		</td>
		<td align="center" class="dataHeaderTxt">
			<b>Name</b>
		</td>
		<td align="center" class="dataHeaderTxt">
			<b>Track</b>
		</td>
		<td align="center" class="dataHeaderTxt">
			<b>Length</b>
		</td>
	</tr>
</table>
</div>






</body>
</html>
