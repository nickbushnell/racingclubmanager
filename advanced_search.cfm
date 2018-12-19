<cfajaxproxy cfc="advanced_search_server" jsclassname="club_proxy" />
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
<link href='http://fonts.googleapis.com/css?family=Monda:400' rel='stylesheet' type='text/css'>
<link href='nav_list.css' rel='stylesheet' type='text/css'>
<title>Racing Club Manager - Advanced Search</title>
<style type="text/css">

	body {
		background-color: #263248;
		font-family: 'Monda', sans-serif;
		color: #fff;
		margin:0px;
		font-size: 10pt;
	}
	
	td {
		font-size: 10pt;
		font-family: 'Monda', sans-serif;
	}
	
	select {
		font-family: 'Monda', sans-serif;
	}
	
	#pageTitle {
		color: #FF9800;
		font-size: 30px;
	}
	
	.resultsHeader {
		background-color: #FF9800;
	}
	
	.resultsData {
		color: #000;
	}
	
	.resultsHeaderTxt {
		color: #000;
	}

</style>
<cfinclude template="include/analytics.cfm" />
<cfoutput>
<script type="text/javascript">
	var g_clubId = parseInt("#g_clubId#");
</script>
</cfoutput>
<script language='javascript' src='common.js'></script>
<script type="text/javascript" src="include/jquery-1.11.1.min.js"></script>
<script type="text/javascript">
	
	$(window).resize(function () { resizeOverlay() });
	
	function init() {
		showLoadingDiv(true, "Loading...");
		getGames();
	}
	
	function getGames() {
		clearGames();
		var instance = new club_proxy();
		instance.setCallbackHandler(getGames_callback);
		instance.get_games();
	}
	
	function getGames_callback(result) {
		var sel = document.getElementById("selGames");
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E01" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		} else {
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				
				var game_id = parseInt(fields[0]);
				var game_name = fields[1];
				
				var opt = document.createElement("option");
				opt.value = game_id;
				sel.appendChild(opt);
				sel.options[sel.options.length-1].innerHTML = game_name;
			}
			
			showLoadingDiv(false, "");
		}
	}
	
	function clearGames() {
		var sel = document.getElementById("selGames");
		sel.options.length = 1;
	}

	
	function doSearch() {
		//hide the results table
		document.getElementById("tblResults").style.visibility = "hidden";
		
		
		
		// get game
		var game_id = parseInt(document.getElementById("selGames").value);
		// get #days
		var days = parseInt(document.getElementById("selDays").value);
		// if checkbox checked, get race times
		var h1 = 0;
		var h2 = 23;
		if(document.getElementById("chkTime").checked) {
			h1 = parseInt(document.getElementById("selHour1").value);
			var ap1 = document.getElementById("selAP1").value;
			if(ap1 == "pm" && h1 < 12) { // if pm add 12 hours, unless 12pm leave as 12
				h1 += 12;
			} else if(ap1 == "am" && h1 == 12) { // if 12am AKA midnight, 0 = midnight in T-SQL
				h1 = 0;
			}

			h2 = parseInt(document.getElementById("selHour2").value);
			var ap2 = document.getElementById("selAP2").value;
			if(ap2 == "pm" && h2 < 12) { // if pm add 12 hours, unless 12pm leave as 12
				h2 += 12;
			} else if(ap2 == "am" && h2 == 12) { // if 12am AKA midnight, 0 = midnight in T-SQL
				h2 = 0;
			}
		}
		
		if(game_id > 0 && days > 0 && days < 91 && h1 > -1 && h2 > -1) {
			// get offset minutes from local time to UTC time
			var localDate = new Date();
			var UTCoffsetMinutes = localDate.getTimezoneOffset();
			
			// clear the results table
			clearTableRows(document.getElementById("tblResults"), 1);
			
			var instance = new club_proxy();
			instance.setCallbackHandler(doSearch_callback);
			instance.get_search_results(game_id, h1, h2, UTCoffsetMinutes, days);
		} else {
			var errMsg = "One of your search criteria is invalid." + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		}
	}
	
	function doSearch_callback(result) {
		var tbl = document.getElementById("tblResults");
		var rows = getRows(result);
		
		if(result.length > 0) {
			if(rows[0] == "error") {
				var errMsg = "This page encountered an error: E01" + dlgCloseBtn;
				showLoadingDiv(true, errMsg);
			} else {
				var currClubName = "";
				for(var i=0; i<rows.length; i++) {
					var fields = rows[i].split("|");
					
					var club_id = parseInt(fields[0]);
					var club_name = decodeString(fields[1]);
					var personality = decodeString(fields[2]);
					var race_id = parseInt(fields[3]);
					var series_name = decodeString(fields[4]);
					var race_name = decodeString(fields[5]);
					var race_date = UTC2Local(fields[6]);
					
					race_name = series_name + " - " + race_name;
					
					var row = tbl.insertRow(-1);
					row.style.backgroundColor = getRowColor(i);
					
					if(currClubName != club_name) { // only show club and personality if it's the 1st one of the result set.
						currClubName = club_name;
						
						var cell = row.insertCell(-1);
						cell.innerHTML = "<a href='club_home.cfm?club=" + club_id + "' target='_blank'>" + club_name + "</a>";
						cell.setAttribute("class","resultsData");
						
						var cell = row.insertCell(-1);
						cell.innerHTML = personality;
						cell.setAttribute("class","resultsData");
					} else {
						var cell = row.insertCell(-1);
						cell.innerHTML = "&nbsp;";
						cell.setAttribute("class","resultsData");
						
						var cell = row.insertCell(-1);
						cell.innerHTML = "&nbsp;";
						cell.setAttribute("class","resultsData");
					}
					
					cell = row.insertCell(-1);
					cell.innerHTML = "<a href='javascript:getRaceDetails(true," + race_id + ", " + club_id + ")' title='View details for this race'>" + race_name + "</a>";
					cell.setAttribute("class","resultsData");
					
					var cell = row.insertCell(-1);
					cell.innerHTML = race_date;
					cell.setAttribute("class","resultsData");
					
				}
			}
		} else {
			var row = tbl.insertRow(-1);
			var cell = row.insertCell(-1);
			cell.colSpan = "4";
			cell.align = "center";
			cell.innerHTML = "No results match your criteria.";
		}
		
		// show the results table
		tbl.style.visibility = "visible";
	}
	
	function getRaceDetails(bln, race_id, club_id) {
		if(bln) {
			var ptsHeight = parseInt(screen.availHeight)/1.5;
			var dlg = document.getElementById("divDialog");
			var frame = document.getElementById("frameDialog");

			dlg.style.display = "";
			frame.style.height = ptsHeight+"px";
			//document.getElementById("tblDialog").style.width = "900px";
			frame.style.width = "935px";
			dlg.style.top = "100px";
			
			var frameSrc = "race_details.cfm?club=" + club_id + "&race=" + race_id + "&dlg=1";
			frame.src = frameSrc;
			
			document.getElementById("spanDialogName").innerHTML = "Race Details";
			document.getElementById("linkDialogClose").setAttribute("onclick", "getRaceDetails(false,null)");
			showOverlay(true);
		} else {
			displayId('divDialog', 'none');
			showOverlay(false);
		}
	}
	
	function raceTime_checked(obj) {
		if(!obj.checked) { // if unchecked re-set times to 12AM and 11PM
			document.getElementById("selHour1").selectedIndex = 11; // 12
			document.getElementById("selAP1").selectedIndex = 0;      // am
			document.getElementById("selHour2").selectedIndex = 10; // 11
			document.getElementById("selAP2").selectedIndex = 1;      // pm
		}
	}
	
	function clearTableRows(tbl, numKeepFromTop) {
		// this should delete all rows but the first one(our column headers)
		for(var i = tbl.rows.length - numKeepFromTop; i > 0; i--) {
			tbl.deleteRow(i);
		}
	}
	
	function checkRaceTime() {
		document.getElementById("chkTime").checked = true;
	}

