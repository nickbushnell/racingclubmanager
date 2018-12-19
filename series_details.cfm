<cfajaxproxy cfc="series_details_server" jsclassname="details_proxy" />
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
<cfset g_strNavQS = "">
<cfif IsDefined("URL.nav")>
	<cfif "#URL.nav#" EQ "no">
		<cfset g_showNav = "False">
		<cfset g_strNavQS = "&nav=no">
	</cfif>
<cfelse>
	<!--- nothing --->
</cfif>

<cfif IsDefined("URL.series")>
	<cfset g_seriesId = "#URL.series#">
<cfelse>
	<cfset g_seriesId = "-1">
</cfif>


<cfif IsDefined("URL.dlg")>
	<cfset g_dlg = "#URL.dlg#">
<cfelse>
	<cfset g_dlg = "0">
</cfif>

<cfif Find("racingclubmanager", CGI.SERVER_NAME) GT 0>
	<cfset thisURL = "http://racingclubmanager.com/series_details.cfm?club=" & g_clubId & "&series=" & g_seriesId>
<cfelse>
	<cfset thisURL = "http://clbmgr.com/rdt3/series_details.cfm?club=" & g_clubId & "&series=" & g_seriesId>
</cfif>

<cfset share_txt = "">
<cfquery name="seriesNameQRY" datasource="ds_rdt3">
	<cfoutput>
	EXEC [dbo].[get_series_share] #g_clubId#, #g_seriesId#
	</cfoutput>
</cfquery>

<cfoutput query="seriesNameQRY">
	<cfset share_txt = "#share_txt#">
</cfoutput>
<cfset share_txt = REPLACE(share_txt, "~chr35~", Chr(35), "ALL")>
<cfset share_txt = Replace(share_txt, "~chr34~", "", "All")>
<cfset share_txt = Replace(share_txt, "~chr39~", Chr(39), "All")>
<cfset share_txt = Replace(share_txt, "~chr60~", Chr(60), "All")>
<cfset share_txt = Replace(share_txt, "~chr62~", Chr(62), "All")>
<cfset share_txt = Replace(share_txt, "~chr124~", Chr(124), "All")>

<html>
<head>
<head prefix="og: http://ogp.me/ns# fb: http://ogp.me/ns/fb# rcm-club: http://ogp.me/ns/fb/rcm-club#">
<meta property="fb:app_id" content="1528583814052054" />
<meta property="og:type"   content="rcm-club:series" />
<cfoutput>
<meta property="og:url"    content="#thisURL#" />
<meta property="og:title"  content="#share_txt#" />
</cfoutput>

<cfif Find("racingclubmanager", CGI.SERVER_NAME) GT 0>
	<meta property="og:image"  content="http://racingclubmanager.com/imgs/fb_share_img.png" />
<cfelse>
	<meta property="og:image"  content="http://clbmgr.com/rdt3/imgs/fb_share_img.png" />
</cfif>


<link href='http://fonts.googleapis.com/css?family=Monda:400' rel='stylesheet' type='text/css'>
<link href='nav_list.css' rel='stylesheet' type='text/css'>
<title>Racing Club Manager</title>
<style type="text/css">

	body {
		/*background-color: #263248;*/
		background-color: #fff;
		font-family: 'Monda', sans-serif;
		color: #000;
		margin:0px;
		font-size: 10pt;
	}
	
	td {
		font-size: 10pt;
		/*font-family: 'Monda', sans-serif;*/
	}
	
	#seriesDescContainer {
		width:900px;
		background-color:#FF9800;
		cursor:pointer;
		color: #000;
		font-size: 14pt;
	}
	
	#racesContainer {
		width:900px;
		background-color:#FF9800;
		cursor:pointer;
		color: #000;
		font-size: 14pt;
	}
	
	#resultsContainer {
		width:900px;
		background-color:#FF9800;
		cursor:pointer;
		color: #000;
		font-size: 14pt;
	}
	
	#divClubName {
		font-size: 14pt;
	}
	
	#divName {
		font-size: 24pt;
	}
	
	#divDateTime {
		font-size: 16pt;
	}
	
	#divLapsTrack {
		font-size: 16pt;
	}
	
	.teamAbbr {
		color: #555;
		font-style:italic;
	}
	
	.resultsToggle {
		background-color: #263248;
		cursor: pointer;
		padding-left: 3px;
		padding-right: 3px;
		padding-top: 2px;
		padding-right: 2px;
	}
	
	.resultsToggle2 {
		background-color: #263248;
		cursor: pointer;
		padding-left: 3px;
		padding-right: 3px;
		padding-top: 2px;
		padding-right: 2px;
	}

