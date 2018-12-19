<cfajaxproxy cfc="leaders_server" jsclassname="leaders_proxy" />
<cfif IsDefined("URL.club")>
	<cfset g_clubId = "#URL.club#">
<cfelse>
	<cfif IsDefined("Cookie.defaultClub") is "True">
		<cfset g_clubId = "#Cookie.defaultClub#">
	<cfelse>
		<cfset g_clubId = "1">
	</cfif>
</cfif>

<cfset g_showNav = "True">
<cfif IsDefined("URL.nav")>
	<cfif "#URL.nav#" EQ "no">
		<cfset g_showNav = "False">
	</cfif>
<cfelse>
	<!--- nothing --->
</cfif>

<html>
<head>
<title>Racing Club Manager - Leaderboard</title>
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
	
	.yearSpan {
		border: 1px solid white;
		background-color: #263248;
		display: inline;
		cursor: pointer;
		color: white;
	}
	
	.monthSpan {
		border: 1px solid white;
		background-color: #263248;
		display: inline;
		cursor: pointer;
		color: white;
	}
	
	.yearDiv {
		padding: 3px;
	}
	
	.monthDiv {
		padding: 3px;
	}
</style>
<script type="text/javascript" src="include/jquery-1.11.1.min.js"></script>
<script language='javascript' src='common.js'></script>
<script>
	<cfoutput>
	var g_clubId = parseInt("#g_clubId#");
	</cfoutput>
	var today = new Date();
	var thisYear = today.getFullYear();
	var g_year = 0;
	var g_arr = [];
	var g_arr_years = [];
	var filterOn = "#FF9800";
	var filterOff = "#263248";
	var filterTxtOn = "black";
	var filterTxtOff = "white";
	var g_highlightRacerName = 0;
	
	$(window).resize(function () { resizeOverlay() });
	
	function init() {
		getDateFilters();
	}

	
	function getDateFilters() {
		var localDate = new Date();
		var UTCoffsetMinutes = localDate.getTimezoneOffset();
		
		var instance = new leaders_proxy();
		instance.setCallbackHandler(setUpFilters);
		instance.get_leaderboard_date_filters(g_clubId, UTCoffsetMinutes);
		
		// formula: UTC - local = offset
		// UTC = 0, EST = -240, 0 - -240 = +240
		// UTC = 0, AUS = +600, 0 - +600 = -600
		// so when we go to database we need to do DateAdd(minute, ABS(offsetMins), race_date) to get accurate days/months/years for the person viewing the content.
	}
	
	function setUpFilters(result) {
		if(result.length > 0) {
			result = result + "<row>";
			var rows = result.split("<row>");
			rows.pop();
			
			var tempYear = 0;
			var yearDiv = document.createElement("div");
			yearDiv.setAttribute("class", "yearDiv");
			var monthDiv;
			var masterDiv = document.createElement("div");
			
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				var month = parseInt(fields[0]);
				var monthName = "";
				var year = parseInt(fields[1]);
				
				switch (month) {
					case 1:
						monthName = "Jan";
						break;
					case 2:
						monthName = "Feb";
						break;
					case 3:
						monthName = "Mar";
						break;
					case 4:
						monthName = "Apr";
						break;
					case 5:
						monthName = "May";
						break;
					case 6:
						monthName = "Jun";
						break;
					case 7:
						monthName = "Jul";
						break;
					case 8:
						monthName = "Aug";
						break;
					case 9:
						monthName = "Sep";
						break;
					case 10:
						monthName = "Oct";
						break;
					case 11:
						monthName = "Nov";
						break;
					case 12:
						monthName = "Dec";
						break;
				}
				
				if(tempYear != year) {
					tempYear = year;
					g_arr_years.push(year);
					// add to year div
					var span = document.createElement("div");
					span.setAttribute("class", "yearSpan");
					span.id = "div_year_" + year;
					span.innerHTML = "&nbsp;&nbsp;&nbsp;" + year + "&nbsp;&nbsp;&nbsp;";
					span.onclick = function() { doYearClick(this) };
					yearDiv.appendChild(span);
					
					if(i>0) {
						masterDiv.appendChild(monthDiv);
					}
					
					// make new month div
					monthDiv = document.createElement("div");
					monthDiv.id = "div_months_in_" + year;
					monthDiv.setAttribute("class", "monthDiv");
					
					var allSpan = document.createElement("div");
					allSpan.setAttribute("class", "monthSpan");
					allSpan.id = "div_" + year + "_0";
					allSpan.innerHTML = "&nbsp;&nbsp;&nbsp;All&nbsp;&nbsp;&nbsp;";
					allSpan.onclick = function() { doMonthClick(this) };
					monthDiv.appendChild(allSpan);
				}
				
				// add to month div
				var monthSpan = document.createElement("div");
				monthSpan.setAttribute("class", "monthSpan");
				monthSpan.id = "div_" + year + "_" + month;
				monthSpan.innerHTML = "&nbsp;&nbsp;&nbsp;" + monthName + "&nbsp;&nbsp;&nbsp;";
				monthSpan.onclick = function() { doMonthClick(this) };
				monthDiv.appendChild(monthSpan);
			}
			
			if(rows.length == 1) {
				g_arr_years.push(year);
			}
			masterDiv.appendChild(monthDiv);
			masterDiv.insertBefore(yearDiv, masterDiv.firstChild);
			document.getElementById("cell_years").appendChild(masterDiv);
			
			
			// now fill the leaderboard with the latest month's data
			//alert("get leaderboard for " + g_arr_years[g_arr_years.length-1] + ", " + month);
			var getThisYear = g_arr_years[g_arr_years.length-1];
			doYearClick(document.getElementById("div_year_"+getThisYear))
			doMonthClick(document.getElementById("div_" + getThisYear + "_" + month))
		} else {
			// do nothing?
			fillLeaderboard([]);
		}
	}
	
	function doMonthClick(obj) {
		var objId = obj.id; // div_<year>_<month>
		var year = objId.split("_")[1];
		var month = objId.split("_")[2];
		
		turnOffMonths(year);
		obj.style.backgroundColor = filterOn;
		obj.style.color = filterTxtOn;
		
		getLeaderboard(year, month);
	}
	
	function doYearClick(obj) {
		var objId = obj.id; // div_year_<year>
		var year = objId.split("_")[2];
		
		turnOffYears();
		obj.style.backgroundColor = filterOn;
		obj.style.color = filterTxtOn;
		showMonths(year);
	}
	
	function turnOffMonths(year) {
		for(var i=0; i<13; i++) {
			var objId = "div_" + year + "_" + i;
			if(document.getElementById(objId)) {
				document.getElementById(objId).style.backgroundColor = filterOff;
				document.getElementById(objId).style.color = filterTxtOff;
			}
		}
	}
	
	function turnOffYears() {
		for(var i=0; i<g_arr_years.length; i++) {
			if(document.getElementById("div_year_" + g_arr_years[i])) {
				var obj = document.getElementById("div_year_" + g_arr_years[i]);
				obj.style.backgroundColor = filterOff;
				obj.style.color = filterTxtOff;
			}
		}
	}
	
	function showMonths(year) {
		// first turn off all month divs for all years
		for(var i=0; i<g_arr_years.length; i++) {
			var objId = "div_months_in_" + g_arr_years[i];
			if(document.getElementById(objId)) {
				document.getElementById(objId).style.display = "none";
			}
			turnOffMonths(g_arr_years[i]);
		}
		
		// now turn on the months div for the clicked year
		var objectId = "div_months_in_" + year;
		if(document.getElementById(objectId)) {
			document.getElementById(objectId).style.display = "";
		}
	}

	function getLeaderboard(theYear, theMonth) {
		g_year = theYear;
		var localDate = new Date();
		var UTCoffsetMinutes = localDate.getTimezoneOffset();
		
		//alert(g_clubId + ", " + theYear + ", " + theMonth + ", " + UTCoffsetMinutes)
		
		var instance = new leaders_proxy();
		instance.setCallbackHandler(parseResults);
		instance.get_leaderboard(g_clubId, theYear, theMonth, UTCoffsetMinutes);
	}
	
	function parseResults(result) {
		g_arr = [];
		if(result.length > 0) {
			result = result + "<row>";
			var rows = result.split("<row>");
			rows.pop();
			
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				g_arr.push(fields);
			}
		}
		
		fillLeaderboard(g_arr);
		highlightRacer();
	}
	
	function fillLeaderboard(arr) {
		// reset years
		var links = document.getElementsByTagName("a");
		for(var i=0; i<links.length; i++) {
			var thisLink = links[i];
			if(thisLink.id.indexOf("year_") > -1) {
				thisLink.style.color = "blue";
			}
		}
		
		// highlight selected year
		//document.getElementById("year_"+g_year.toString()).style.color = "red";
		
		var tbl = document.getElementById("tblLeaders");
		
		// remove rows from table before filling
		for(var i = tbl.rows.length - 1; i > 1; i--) {
			tbl.deleteRow(i);
		}

		if(arr.length > 0) {
			
			var pos = 0;
			var prevPoints = 0;
			
			for(var i=0; i<arr.length; i++) {
				
				var fields = arr[i];
				var racer_id = fields[0];
				var racer_name = decodeString(fields[1]);
				var points = fields[2];
				var best = fields[3];
				var worst = fields[4];
				var avgFinish = fields[5];
				var numPodiums = fields[6];
				var podiumPerc = fields[7];
				var numRaces = fields[8];
				
				if(points != prevPoints || i == 0) {
					pos++;
				}
				prevPoints = points;
				
				var row = tbl.insertRow(-1);
				row.style.backgroundColor = getRowColor(i);
				row.onclick = function() { doRacerClick(this) };
				
				var cell = row.insertCell(-1);
				cell.align = "center";
				cell.innerHTML = (pos).toString();
				
				cell = row.insertCell(-1);
				cell.innerHTML = racer_name;
				
				cell = row.insertCell(-1);
				cell.align = "center";
				cell.innerHTML = numRaces;
				
				cell = row.insertCell(-1);
				cell.align = "center";
				cell.innerHTML = points;
				
				cell = row.insertCell(-1);
				cell.align = "center";
				cell.innerHTML = best;
				
				cell = row.insertCell(-1);
				cell.align = "center";
				cell.innerHTML = worst;
				
				cell = row.insertCell(-1);
				cell.align = "center";
				cell.innerHTML = avgFinish;
				
				cell = row.insertCell(-1);
				cell.align = "center";
				cell.innerHTML = numPodiums;
				
				cell = row.insertCell(-1);
				cell.align = "center";
				cell.innerHTML = podiumPerc;
			}
		} else {
			var row = tbl.insertRow(-1);
			//row.style.backgroundColor = getRowColor(i);
			
			var cell = row.insertCell(-1);
			cell.align = "center";
			cell.innerHTML = "No results have been recorded yet.";
			cell.colSpan = "9";
		}
		
		//document.getElementById("tblYears").style.width = document.getElementById("tblLeaders").offsetWidth;
	}
	
	function doRacerClick(obj) {
		// if click same person again, removes highlight
		if(obj.cells[1].innerHTML == g_highlightRacerName) {
			g_highlightRacerName = "";
		} else {
			g_highlightRacerName = obj.cells[1].innerHTML;
		}
		
		highlightRacer();
	}
	
	function highlightRacer() {
		var tbl = document.getElementById("tblLeaders");
		for(var k=2; k<tbl.rows.length; k++) {
			if(tbl.rows[k].cells.length > 1) {
				var thisRacer = tbl.rows[k].cells[1].innerHTML;

				if(thisRacer == g_highlightRacerName) {
					// found a match
					
					tbl.rows[k].style.backgroundColor = "orange";
					
					//break; // exit the table rows loop
				} else {
					tbl.rows[k].style.backgroundColor = getRowColor(k);
				}
			} else {
				break;
			}
		}
	}
	

