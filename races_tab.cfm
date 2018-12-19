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
<title>Racing Club Manager - Races</title>
<link href='http://fonts.googleapis.com/css?family=Monda:400' rel='stylesheet' type='text/css'>
<link href='nav_list.css' rel='stylesheet' type='text/css'>
<style type="text/css">
	body {
		margin: 0px;
		font-family: 'Monda', sans-serif;
		font-size: 10pt;
		background-color: #fff;
		color: black
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
	var g_raceName = "";
	
	$(window).resize(function () { resizeOverlay() });
	
	function init() {
		getRecentResults();
	}

	function getRecentResults() {
		var instance = new races_proxy();
		instance.setCallbackHandler(fillRecentResults);
		instance.get_recent_results(g_clubId);
	}
	
	function getUpcomingRaces() {
		var instance = new races_proxy();
		instance.setCallbackHandler(fillUpcomingRaces);
		instance.get_upcoming_races(g_clubId);
	}
	
	function fillRecentResults(result) {
		var tbl = document.getElementById("tblRecent");
		
		if(result.length > 0) {
			result = result + "<row>";
			var rows = result.split("<row>");
			rows.pop();
			for(var i=0; i<rows.length; i++) {
				
				var fields = rows[i].split("|");
				var race_id = fields[0]
				var race_date = displayDate(fields[1]);
				var race_name = decodeString(fields[2]);
				var series_name = decodeString(fields[3]);
				var winner = fields[4];
				var second = fields[5];
				var third = fields[6];

				race_name = series_name + " - " + race_name;

				var row = tbl.insertRow(-1);
				
				row.style.backgroundColor = getRowColor(i);
				
				var cell = row.insertCell(-1);
				cell.innerHTML = race_date;
				cell.setAttribute("class","cellData");
				
				cell = row.insertCell(-1);
				cell.innerHTML = "<a href='javascript:getRaceDetails(true," + race_id + ")' title='View full results from this race'>" + race_name + "</a>";
				cell.setAttribute("class","cellData");
				
				cell = row.insertCell(-1);
				cell.innerHTML = winner;
				cell.setAttribute("class","cellData");
				
				cell = row.insertCell(-1);
				cell.innerHTML = second;
				cell.setAttribute("class","cellData");
				
				cell = row.insertCell(-1);
				cell.innerHTML = third;
				cell.setAttribute("class","cellData");
				
			}
		} else {
			var row = tbl.insertRow(-1);
			var cell = row.insertCell(-1);
			cell.align = "center";
			cell.colSpan = "5";
			cell.innerHTML = "No races have been completed.";
		}
		
		getUpcomingRaces();
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
				var track_name = fields[4];
				//var num_laps = fields[5];
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
				cell.setAttribute("class","cellData");
				
				cell = row.insertCell(-1);
				cell.innerHTML = "<a href='javascript:getRaceDetails(true," + race_id + ")' title='View details for this race'>" + race_name + "</a>";
				cell.setAttribute("class","cellData");
				
				cell = row.insertCell(-1);
				cell.innerHTML = track_name;
				cell.setAttribute("class","cellData");
				
				cell = row.insertCell(-1);
				cell.align = "left";
				cell.innerHTML = strRaceLen;
				cell.setAttribute("class","cellData");
				
			}
		} else {
			var row = tbl.insertRow(-1);
			var cell = row.insertCell(-1);
			cell.align = "center";
			cell.colSpan = "4";
			cell.innerHTML = "There are no future races scheduled.";
		}
	}
	
	function getRaceDetails(bln, race_id) {
		var frame = document.getElementById("frameDialog");
		if(bln) {
			var ptsHeight = parseInt(screen.availHeight)/1.5;
			var dlg = document.getElementById("divDialog");

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
			frame.src = "";
			displayId('divDialog', 'none');
			showOverlay(false);
		}
	}
	
	function viewAllRaces() {
		window.location = "all_races.cfm?club=" + g_clubId;
	}
	
	function viewAllFutureRaces() {
		window.location = "all_future_races.cfm?club=" + g_clubId;
	}
	
	function showDetails(elemId) {
		var elem = document.getElementById(elemId);
		if(elem.style.display == "") {
			elem.style.display = "none";
		} else {
			elem.style.display = "";
		}
		
		document.getElementById("overlay").style.height = document.body.scrollHeight;
	}
	
	var g_arr = [];
	var currSort = -1;
	function sortBy(col) {
		if(currSort == -1) {
			currSort = 0;
		} else {
			if(currSort == 0) {
				currSort = 1;
			} else {
				currSort = 0;
			}
		}
		
		if(currSort == 0) {
			g_arr.sort(function(a,b) {
				return a[col] - b[col];
			});
		} else {
			g_arr.sort(function(a,b) {
				return b[col] - a[col];
			});
		}
		
		fillRacers(g_arr);
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

<div id="divRaceDetails" align="center" style="display: none;z-index:3000">
	<table border="0" style="background-color: white;border: 2px solid #ccc;width: 60%;">
		<tr>
			<td width="10%">&nbsp;</td>
			<td align="center" width="80%">
				<span id="raceNameTitle" style="font-size:11pt;font-weight:bold;"></span>
			</td>
			<td align="right" width="10%">
				<a href="javascript:displayId('divRaceDetails', 'none');showOverlay(false);">Close</a>
			</td>
		</tr>
		<tr>
			<td id="raceDetails" colspan="3">
				
			</td>
		</tr>
	</table>
</div>

<div style="width:100%;" align="center">
<h3>Recent Results</h3>
<a href="javascript:viewAllRaces();" title="View all races ever for this club.">View All</a>
<br />
<table id="tblRecent" border="0" cellspacing="2" cellpadding="3" width="75%">
	<tr class="dataHeaderBG">
		<td align="center" class="dataHeaderTxt">
			Date
		</td>
		<td align="center" class="dataHeaderTxt">
			Name
		</td>
		<td align="center" class="dataHeaderTxt">
			Winner
		</td>
		<td align="center" class="dataHeaderTxt">
			Second
		</td>
		<td align="center" class="dataHeaderTxt">
			Third
		</td>
	</tr>
</table>

<br /><br />

<h3>Upcoming Races</h3>
<a href="javascript:viewAllFutureRaces();" title="View all future races for this club.">View All</a>
<br />
<table id="tblUpcoming" border="0" cellspacing="2" cellpadding="3" width="75%">
	<tr class="dataHeaderBG">
		<td align="center" class="dataHeaderTxt">
			Date
		</td>
		<td align="center" class="dataHeaderTxt">
			Name
		</td>
		<td align="center" class="dataHeaderTxt">
			Track
		</td>
		<td align="center" class="dataHeaderTxt">
			Length
		</td>
	</tr>
</table>
</div>






</body>
</html>