</style>
<cfinclude template="include/analytics.cfm" />
<cfoutput>
<script type="text/javascript">
	var g_clubId = parseInt("#g_clubId#");
	var g_seriesId = parseInt("#g_seriesId#");
	var g_thisURL = "#thisURL#";
	var g_dlg = "#g_dlg#";
	var g_strNavQS = "#g_strNavQS#";
</script>
</cfoutput>
<script language='javascript' src='common.js'></script>
<script type="text/javascript" src="include/jquery-1.11.1.min.js"></script>
<script type="text/javascript">

	var g_seriesType = "Standard";
	var g_arrTeamsRacers = [];
	var g_strResultsType2 = "indiv";
	var g_arrTeams = [];
	
	$(window).resize(function () { doResize() });
	
	function init() {
		if(g_seriesId > 0) {
			doResize();
			getSeriesDetails();
		} else {
			doWhiteMsg("Error Loading Series" + dlgCloseBtn);
		}
	}
	
	function doResize() {
		resizeContainers();
	}
	
	function resizeContainers() {
		var seriesDescContainer = document.getElementById("seriesDescContainer");
		var divSeriesDesc = document.getElementById("divSeriesDesc");
		
		var racesContainer = document.getElementById("racesContainer");
		var divRacesList = document.getElementById("divRacesList");
		
		var resultsContainer = document.getElementById("resultsContainer");
		var divResults = document.getElementById("divResults");
		
		var body = parseInt(document.body.offsetWidth);
		if(body < 900) {
			seriesDescContainer.style.width = "100%";
			divSeriesDesc.style.width = "100%";
			racesContainer.style.width = "100%";
			divRacesList.style.width = "100%";
			resultsContainer.style.width = "100%";
			divResults.style.width = "100%";
		} else {
			seriesDescContainer.style.width = "900px";
			divSeriesDesc.style.width = "900px";
			racesContainer.style.width = "900px";
			divRacesList.style.width = "900px";
			resultsContainer.style.width = "900px";
			divResults.style.width = "900px";
		}
	}
	
	function getSeriesDetails() {
		var instance = new details_proxy();
		instance.setCallbackHandler(getSeriesDetails_callback);
		instance.get_series_details(g_clubId, g_seriesId);
	}
	
	function getSeriesDetails_callback(result) {
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			doWhiteMsg("This page encountered an error: E01" + dlgCloseBtn);
		} else {
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				
				var series_name = decodeString(fields[0]);
				var seriesDesc = decodeString(fields[1]);
				var club_name = decodeString(fields[2]);
				g_seriesType = fields[3];
				
				document.getElementById("divName").innerHTML = series_name;
				document.getElementById("divSeriesDesc").innerHTML = seriesDesc;
				document.getElementById("divClubName").innerHTML = club_name + " Presents";
			}
		}
	}
	
	function doWhiteMsg(msg) {
		var errMsg = msg;
		showLoadingDiv(true, errMsg);
		<cfif g_dlg EQ "1">
			document.getElementById("divLoading").style.top = "100px";
			document.getElementById("overlay").style.backgroundColor = "white";
		</cfif>
	}
	
	function showResults() {
		var div = document.getElementById("divResults");
		if(div.style.display == "") {
			div.style.display = "none";
			document.getElementById("teamsResultsOptions").style.display = "none";
			document.getElementById("seriesResultsCell_indiv").style.display = "none";
			document.getElementById("seriesResultsCell_privateer").style.display = "none";
			document.getElementById("seriesResultsCell_teams").style.display = "none";
		} else {
			//div.innerHTML = "";
			div.style.display = "";
			
			doWhiteMsg("Loading...");
			
			var instance = new details_proxy();
			instance.setCallbackHandler(showResults_callback);
			instance.get_series_leaderboard(g_clubId, g_seriesId, g_seriesType);
		}
	}
	
	function showResults_callback(result) {
		if(result == "typeError") {
			doWhiteMsg("This page encountered an error: E02" + dlgCloseBtn);
		} else {
			var resultSets = result.split("<resultSet>");
			var retArr = [];
			var ret = true;
			
			
			if(g_seriesType == "Teams") {
				document.getElementById("teamsResultsOptions").style.display = ""; // show buttons to toggle results tabs
				retArr.push(makeTeamNameArray(resultSets[2]));
				retArr.push(processMainLeaderboard(resultSets[0]));
				retArr.push(processTeamsLeaderboard(resultSets[1]));
				retArr.push(processPrivateerLeaderboard(resultSets[3]));
			} else if(g_seriesType == "Multi-Class") {
				retArr.push(processMCLeaderboard(resultSets[0]));
			} else if(g_seriesType == "Standard") {
				retArr.push(processMainLeaderboard(resultSets[0]));
			} else {
				doWhiteMsg("This page encountered an error: E03" + dlgCloseBtn);
			}
			
			for(var i=0; i<retArr.length; i++) {
				if(!retArr[i]) {
					ret = false;
					break;
				}
			}
			
			if(ret) {
				showLoadingDiv(false, "");
				toggleResults('indiv');
			}
		}
	}
	
	function processMainLeaderboard(result) {
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E04" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			return false;
		} else {
			buildStandingsTbl(rows);
			return true;
		}
	}
	
	function processTeamsLeaderboard(result) {
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E05" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			return false;
		} else {
			buildTeamStandingsTbl(rows);
			return true;
		}
	}
	
	function processMCLeaderboard(result) {
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E06" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			return false;
		} else {
			buildMCStandingsTbl(rows);
			return true;
		}
	}
	
	function processPrivateerLeaderboard(result) {
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E07" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			return false;
		} else {
			buildPrivateerStandingsTbl(rows);
			return true;
		}
	}
	
	function makeTeamNameArray(result) {
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E08" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			return false;
		} else {
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				var racer_id = parseInt(fields[0]);
				var racer_name = decodeString(fields[1]);
				var team_name = decodeString(fields[2]);
				g_arrTeams.push([racer_id, racer_name, team_name]);
			}
			return true;
		}
	}
	
	function getTeamName(racer_id) {
		var team_name = "";
		for(var i=0; i<g_arrTeams.length; i++) {
			if(parseInt(racer_id) == parseInt(g_arrTeams[i][0])) {
				team_name = g_arrTeams[i][2];
				break;
			}
		}
		
		return team_name;
	}
	
	function buildStandingsTbl(rows) {
		var div = document.getElementById("seriesResultsCell_indiv");
		div.style.display = "";
		div.innerHTML = "";
		
		var tbl = document.createElement("table");
		tbl.width = "100%";
		div.appendChild(tbl);
		
		if(rows.length <= 0) {
			var row = tbl.insertRow(-1);
			
			var cell = row.insertCell(-1);
			cell.innerHTML = "No Series Standings Yet";
			cell.align = "center";
		} else {
			var row = tbl.insertRow(-1);
			row.setAttribute("class","dataHeaderBG");
			
			var cell = row.insertCell(-1);
			cell.innerHTML = "Pos";
			cell.setAttribute("class", "dataHeaderTxt");
			cell.align = "center";
			
			cell = row.insertCell(-1);
			cell.innerHTML = "Name";
			cell.setAttribute("class", "dataHeaderTxt");
			cell.align = "center";
			
			if(g_seriesType == "Teams") {
				cell = row.insertCell(-1);
				cell.innerHTML = "Team";
				cell.setAttribute("class", "dataHeaderTxt");
				cell.align = "center";
			}
			
			cell = row.insertCell(-1);
			cell.innerHTML = "Races";
			cell.setAttribute("class", "dataHeaderTxt");
			cell.align = "center";
			
			cell = row.insertCell(-1);
			cell.innerHTML = "Pts";
			cell.setAttribute("class", "dataHeaderTxt");
			cell.align = "center";
			
			cell = row.insertCell(-1);
			cell.innerHTML = "Best";
			cell.setAttribute("class", "dataHeaderTxt");
			cell.align = "center";
			
			cell = row.insertCell(-1);
			cell.innerHTML = "Worst";
			cell.setAttribute("class", "dataHeaderTxt");
			cell.align = "center";
			
			cell = row.insertCell(-1);
			cell.innerHTML = "Avg";
			cell.setAttribute("class", "dataHeaderTxt");
			cell.align = "center";
			
			var pos = 0;
			var prevPoints = 0;
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");

				var name = decodeString(fields[1]);
				var points = parseInt(fields[2]);
				var best = parseInt(fields[3]);
				var worst = parseInt(fields[4]);
				var avg = parseFloat(fields[5]);
				if(isNaN(avg)) {
					avg = "N/A";
				}
				var numRaces = parseInt(fields[6]);
				
				if(points != prevPoints || i == 0) {
					pos++;
				}
				prevPoints = points;
				
				var row = tbl.insertRow(-1);
				row.style.backgroundColor = getRowColor(i);
				
				cell = row.insertCell(-1);
				cell.innerHTML = pos;
				cell.setAttribute("class", "cellData");
				cell.align = "center";
				
				cell = row.insertCell(-1);
				cell.innerHTML = name
				cell.setAttribute("class", "cellData");
				
				if(g_seriesType == "Teams") {
					cell = row.insertCell(-1);
					cell.innerHTML = getTeamName(fields[0]);
					cell.setAttribute("class", "cellData");
				}
				
				cell = row.insertCell(-1);
				cell.innerHTML = numRaces;
				cell.setAttribute("class", "cellData");
				cell.align = "center";
				
				cell = row.insertCell(-1);
				cell.innerHTML = points;
				cell.setAttribute("class", "cellData");
				cell.align = "center";
				
				cell = row.insertCell(-1);
				cell.innerHTML = best;
				cell.setAttribute("class", "cellData");
				cell.align = "center";
				
				cell = row.insertCell(-1);
				cell.innerHTML = worst;
				cell.setAttribute("class", "cellData");
				cell.align = "center";
				
				cell = row.insertCell(-1);
				cell.innerHTML = avg;
				cell.setAttribute("class", "cellData");
				cell.align = "center";
			}
		}
	}
	
	function buildTeamStandingsTbl(rows) {
		var div = document.getElementById("seriesResultsCell_teams");
		div.style.display = "";
		div.innerHTML = "";
		
		//var br = document.createElement("br");
		var tbl = document.createElement("table");
		tbl.width = "100%";
		//div.appendChild(br);
		div.appendChild(tbl);
		
		if(rows.length <= 0) {
			var row = tbl.insertRow(-1);
			
			var cell = row.insertCell(-1);
			cell.innerHTML = "&nbsp;";
			cell.align = "center";
		} else {

			row = tbl.insertRow(-1);
			row.setAttribute("class","dataHeaderBG");
			
			cell = row.insertCell(-1);
			cell.innerHTML = "Pos";
			cell.setAttribute("class", "dataHeaderTxt");
			cell.align = "center";
			cell.width = "10%";
			
			cell = row.insertCell(-1);
			cell.innerHTML = "Team";
			cell.setAttribute("class", "dataHeaderTxt");
			cell.align = "center";
			cell.width = "80%";
			
			cell = row.insertCell(-1);
			cell.innerHTML = "Pts";
			cell.setAttribute("class", "dataHeaderTxt");
			cell.align = "center";
			cell.width = "10%";
			
			var pos = 0;
			var prevPoints = 0;
			
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				
				var row = tbl.insertRow(-1);
				row.style.backgroundColor = getRowColor(i);
				
				var name = decodeString(fields[0]);
				//var abbr = decodeString(fields[1]);
				var points = parseInt(fields[2]);
				
				if(points != prevPoints || i == 0) {
					pos++;
				}
				prevPoints = points;
				
				cell = row.insertCell(-1);
				cell.innerHTML = pos;
				cell.setAttribute("class", "cellData");
				cell.align = "center";
				
				cell = row.insertCell(-1);
				cell.innerHTML = name;// + "<span class='teamAbbr'> - " + abbr + "</span>";
				cell.setAttribute("class", "cellData");
				
				cell = row.insertCell(-1);
				cell.innerHTML = points;
				cell.setAttribute("class", "cellData");
				cell.align = "center";
			}
		}
	}
	
	function teamWasNotProcessed(teamName, arr) {
		for(var i=0; i<arr.length; i++) {
			if(arr[i] == teamName) {
				return false;
			}
		}
		
		return true;
	}
	
	function buildPrivateerStandingsTbl(rows) {
		var div = document.getElementById("seriesResultsCell_privateer");
		div.style.display = "";
		div.innerHTML = "";
		
		var tbl = document.createElement("table");
		tbl.width = "100%";
		div.appendChild(tbl);
		
		if(rows.length <= 0) {
			var row = tbl.insertRow(-1);
			
			var cell = row.insertCell(-1);
			cell.innerHTML = "No Series Standings Yet";
			cell.align = "center";
		} else {
			var row = tbl.insertRow(-1);
			row.setAttribute("class","dataHeaderBG");
			
			var cell = row.insertCell(-1);
			cell.innerHTML = "Pos";
			cell.setAttribute("class", "dataHeaderTxt");
			cell.align = "center";
			
			cell = row.insertCell(-1);
			cell.innerHTML = "Name";
			cell.setAttribute("class", "dataHeaderTxt");
			cell.align = "center";
			
			cell = row.insertCell(-1);
			cell.innerHTML = "Races";
			cell.setAttribute("class", "dataHeaderTxt");
			cell.align = "center";
			
			cell = row.insertCell(-1);
			cell.innerHTML = "Pts";
			cell.setAttribute("class", "dataHeaderTxt");
			cell.align = "center";
			
			cell = row.insertCell(-1);
			cell.innerHTML = "Best";
			cell.setAttribute("class", "dataHeaderTxt");
			cell.align = "center";
			
			cell = row.insertCell(-1);
			cell.innerHTML = "Worst";
			cell.setAttribute("class", "dataHeaderTxt");
			cell.align = "center";
			
			cell = row.insertCell(-1);
			cell.innerHTML = "Avg";
			cell.setAttribute("class", "dataHeaderTxt");
			cell.align = "center";
			
			var pos = 0;
			var prevPoints = 0;
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");

				var name = decodeString(fields[1]);
				var points = parseInt(fields[2]);
				var best = parseInt(fields[3]);
				var worst = parseInt(fields[4]);
				var avg = parseFloat(fields[5]);
				if(isNaN(avg)) {
					avg = "N/A";
				}
				var numRaces = parseInt(fields[6]);
				
				if(points != prevPoints || i == 0) {
					pos++;
				}
				prevPoints = points;
				
				var row = tbl.insertRow(-1);
				row.style.backgroundColor = getRowColor(i);
				
				cell = row.insertCell(-1);
				cell.innerHTML = pos;
				cell.setAttribute("class", "cellData");
				cell.align = "center";
				
				cell = row.insertCell(-1);
				cell.innerHTML = name
				cell.setAttribute("class", "cellData");
				
				cell = row.insertCell(-1);
				cell.innerHTML = numRaces;
				cell.setAttribute("class", "cellData");
				cell.align = "center";
				
				cell = row.insertCell(-1);
				cell.innerHTML = points;
				cell.setAttribute("class", "cellData");
				cell.align = "center";
				
				cell = row.insertCell(-1);
				cell.innerHTML = best;
				cell.setAttribute("class", "cellData");
				cell.align = "center";
				
				cell = row.insertCell(-1);
				cell.innerHTML = worst;
				cell.setAttribute("class", "cellData");
				cell.align = "center";
				
				cell = row.insertCell(-1);
				cell.innerHTML = avg;
				cell.setAttribute("class", "cellData");
				cell.align = "center";
			}
		}
	}
	
	function buildMCStandingsTbl(rows) {
		var div = document.getElementById("divResults");
		div.style.display = "";
		div.innerHTML = "";
		
		var tbl = document.createElement("table");
		tbl.width = "100%";
		div.appendChild(tbl);
		
		var row = tbl.insertRow(-1);
		var cell = row.insertCell(-1);
		cell.colSpan = "6";
		cell.align = "center";
		
		if(rows.length <= 0) {
			cell.innerHTML = "No Race Results Recorded";
		} else {
			
			// extract the class names
			var teams = [];
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				var team_abbr = decodeString(fields[7]);
				
				if(teamWasNotProcessed(team_abbr, teams)) {
					teams.push(team_abbr);
				}
			}
			
			// make definitive arrays for each class
			for(var i=0; i<teams.length; i++) {
				var definitiveArr = [];
				
				for(var k=0; k<rows.length; k++) {
					var fields = rows[k].split("|");
					
					var team_abbr = decodeString(fields[7]);
					if(team_abbr == teams[i]) {
						var name = decodeString(fields[1]);
						var pts = parseInt(fields[2]);
						var best = parseInt(fields[3]);
						var worst = parseInt(fields[4]);
						var avg = parseFloat(fields[5]);
						var numRaces = parseInt(fields[6]);
						
						definitiveArr.push([name, pts, best, worst, avg, numRaces]);
						g_arrTeamsRacers.push([name, team_abbr]);
					}
				}
				
				// sort the definitive array by total points descending
				definitiveArr.sort(function(a,b) {
					return b[1] - a[1];
				});
				
				buildTblForClass(tbl, teams[i], definitiveArr);
			}
		}
	}
	
	function buildTblForClass(tbl, team, arr) {
		var pos = 0;
		var prevPoints = 0;
		var row;
		var cell;
		for(var i=0; i<arr.length; i++) {
			if(i == 0) {
				row = tbl.insertRow(-1);
				row.setAttribute("class","dataHeaderBG");
				
				cell = row.insertCell(-1);
				cell.colSpan = "7";
				cell.setAttribute("class", "dataHeaderTxt");
				cell.innerHTML = team;
				cell.align = "center";
				
				row = tbl.insertRow(-1);
				row.setAttribute("class","dataHeaderBG");
				
				cell = row.insertCell(-1);
				cell.innerHTML = "Pos";
				cell.setAttribute("class", "dataHeaderTxt");
				cell.align = "center";
				
				cell = row.insertCell(-1);
				cell.innerHTML = "Name";
				cell.setAttribute("class", "dataHeaderTxt");
				cell.align = "center";

				cell = row.insertCell(-1);
				cell.innerHTML = "Races";
				cell.setAttribute("class", "dataHeaderTxt");
				cell.align = "center";
				
				cell = row.insertCell(-1);
				cell.innerHTML = "Pts";
				cell.setAttribute("class", "dataHeaderTxt");
				cell.align = "center";
				
				cell = row.insertCell(-1);
				cell.innerHTML = "Best";
				cell.setAttribute("class", "dataHeaderTxt");
				cell.align = "center";
				
				cell = row.insertCell(-1);
				cell.innerHTML = "Worst";
				cell.setAttribute("class", "dataHeaderTxt");
				cell.align = "center";
				
				cell = row.insertCell(-1);
				cell.innerHTML = "Avg";
				cell.setAttribute("class", "dataHeaderTxt");
				cell.align = "center";
			}

			var name = arr[i][0];
			var points = arr[i][1];
			var best = arr[i][2];
			var worst = arr[i][3];
			var avg = arr[i][4];
			var numRaces = arr[i][5];
			
			if(points != prevPoints || i == 0) {
				pos++;
			}
			prevPoints = points;
			
			var row = tbl.insertRow(-1);
			row.style.backgroundColor = getRowColor(i);
			
			var cell = row.insertCell(-1);
			cell.innerHTML = pos;
			cell.setAttribute("class", "cellData");
			cell.align = "center";
			
			cell = row.insertCell(-1);
			cell.innerHTML = name;
			cell.setAttribute("class", "cellData");
			
			cell = row.insertCell(-1);
			cell.innerHTML = numRaces;
			cell.setAttribute("class", "cellData");
			cell.align = "center";
			
			cell = row.insertCell(-1);
			cell.innerHTML = points;
			cell.setAttribute("class", "cellData");
			cell.align = "center";
			
			cell = row.insertCell(-1);
			cell.innerHTML = best;
			cell.setAttribute("class", "cellData");
			cell.align = "center";
			
			cell = row.insertCell(-1);
			cell.innerHTML = worst;
			cell.setAttribute("class", "cellData");
			cell.align = "center";
			
			cell = row.insertCell(-1);
			cell.innerHTML = avg;
			cell.setAttribute("class", "cellData");
			cell.align = "center";
		}
	}
	
	function showDesc(id) {
		var div = document.getElementById(id);
		if(div.style.display == "") {
			div.style.display = "none";
		} else {
			div.style.display = "";
		}
	}
	
	function showRaces() {
		var div = document.getElementById("divRacesList");
		div.innerHTML = "";
		
		if(div.style.display == "") {
			div.style.display = "none";
		} else {
			div.style.display = "";
			div.style.innerHTML = "";
			
			var instance = new details_proxy();
			instance.setCallbackHandler(showRaces_callback);
			instance.get_series_details_races(g_clubId, g_seriesId);
		}
	}
	
	function showRaces_callback(result) {
		var div = document.getElementById("divRacesList");
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E09" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		} else {
			
			var tbl = document.createElement("table");
			tbl.width = "100%";
			div.appendChild(tbl);
			
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");

				var race_id = parseInt(fields[0]);
				var race_name = decodeString(fields[1]);
				var length_type = fields[2];
				var length_value = fields[3];
				var dist_units = fields[4];
				var track = fields[5];
				var race_calc = true;
				
				if(fields[6] == "0") {
					race_calc = false;
				} else {
					race_calc = true;
				}
				
				var strRaceLen = "";
				
				if(length_type == "Time") {
					strRaceLen = formatTimeToString(length_value);
				} else if(length_type == "Distance") {
					length_value = formatDistanceToString(length_value);
					strRaceLen = length_value + " " + dist_units;
				}

				
				var row = tbl.insertRow(-1);
				var cell = row.insertCell(-1);
				
				if(race_calc) {
					cell.innerHTML = "&nbsp;";
					cell.width = "16";
				} else {
					cell.innerHTML = "<img src='imgs/warning_small.png' onclick='showNoCalcMsg();' style='cursor:pointer;' width='16' />";
				}
				
				cell = row.insertCell(-1);
				
				<cfif Find("racingclubmanager", CGI.SERVER_NAME) GT 0>
				cell.innerHTML += "<a href='http://racingclubmanager.com/race_details.cfm?club=" + g_clubId + "&race=" + race_id + "&dlg=" + g_dlg + "&series=" + g_seriesId + g_strNavQS + "'>" + race_name + "</a> - " + strRaceLen + " " + track;
				<cfelse>
				cell.innerHTML += "<a href='http://clbmgr.com/rdt3/race_details.cfm?club=" + g_clubId + "&race=" + race_id + "&dlg=" + g_dlg + "&series=" + g_seriesId + g_strNavQS + "'>" + race_name + "</a> - " + strRaceLen + " " + track;
				</cfif>
			}
		}
	}
	
	function showNoCalcMsg() {
		doWhiteMsg("This race has been excluded when calculating final results for this series." + dlgCloseBtn);
	}
	
	function goFull() {
		parent.window.location.href = g_thisURL;
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
				h2 = "hour";
			} else if(h > 1) {
				h1 = h;
				h2 = "hours";
			}
			
			if(m == 0) {
				m1 = "";
				m2 = "";
			} else if(m == 1) {
				m1 = "1";
				m2 = "minute";
			} else if(m > 1) {
				m1 = m;
				m2 = "minutes";
			}
			
			retVal = h1 + " " + h2 + " " + m1 + " " + m2;
		} else {
			retVal = timeArr[0] + " minutes";
		}
		
		return retVal;
	}
	
	function padEnd(strVal, strPad) {
		return (strVal + strPad).slice(0,strPad.length);
	}
	
	function padFront(strVal, strPad) {
		return (strPad + strVal).slice(strPad.length*-1);
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
	
	function toggleResults(strToggleButton) {
		toggleResultsHide();
		
		g_strResultsType2 = strToggleButton;
		
		// show level 2 toggle buttons
		if(g_seriesType == "Teams") {
			document.getElementById("teamsResultsOptions").style.display = "";
		}

		// highlight the second level button
		document.getElementById("resultsToggle_" + g_strResultsType2).style.backgroundColor = "#FF9800";
		
		// show the correct results table
		document.getElementById("seriesResultsCell_" + g_strResultsType2).style.display = "";
	}
	
	function toggleResultsHide() {
		// un-highlight all the toggle buttons
		document.getElementById("resultsToggle_indiv").style.backgroundColor = "#263248";
		document.getElementById("resultsToggle_teams").style.backgroundColor = "#263248";
		document.getElementById("resultsToggle_privateer").style.backgroundColor = "#263248";
		
		// hide the level 2 toggle buttons
		document.getElementById("teamsResultsOptions").style.display = "none";
		
		document.getElementById("seriesResultsCell_indiv").style.display = "none";
		document.getElementById("seriesResultsCell_teams").style.display = "none";
		document.getElementById("seriesResultsCell_privateer").style.display = "none";
		
	}
	

</script>

</head>
<body onload="init();">
<div id="fb-root"></div>
<script>(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/en_US/sdk.js#xfbml=1&appId=1528583814052054&version=v2.0";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));</script>

<cfif g_showNav EQ "True">
	<cfif g_dlg EQ "1">
		<!--- no menu --->
		<div id="divFull" style="position:absolute;top:0px;left:0px;z-index:3000;">
			<img src="imgs/fullscreen.gif" width="25" style="cursor:pointer;" onclick="goFull();" />
		</div>
	<cfelse>
		<cfinclude template="include/navigation.cfm">
	</cfif>
</cfif>
<cfinclude template="include/dialogs.cfm">

<div id="divContainer" style="width:100%;" align="center">
	
	<cfif g_showNav EQ "True">
		<div id="divTxtContainer" style="width:900px;">
			<span id="divClubName"></span>
			<br />
			<span id="divName"></span>
			<br />
			<span id="divDateTime"></span>
			<br />
			<span id="divLapsTrack"></span>
		</div>
		
		
		<cfoutput>
		<div class="fb-share-button" data-href="#thisURL#" data-layout="button"></div>
		<a href="https://twitter.com/share" class="twitter-share-button" data-url="#thisURL#" data-text="#share_txt#" data-via="RacingClubMgr">Tweet</a>
		<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>
		</cfoutput>
		
		
		<div style="font-size:35px;">&nbsp;</div>
	</cfif>
	
	
	<!-- Results -->
	<div id="resultsContainer" align="left" onclick="showResults();">
		&#9662; Leaderboard
	</div>
	<div id="divResults" style="width:900px;text-align:left;display:none;">
		<table width="100%" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<div style="font-size:5px;">&nbsp;</div>
					<!-- toggle buttons -->
					<table cellspacing="0" cellpadding="0">
						<tr>
							<td>
								<table>
									<tr id="teamsResultsOptions" style="display:none;">
										<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
										<td class="resultsToggle2" onclick="toggleResults('indiv');" id="resultsToggle_indiv">
											<span style="color: white;">Individuals</span>
										</td>
										<td class="resultsToggle2" onclick="toggleResults('privateer');" id="resultsToggle_privateer">
											<span style="color: white;">Privateers</span>
										</td>
										<td class="resultsToggle2" onclick="toggleResults('teams');" id="resultsToggle_teams">
											<span style="color: white;">Teams</span>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
					<div style="font-size:5px;">&nbsp;</div>
				</td>
			</tr>
			
			<tr>
				<td id="seriesResultsCell_indiv" valign="top"></td>
			</tr>
			
			<tr>
				<td id="seriesResultsCell_teams" valign="top"></td>
			</tr>
			
			<tr>
				<td id="seriesResultsCell_privateer" valign="top"></td>
			</tr>
		</table>
	</div>
	
	
	
	
	<div style="font-size:10px;">&nbsp;</div>
	
	<!-- Races -->
	<div id="racesContainer" align="left" onclick="showRaces();">
		&#9662; Races
	</div>
	<div id="divRacesList" style="width:900px;text-align:left;display:none;"></div>
	
	<div style="font-size:10px;">&nbsp;</div>
	
	<!-- Series -->
	<div id="seriesDescContainer" align="left" onclick="showDesc('divSeriesDesc');">
		&#9662; Series Rules, Regulations, Specifications
	</div>
	<div id="divSeriesDesc" style="width:900px;text-align:left;"></div>
	
	<div style="font-size:10px;">&nbsp;</div>
	
	
	
	

	
	
	
</div>



</body>
</html>