</script>

</head>
<body onload="init();">

<cfif g_showNav EQ "True">
<cfinclude template="include/navigation.cfm">
</cfif>
<cfinclude template="include/dialogs.cfm">
<div style="width:100%;" align="center">

<cfif g_showNav EQ "True">
<h2>Leaderboard</h2>
<br />
</cfif>

<table id="tblLeaders" border="0" cellspacing="2" cellpadding="3" width="75%">
	<tr>
		<td colspan="9" id="cell_years">
			&nbsp;
		</td>
	</tr>
	<tr class="dataHeaderBG">
		<td valign="middle" align="center" width="5%" class="dataHeaderTxt">
			<b>Pos</b>
		</td>
		<td valign="middle" align="center" width="28%" class="dataHeaderTxt">
			<b>Name</b>
		</td>
		<td valign="middle" align="center" width="6%" class="dataHeaderTxt">
			<b>Races</b>
		</td>
		<td valign="middle" align="center" width="8%" class="dataHeaderTxt">
			<b>Points</b>
		</td>
		<td valign="middle" align="center" width="12%" class="dataHeaderTxt">
			<b>Best<br />Finish</b>
		</td>
		<td valign="middle" align="center" width="12%" class="dataHeaderTxt">
			<b>Worst<br />Finish</b>
		</td>
		<td valign="middle" align="center" width="10%" class="dataHeaderTxt">
			<b>Avg<br />Finish</b>
		</td>
		<td valign="middle" align="center" width="8%" class="dataHeaderTxt">
			<b>Podiums</b>
		</td>
		<td valign="middle" align="center" width="10%" class="dataHeaderTxt">
			<b>Podium %</b>
		</td>
	</tr>
</table>
</div>






</body>
</html>