</script>

</head>
<body onload="init();">
<cfinclude template="include/navigation.cfm">
<cfinclude template="include/dialogs.cfm">

<div id="divContainer" style="width:100%;" align="center">
	
	<div style="font-size:30px;">&nbsp;</div>
	
	<div id="pageTitle">
		Advanced Search
	</div>

	<table cellspacing="3" cellpadding="2" border="0">
		<tr>
			<td align="right">
				Game:
			</td>
			<td align="left">
				<select id="selGames" name="selGames" style="width:15em;">
					<option value="0">Select One...</option>
				</select>
			</td>
		</tr>
		<tr>
			<td align="center" colspan="2">
				<input type="checkbox" id="chkTime" name="chkTime" onclick="raceTime_checked(this);" />
				Race Time Between:
			</td>
		</tr>
		<tr>
			<td align="center" colspan="2">
				<select id="selHour1" name="selHour1" onchange="checkRaceTime()">
					<option value="1">1</option>
					<option value="2">2</option>
					<option value="3">3</option>
					<option value="4">4</option>
					<option value="5">5</option>
					<option value="6">6</option>
					<option value="7">7</option>
					<option value="8">8</option>
					<option value="9">9</option>
					<option value="10">10</option>
					<option value="11">11</option>
					<option value="12" selected>12</option>
				</select>
				<select id="selAP1" name="selAP1" onchange="checkRaceTime()">
					<option value="am">AM</option>
					<option value="pm">PM</option>
				</select>
				And
				<select id="selHour2" name="selHour2" onchange="checkRaceTime()">
					<option value="1">1</option>
					<option value="2">2</option>
					<option value="3">3</option>
					<option value="4">4</option>
					<option value="5">5</option>
					<option value="6">6</option>
					<option value="7">7</option>
					<option value="8">8</option>
					<option value="9">9</option>
					<option value="10">10</option>
					<option value="11" selected>11</option>
					<option value="12">12</option>
				</select>
				<select id="selAP2" name="selAP2" onchange="checkRaceTime()">
					<option value="am">AM</option>
					<option value="pm" selected>PM</option>
				</select>
			</td>
		</tr>
		<tr>
			<td align="center" colspan="2">
				Race in the next 
				<select name="selDays" id="selDays">
					<option value="1">1</option>
					<option value="3">3</option>
					<option value="7">7</option>
					<option value="10">10</option>
					<option value="14">14</option>
					<option value="30">30</option>
					<option value="60">60</option>
					<option value="90">90</option>
				</select>
				days
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<input type="button" id="btnSave" value="Search" onclick="doSearch();" />
			</td>
		</tr>
	</table>
	
	<div style="font-size:15px;">&nbsp;</div>
	
	<table cellspacing="3" cellpadding="2" border="0" width="75%" id="tblResults" style="visibility:hidden;">
		<tr class="resultsHeader">
			<td align="center" class="resultsHeaderTxt" width="25%">
				Club
			</td>
			<td align="center" class="resultsHeaderTxt" width="10%">
				Personality
			</td>
			<td align="center" class="resultsHeaderTxt" width="40%">
				Series - Race
			</td>
			<td align="center" class="resultsHeaderTxt" width="25%">
				Race Date/Time
			</td>
		</tr>
	</table>
	
</div>



</body>
</html>
