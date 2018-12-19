
<cfajaxproxy cfc="race_details_server" jsclassname="details_proxy" />
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

<cfif IsDefined("URL.race")>
	<cfset g_raceId = "#URL.race#">
<cfelse>
	<cfset g_raceId = "-1">
</cfif>

<cfif IsDefined("URL.dlg")>
	<cfset g_dlg = "#URL.dlg#">
<cfelse>
	<cfset g_dlg = "0">
</cfif>

<cfif IsDefined("URL.series")>
	<cfset g_seriesId = Int(URL.series)>
<cfelse>
	<cfset g_seriesId = 0>
</cfif>

<cfif IsDefined("URL.from")>
	<cfset g_from = URL.from>
<cfelse>
	<cfset g_from = "">
</cfif>

<cfif Find("racingclubmanager", CGI.SERVER_NAME) GT 0>
	<cfset rcm = "YES">
<cfelseif  Find("clbmgr", CGI.SERVER_NAME) GT 0>
	<cfset rcm = "NO">
<cfelse>
	FAIL
	<cfabort>
</cfif>

<cfif rcm EQ "YES">
	<cfset thisURL = "http://racingclubmanager.com/race_details.cfm?club=" & g_clubId & "&race=" & g_raceId>
<cfelse>
	<cfset thisURL = "http://clbmgr.com/rdt3/race_details.cfm?club=" & g_clubId & "&race=" & g_raceId>
</cfif>

<cfset share_txt = "">
<cfquery name="raceNameQRY" datasource="ds_rdt3">
	<cfoutput>
	EXEC [dbo].[get_race_share] #g_clubId#, #g_raceId#
	</cfoutput>
</cfquery>

<cfoutput query="raceNameQRY">
	<cfset share_txt = "#share_txt#">
</cfoutput>
<cfset share_txt = REPLACE(share_txt, "~chr35~", Chr(35), "all")>
<cfset share_txt = Replace(share_txt, "~chr34~", "", "All")>
<cfset share_txt = Replace(share_txt, "~chr39~", Chr(39),  "All")>
<cfset share_txt = Replace(share_txt, "~chr60~", Chr(60), "All")>
<cfset share_txt = Replace(share_txt, "~chr62~", Chr(62), "All")>
<cfset share_txt = Replace(share_txt, "~chr124~", Chr(124), "All")>

<cfset shortURL = thisURL>

<html>
<head>
<head prefix="og: http://ogp.me/ns# fb: http://ogp.me/ns/fb# rcm-club: http://ogp.me/ns/fb/rcm-club#">
<meta property="fb:app_id" content="1528583814052054" />
<meta property="og:type"   content="rcm-club:race" />
<cfoutput>
<meta property="og:url"    content="#thisURL#" />
<meta property="og:title"  content="#share_txt#" />
</cfoutput>
<cfif rcm EQ "YES">
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
	
	a {
		color: #FF9800;
	}
	
	#seriesDescContainer {
		width:900px;
		background-color:#FF9800;
		cursor:pointer;
		color: #000;
		font-size: 14pt;
	}
	
	#raceDescContainer {
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
	
	.noCalcMsg {
		color: red;
	}

</style>
<cfinclude template="include/analytics.cfm" />
<cfoutput>
<script type="text/javascript">
	var g_clubId = parseInt("#g_clubId#");
	var g_raceId = parseInt("#g_raceId#");
	var g_thisURL = "#thisURL#";
	var g_strNavQS = "#g_strNavQS#";
</script>
</cfoutput>
<script language='javascript' src='common.js'></script>
<script type="text/javascript" src="include/jquery-1.11.1.min.js"></script>


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

		<div id="divFull" style="position:absolute;top:0px;left:0px;z-index:3000;">
			<img src="imgs/fullscreen.gif" width="25" style="cursor:pointer;" onclick="goFull();" />
		</div>
	<cfelse>
		<cfinclude template="include/navigation.cfm">
	</cfif>
</cfif>
<cfinclude template="include/dialogs.cfm">

<div id="divContainer" style="width:100%;" align="center">
	
	<div id="divTxtContainer" style="width:900px;">
		<cfif g_showNav EQ "False">
			<div style="visibility:hidden; height:5px;">
		</cfif>
			<span id="divClubName"></span>
			<br />
			<span id="divName"></span>
			<br />
		<cfif g_showNav EQ "False">
			</div>
		</cfif>
		<span id="divDateTime"></span>
		<br />
		<span id="divLapsTrack"></span>
	</div>
	
	<cfoutput>
	
		<cfif g_showNav EQ "True">
			<div class="fb-share-button" data-href="#shortURL#" data-layout="button"></div>
			<a href="https://twitter.com/share" class="twitter-share-button" data-url="#shortURL#" data-text="#share_txt#" data-via="RacingClubMgr">Tweet</a>
			<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>
		</cfif>
		
		<table>
			<tr>
				<td>
					<a href="javascript:goRaceFlags();">Live Race Flags</a>
				</td>
				<td>
					<cfif g_seriesId GT 0>
						<div>
							<cfif rcm EQ "YES">
								&nbsp;&nbsp;&nbsp;<a href="http://racingclubmanager.com/series_details.cfm?club=#g_clubId#&series=#g_seriesId#&dlg=#g_dlg##g_strNavQS#">Back</a>
							<cfelse>
								&nbsp;&nbsp;&nbsp;<a href="http://clbmgr.com/rdt3/series_details.cfm?club=#g_clubId#&series=#g_seriesId#&dlg=#g_dlg##g_strNavQS#">Back</a>
							</cfif>
						</div>
					<cfelseif g_from EQ "racer">
						&nbsp;&nbsp;&nbsp;<a href="javascript:goBackNWB();">Back</a>
					</cfif>
				</td>
			</tr>
		</table>
	</cfoutput>
	
	<div style="font-size:35px;">&nbsp;</div>
	
	<!-- Results -->
	<div id="resultsContainer" align="left" onclick="showResults();">
		&#9662; Results
	</div>
	<div id="divResults" style="width:900px;text-align:left;display:none;">
		<table width="100%" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<div style="font-size:5px;">&nbsp;</div>
					<div id="divNoCalcMsg" class="noCalcMsg" style="display:none;">
						&nbsp; <img src="imgs/warning_small.png" width="16" height="16" title="Attention!" />&nbsp;
						This race has been excluded when calculating final results for this series.
					</div>
					<!-- toggle buttons -->
					<table cellspacing="0" cellpadding="0">
						<tr>
							<td>
								<table>
									<tr>
										<td class="resultsToggle" onclick="toggleResultsType('race');" id="resultsToggle_race">
											<span style="color: white;">Race Results</span>
										</td>
										<td class="resultsToggle" onclick="toggleResultsType('series');" id="resultsToggle_series">
											<span style="color: white;">Series Standings</span>
										</td>
									</tr>
								</table>
							</td>
						</tr>
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
				<td id="raceResultsCell_indiv" valign="top"></td>
			</tr>
			
			<tr>
				<td id="raceResultsCell_teams" valign="top"></td>
			</tr>
			
			<tr>
				<td id="raceResultsCell_privateer" valign="top"></td>
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
	
	<!-- Series -->
	<div id="seriesDescContainer" align="left" onclick="showDesc('divSeriesDesc');">
		&#9662; Series Rules, Regulations, Specifications
	</div>
	<div id="divSeriesDesc" style="width:900px;text-align:left;"></div>
	
	<div style="font-size:10px;">&nbsp;</div>
	
	<!-- Race -->
	<div id="raceDescContainer" align="left" onclick="showDesc('divRaceDesc');">
		&#9662; Post-Race Write-Up, Image Gallery
	</div>
	<div id="divRaceDesc" style="width:900px;text-align:left;"></div>	
</div>
</body>











<script type="text/javascript">
	
	$(window).resize(function () { doResize() });
	
	var g_seriesType = "";
	var g_arrTeamsRacers = [];
	var g_seriesQualifying = "OFF";
	var g_lengthType = "";
	var g_distUnits = "";
	var g_strResultsType = "race";
	var g_strResultsType2 = "indiv";
	var g_raceCalc = false;
	
	function init() {
		var errMsg = "Loading...";
		showLoadingDiv(true, errMsg);
		<cfif g_dlg EQ "1">
			document.getElementById("divLoading").style.top = "100px";
			document.getElementById("overlay").style.backgroundColor = "white";
		</cfif>
			
		if(g_raceId > 0) {
			doResize();
			getRaceDetails();
		}
	}
	
	function doResize() {
		resizeContainers();
	}
	
	function resizeContainers() {
		var seriesDescContainer = document.getElementById("seriesDescContainer");
		var divSeriesDesc = document.getElementById("divSeriesDesc");
		
		var raceDescContainer = document.getElementById("raceDescContainer");
		var divRaceDesc = document.getElementById("divRaceDesc");
		
		var resultsContainer = document.getElementById("resultsContainer");
		var divResults = document.getElementById("divResults");
		
		var body = parseInt(document.body.offsetWidth);
		if(body < 900) {
			seriesDescContainer.style.width = "100%";
			divSeriesDesc.style.width = "100%";
			raceDescContainer.style.width = "100%";
			divRaceDesc.style.width = "100%";
			resultsContainer.style.width = "100%";
			divResults.style.width = "100%";
		} else {
			seriesDescContainer.style.width = "900px";
			divSeriesDesc.style.width = "900px";
			raceDescContainer.style.width = "900px";
			divRaceDesc.style.width = "900px";
			resultsContainer.style.width = "900px";
			divResults.style.width = "900px";
		}
	}
	
	function getRaceDetails() {
		var instance = new details_proxy();
		instance.setCallbackHandler(getRaceDetails_callback);
		instance.get_race_details(g_clubId, g_raceId);
	}
	
	function getRaceDetails_callback(result) {
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E01" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			<cfif g_dlg EQ "1">
				document.getElementById("divLoading").style.top = "100px";
				document.getElementById("overlay").style.backgroundColor = "white";
			</cfif>
		} else {
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				
				var series_name = decodeString(fields[0]);
				var race_name = decodeString(fields[1]);
				var race_date = UTC2Local(fields[2]);
				var length_type = decodeString(fields[3]);
				g_lengthType = length_type;
				var length_value = fields[4];
				var lengthString = "";
				g_distUnits = decodeString(fields[5]);
				
				if(g_lengthType == "Time") {
					lengthString = formatTimeToString(length_value);
				} else if(g_lengthType == "Distance") {
					length_value = formatDistanceToString(length_value);
					lengthString = length_value + " " + g_distUnits + " ";
				}

				var track = fields[6];
				var seriesDesc = decodeString(fields[7]);
				var raceDesc = decodeString(fields[8]);
				var club_name = decodeString(fields[9]);
				g_seriesType = fields[10];
				g_seriesQualifying = fields[11];
				g_raceCalc = fields[12];
				if(g_raceCalc == "0") { g_raceCalc = false; } else { g_raceCalc = true; }
				
				document.getElementById("divName").innerHTML = series_name + " - " + race_name;
				document.getElementById("divDateTime").innerHTML = race_date;
				document.getElementById("divLapsTrack").innerHTML = lengthString + " at " + track;
				document.getElementById("divSeriesDesc").innerHTML = seriesDesc;
				document.getElementById("divRaceDesc").innerHTML = raceDesc;
				document.getElementById("divClubName").innerHTML = club_name + " Presents";
			}		
			showLoadingDiv(false, "");
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
	
	function showResults() {
		var div = document.getElementById("divResults");
		if(div.style.display == "") {
			div.style.display = "none";
		} else {
			
			var errMsg = "Loading...";
			showLoadingDiv(true, errMsg);
			<cfif g_dlg EQ "1">
				document.getElementById("divLoading").style.top = "100px";
				document.getElementById("overlay").style.backgroundColor = "white";
			</cfif>
			
			
			div.style.display = "";
			document.getElementById("raceResultsCell_indiv").innerHTML = "";
			document.getElementById("raceResultsCell_teams").innerHTML = "";
			document.getElementById("raceResultsCell_privateer").innerHTML = "";
			document.getElementById("seriesResultsCell_indiv").innerHTML = "";
			document.getElementById("seriesResultsCell_teams").innerHTML = "";
			document.getElementById("seriesResultsCell_privateer").innerHTML = "";
			
			if(!g_raceCalc) { // if this race was turned off, show attention message
				document.getElementById("divNoCalcMsg").style.display = "";
			}
			
			var instance = new details_proxy();
			instance.setCallbackHandler(showResults_callback);
			instance.get_race_results(g_raceId, g_seriesType, g_clubId);
		}
	}
	
	function showResults_callback(result) {
		var resultSets = result.split("<resultSet>");
		var retArr = [];
		var ret = true;
		
		retArr.push(showRaceResults(resultSets[0]));
		retArr.push(showSeriesStandings(resultSets[1], resultSets[2]));
		// only do this if type = team
		if(g_seriesType == "Teams") {
			retArr.push(showTeamRaceResults(resultSets[3]));
			retArr.push(addTeamAbbrToResults(resultSets[4]));
			retArr.push(showTeamSeriesStandings(resultSets[5],resultSets[6]));
			g_strResultsType2 = "privateer"; // temporaryily set it to privateer, maybe we should just provide as a parameter
			retArr.push(showRaceResults(resultSets[7])); // privateer results
			retArr.push(showSeriesStandings(resultSets[8],resultSets[9])); // privateer standings
		}
		
		g_strResultsType2 = "indiv";
		toggleResults(g_strResultsType2);
		showLoadingDiv(false, "");

	}
	
	function showRaceResults(result) {
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E02" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			<cfif g_dlg EQ "1">
				document.getElementById("divLoading").style.top = "100px";
				document.getElementById("overlay").style.backgroundColor = "white";
			</cfif>
			return false;
		} else {
			if(g_seriesType == "Multi-Class") {
				buildMCResultsTbl(rows);
			} else {
				buildResultsTbl(rows);
			}
			return true;
		}
	}
	
	function showTeamRaceResults(result) {
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			/*
			var errMsg = "This page encountered an error: E03" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			<cfif g_dlg EQ "1">
				document.getElementById("divLoading").style.top = "100px";
				document.getElementById("overlay").style.backgroundColor = "white";
			</cfif>
			*/
			return false;
		} else {
			buildTeamResultsTbl(rows);
			return true;
		}
		
	}
	
	function buildMCResultsTbl(rows) {
		var div = document.getElementById("raceResultsCell_indiv");
		
		var tbl = document.createElement("table");
		tbl.width = "100%";
		div.appendChild(tbl);
		
		var row = tbl.insertRow(-1);
		var cell = row.insertCell(-1);
		cell.colSpan = "6";
		
		
		if(rows.length <= 0) {
			cell.align = "left";
			cell.innerHTML = "No Race Results Recorded";
		} else {
			
			// extract the class names
			var teams = [];
			var prevTeamName = "";
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				var team_name = decodeString(fields[3]);
				var team_abbr = decodeString(fields[4]);
				
				if(team_name != prevTeamName) {
					prevTeamName = team_name;
					teams.push([team_name, team_abbr]);
				}
			}
			
			// make definitive arrays for each class
			for(var i=0; i<teams.length; i++) {
				var definitiveArr = [];
				
				for(var k=0; k<rows.length; k++) {
					var fields = rows[k].split("|");
					
					if(fields[3] == teams[i][0]) {
						var racer_id = parseInt(fields[0]);
						var finishPos = parseInt(fields[1]);
						var name = decodeString(fields[2]);
						//var team_name = decodeString(fields[3]);
						var team_abbr = decodeString(fields[4]);
						var finishPoints = parseInt(fields[5]);
						var bonus = parseInt(fields[6]);
						var startPos = parseInt(fields[7]);
						var bestLap = fields[8];

						var overall = "";
						// if race is time, show fields[10]
						// if race is distance, show fields[9]
						if(g_lengthType == "Time") {
							overall = fields[10];
						} else if(g_lengthType == "Distance") {
							overall = fields[9];
						}
						
						var penalty = parseInt(fields[11]);
						var points = (finishPoints + bonus)-penalty;
						
						definitiveArr.push([finishPos, name, bonus, points, startPos, bestLap, overall, penalty]);
						g_arrTeamsRacers.push([name, team_abbr]);
					}
				}
				
				// sort the definitive array by total points descending
				definitiveArr.sort(function(a,b) {
					return b[3] - a[3];
				});
				
				buildTblForClass(tbl, teams[i], definitiveArr);
			}
		}
		
		toggleResultsType("race");
	}
	
	function buildTblForClass(tbl, teamArray, arr) {
		var pos = 0;
		var prevPoints = 0;
		var row;
		var cell;
		for(var i=0; i<arr.length; i++) {
			
			if(i == 0) {
				
				row = tbl.insertRow(-1);
				row.setAttribute("class","dataHeaderBG");
				
				var colspan = 8
				if(g_seriesQualifying == "ON") { // if qualifying is ON, we need to span 1 more column
					colspan = 9;
				}
				
				cell = row.insertCell(-1);
				cell.colSpan = colspan.toString();
				cell.setAttribute("class", "dataHeaderTxt");
				cell.innerHTML = teamArray[0] + " - " + teamArray[1];
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
				
				// start pos column
				if(g_seriesQualifying == "ON") {
					cell = row.insertCell(-1);
					cell.innerHTML = "Start";
					cell.setAttribute("class", "dataHeaderTxt");
					cell.align = "center";
				}
				
				cell = row.insertCell(-1);
				cell.innerHTML = "Finish";
				cell.setAttribute("class", "dataHeaderTxt");
				cell.align = "center";
				
				cell = row.insertCell(-1);
				cell.innerHTML = "Best Lap";
				cell.setAttribute("class", "dataHeaderTxt");
				cell.align = "center";
				
				var strOverall = "";
				// if race is time, show distance
				// if race is distance, show overall
				if(g_lengthType == "Time") {
					strOverall = "Distance (" + g_distUnits + ")";
				} else if(g_lengthType == "Distance") {
					strOverall = "Overall";
				}
				
				cell = row.insertCell(-1);
				cell.innerHTML = strOverall;
				cell.setAttribute("class", "dataHeaderTxt");
				cell.align = "center";
				
				cell = row.insertCell(-1);
				cell.innerHTML = "Bonus";
				cell.setAttribute("class", "dataHeaderTxt");
				cell.align = "center";
				
				cell = row.insertCell(-1);
				cell.innerHTML = "Penalty";
				cell.setAttribute("class", "dataHeaderTxt");
				cell.align = "center";
				
				cell = row.insertCell(-1);
				cell.innerHTML = "Total";
				cell.setAttribute("class", "dataHeaderTxt");
				cell.align = "center";
			}
			
			var finishPos = arr[i][0];
			if(finishPos.toString() == "0") {
				finishPos = "DNF";
			}
			var name = arr[i][1];
			var bonus = arr[i][2];
			var points = arr[i][3];
			var startPos = arr[i][4];
			if(startPos.toString() == "0") {
				startPos = "DNQ";
			}
			
			if(points != prevPoints || i == 0) {
				pos++;
			}
			prevPoints = points;
			
			var bestLap = arr[i][5];
			var overall = arr[i][6];
			var penalty = arr[i][7];
			
			var row = tbl.insertRow(-1);
			row.style.backgroundColor = getRowColor(i);
			
			var cell = row.insertCell(-1);
			cell.innerHTML = pos;
			cell.setAttribute("class", "cellData");
			cell.align = "center";
			
			cell = row.insertCell(-1);
			cell.innerHTML = name;
			cell.setAttribute("class", "cellData");
			
			// start pos column
			if(g_seriesQualifying == "ON") {
				cell = row.insertCell(-1);
				cell.innerHTML = startPos;
				cell.setAttribute("class", "cellData");
				cell.align = "center";
			}
			
			cell = row.insertCell(-1);
			cell.innerHTML = finishPos;
			cell.setAttribute("class", "cellData");
			cell.align = "center";
			
			cell = row.insertCell(-1);
			cell.innerHTML = bestLap;
			cell.setAttribute("class", "cellData");
			cell.align = "center";
			
			cell = row.insertCell(-1);
			cell.innerHTML = overall;
			cell.setAttribute("class", "cellData");
			cell.align = "center";
			
			cell = row.insertCell(-1);
			cell.innerHTML = bonus;
			cell.setAttribute("class", "cellData");
			cell.align = "center";
			
			cell = row.insertCell(-1);
			cell.innerHTML = penalty;
			cell.setAttribute("class", "cellData");
			cell.align = "center";
			
			cell = row.insertCell(-1);
			cell.innerHTML = points;
			cell.setAttribute("class", "cellData");
			cell.align = "center";
		}
	}
	
	function buildResultsTbl(rows) {
		var div = document.getElementById("raceResultsCell_" + g_strResultsType2);
		
		var tbl = document.createElement("table");
		tbl.width = "100%";
		div.appendChild(tbl);
		
		var row;
		var cell;
		
		if(rows.length <= 0) {
			row = tbl.insertRow(-1);
			cell = row.insertCell(-1);
			
			var colspan = 8
			if(g_seriesQualifying == "ON") { // if qualifying is ON, we need to span 1 more column
				colspan = 9;
			}
				
			cell.colSpan = colspan.toString();
			cell.align = "left";
			if(g_strResultsType2 == "privateer") {
				cell.innerHTML = "No Privateer Results Recorded";
			} else {
				cell.innerHTML = "No Race Results Recorded";
			}
		} else {

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
			
			// start pos column
			if(g_seriesQualifying == "ON") {
				cell = row.insertCell(-1);
				cell.innerHTML = "Start Pos";
				cell.setAttribute("class", "dataHeaderTxt");
				cell.align = "center";
			}
			
			cell = row.insertCell(-1);
			cell.innerHTML = "Finish";
			cell.setAttribute("class", "dataHeaderTxt");
			cell.align = "center";
			
			cell = row.insertCell(-1);
			cell.innerHTML = "Best";
			cell.setAttribute("class", "dataHeaderTxt");
			cell.align = "center";
			
			var strOverall = "";
			// if race is time, show distance
			// if race is distance, show overall
			if(g_lengthType == "Time") {
				strOverall = "Distance (" + g_distUnits + ")";
			} else if(g_lengthType == "Distance") {
				strOverall = "Overall";
			}
			
			cell = row.insertCell(-1);
			cell.innerHTML = strOverall;
			cell.setAttribute("class", "dataHeaderTxt");
			cell.align = "center";
			
			cell = row.insertCell(-1);
			cell.innerHTML = "Bonus";
			cell.setAttribute("class", "dataHeaderTxt");
			cell.align = "center";
			
			cell = row.insertCell(-1);
			cell.innerHTML = "Penalty";
			cell.setAttribute("class", "dataHeaderTxt");
			cell.align = "center";
			
			cell = row.insertCell(-1);
			cell.innerHTML = "Total";
			cell.setAttribute("class", "dataHeaderTxt");
			cell.align = "center";
			
			// make a definitive array to output
			var definitiveArr = [];
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				
				var finishPos = parseInt(fields[0]);
				var name = decodeString(fields[1]);
				var finishPoints = parseInt(fields[3]);
				var bonus = parseInt(fields[4]);
				var startPos = parseInt(fields[5]);
				var bestLap = fields[6];
				
				var overall = "";
				// if race is time, show fields[8]
				// if race is distance, show fields[7]
				if(g_lengthType == "Time") {
					overall = fields[8];
				} else if(g_lengthType == "Distance") {
					overall = fields[7];
				}
				var penalty = parseInt(fields[9]);
				var points = (finishPoints + bonus)-penalty;
				definitiveArr.push([finishPos, name, bonus, points, startPos, bestLap, overall, penalty]);
			}
			
			// sort the definitive array by total points descending
			definitiveArr.sort(function(a,b) {
				return b[3] - a[3];
			});
			
			
			var pos = 0;
			var prevPoints = 0;
			for(var i=0; i<definitiveArr.length; i++) {
				
				var finishPos = definitiveArr[i][0];
				if(finishPos.toString() == "0") {
					finishPos = "DNF";
				}
				var name = definitiveArr[i][1];
				var bonus = definitiveArr[i][2];
				var points = definitiveArr[i][3];
				var qualPos = definitiveArr[i][4];
				if(qualPos.toString() == "0") {
					qualPos = "DNQ";
				}
				var bestLap = definitiveArr[i][5];
				var overall = definitiveArr[i][6];
				var penalty = definitiveArr[i][7];
				
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
				cell.innerHTML = name;
				cell.setAttribute("class", "cellData");
				
				// start pos column
				if(g_seriesQualifying == "ON") {
					cell = row.insertCell(-1);
					cell.innerHTML = qualPos;
					cell.setAttribute("class", "cellData");
					cell.align = "center";
				}
				
				cell = row.insertCell(-1);
				cell.innerHTML = finishPos;
				cell.setAttribute("class", "cellData");
				cell.align = "center";
				
				cell = row.insertCell(-1);
				cell.innerHTML = bestLap;
				cell.setAttribute("class", "cellData");
				cell.align = "center";
				
				cell = row.insertCell(-1);
				cell.innerHTML = overall;
				cell.setAttribute("class", "cellData");
				cell.align = "center";
				
				cell = row.insertCell(-1);
				cell.innerHTML = bonus;
				cell.setAttribute("class", "cellData");
				cell.align = "center";
				
				cell = row.insertCell(-1);
				cell.innerHTML = penalty;
				cell.setAttribute("class", "cellData");
				cell.align = "center";
				
				cell = row.insertCell(-1);
				cell.innerHTML = points;
				cell.setAttribute("class", "cellData");
				cell.align = "center";
			}
		}
	}
	
	function showSeriesStandings(results1, results2) {
		var rows1 = getRows(results1);
		if(rows1[0] == "error") {
			var errMsg = "This page encountered an error: E04" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			<cfif g_dlg EQ "1">
				document.getElementById("divLoading").style.top = "100px";
				document.getElementById("overlay").style.backgroundColor = "white";
			</cfif>
			return false;
		}
		
		var rows2 = getRows(results2);
		if(rows2[0] == "error") {
			var errMsg = "This page encountered an error: E05" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			<cfif g_dlg EQ "1">
				document.getElementById("divLoading").style.top = "100px";
				document.getElementById("overlay").style.backgroundColor = "white";
			</cfif>
			return false;
		}
		
		buildStandingsTbl(rows1, rows2);
		return true;
	}
	
	function buildStandingsTbl(rows1, rows2) {
		
		// rows1 = standings including this race
		// rows2 = standings before this race
		var definitiveArray = [];
		var arrNewStandings = [];
		var arrOldStandings = [];
		var pos = 0;
		var prevPoints = 0;
		
		// deal with the new standings first
		if(rows1.length > 0) {
			for(var i=0; i<rows1.length; i++) {
				var fields = rows1[i].split("|");
				
				var racer_id = parseInt(fields[0]);
				var name = decodeString(fields[1]);
				var points = parseInt(fields[2]);
				
				if(points != prevPoints || i == 0) {
					pos++;
				}
				prevPoints = points;
				
				var tempArr = [racer_id, pos, name, points];
				arrNewStandings.push(tempArr);
				
			}
		}
		
		pos = 0;
		prevPoints = 0;
		
		// deal with the old standings next
		if(rows2.length > 0) {
			for(var i=0; i<rows2.length; i++) {
				var fields = rows2[i].split("|");
				
				var racer_id = parseInt(fields[0]);
				var name = decodeString(fields[1]);
				var points = parseInt(fields[2]);
				
				if(points != prevPoints || i == 0) {
					pos++;
				}
				prevPoints = points;
				
				var tempArr = [racer_id, pos, name, points];
				arrOldStandings.push(tempArr);
				
			}
		}
		
		//compare old pos vs new pos for each racer_id
		for(var i=0; i<arrNewStandings.length; i++) {
			var thisRacerId = arrNewStandings[i][0];
			var diff = arrNewStandings[i][1];
			
			// figure out the position difference if any
			var idx = getIdx(arrOldStandings, 0, thisRacerId);
			if(idx > -1) {
				var newPos = arrNewStandings[i][1];
				var oldPos = arrOldStandings[idx][1];
				diff = parseInt(oldPos) - parseInt(newPos);
			}
			
			// make a definitive array that we can output
			var thisRacerPos = arrNewStandings[i][1];
			var thisRacerName = arrNewStandings[i][2];
			var thisRacerPoints = arrNewStandings[i][3];
			definitiveArray.push([thisRacerId,thisRacerPos,diff,thisRacerName,thisRacerPoints]);
		}
		
		var div = document.getElementById("seriesResultsCell_" + g_strResultsType2);
		
		var tbl = document.createElement("table");
		if(g_strResultsType2 == "indiv") {
			tbl.width = "75%";
		} else {
			tbl.width = "55%";
		}
		div.appendChild(tbl);
		
		var row;
		var cell;
		
		if(definitiveArray.length <= 0) {
			row = tbl.insertRow(-1);
			cell = row.insertCell(-1);
			cell.colSpan = "4";
			cell.align = "left";
			if(g_strResultsType2 == "privateer") {
				cell.innerHTML = "No Privateer Standings";
			} else {
				cell.innerHTML = "No Series Standings Yet";
			}
		} else {

			row = tbl.insertRow(-1);
			row.setAttribute("class","dataHeaderBG");
			
			cell = row.insertCell(-1);
			cell.innerHTML = "Pos";
			cell.setAttribute("class", "dataHeaderTxt");
			cell.align = "center";
			cell.width = "15%";
			
			cell = row.insertCell(-1);
			cell.innerHTML = "Chg";
			cell.setAttribute("class", "dataHeaderTxt");
			cell.align = "center";
			cell.width = "13%";
			
			cell = row.insertCell(-1);
			cell.innerHTML = "Name";
			cell.setAttribute("class", "dataHeaderTxt");
			cell.align = "center";
			cell.width = "60%";
			
			cell = row.insertCell(-1);
			cell.innerHTML = "Pts";
			cell.setAttribute("class", "dataHeaderTxt");
			cell.align = "center";
			cell.width = "12%";

			for(var i=0; i<definitiveArray.length; i++) {
				var racer_id = definitiveArray[i][0];
				var pos = definitiveArray[i][1];
				var change = definitiveArray[i][2];
				if(change == 0) {
					change = "-";
				}
				
				var name = decodeString(definitiveArray[i][3]);
				var points = definitiveArray[i][4];
				
				var row = tbl.insertRow(-1);
				row.style.backgroundColor = getRowColor(i);
				
				cell = row.insertCell(-1);
				cell.innerHTML = pos;
				cell.setAttribute("class", "cellData");
				cell.align = "center";
				
				cell = row.insertCell(-1);
				cell.innerHTML = change;
				cell.setAttribute("class", "cellData");
				cell.align = "center";
				
				
				var team_abbr = "";
				if(g_arrTeamsRacers.length > 0) {
					for(var k=0; k<g_arrTeamsRacers.length; k++) {
						if(g_arrTeamsRacers[k][0] == name) {
							team_abbr = "<span class='teamAbbr'> - " + g_arrTeamsRacers[k][1] + "</span>";
						}
					}
				}
				
				cell = row.insertCell(-1);
				cell.innerHTML = name + team_abbr;
				cell.setAttribute("class", "cellData");
				
				cell = row.insertCell(-1);
				cell.innerHTML = points;
				cell.setAttribute("class", "cellData");
				cell.align = "center";
			}
		}
	}
	
	function getIdx(arr, idx, value) {
		for(var i=0; i<arr.length; i++) {
			if(arr[i][idx] == value) {
				return i;
			}
		}
		
		return -1;
	}
	
	function buildTeamResultsTbl(rows) {
		//document.getElementById("rowSeriesType").style.display = "";
		//document.getElementById("rowSeriesType2").style.display = "";
		var div = document.getElementById("raceResultsCell_teams");
		
		var tbl = document.createElement("table");
		tbl.width = "45%";
		div.appendChild(tbl);
		
		var row;
		var table;
		
		if(rows.length <= 0) {
			row = tbl.insertRow(-1);
			cell = row.insertCell(-1);
			cell.colSpan = "3";
			cell.align = "left";
			cell.innerHTML = "No Race Results Recorded";
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
				var abbr = decodeString(fields[1]);
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
				cell.innerHTML = name + "<span class='teamAbbr'> - " + abbr + "</span>";
				cell.setAttribute("class", "cellData");
				
				cell = row.insertCell(-1);
				cell.innerHTML = points;
				cell.setAttribute("class", "cellData");
				cell.align = "center";
			}
		}
	}
	
	function addTeamAbbrToResults(result) {
		var rows = getRows(result);
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E06" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			<cfif g_dlg EQ "1">
				document.getElementById("divLoading").style.top = "100px";
				document.getElementById("overlay").style.backgroundColor = "white";
			</cfif>
			return false;
		} else {
			// get a definitive array of the result set
			var definitiveArr = [];
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				
				var racer_id = fields[0];
				var racer_name = fields[1];
				var team_name = fields[2];
				
				definitiveArr.push([racer_id, racer_name, team_name]);
			}
			
			// first add team abbr to race results
			var cell = document.getElementById("raceResultsCell_indiv");
			var tbl = cell.childNodes[0];
			
			for(var i=0; i<tbl.rows.length; i++) { // loop through rows in results table
				/*
				if(tbl.rows[i].cells[1]) {
					var thisCell = tbl.rows[i].cells[1];
					var tblRacer = thisCell.innerHTML;
					
					for(var k=0; k<definitiveArr.length; k++) {
						if(definitiveArr[k][1] == tblRacer) {
							thisCell.innerHTML = tblRacer + "<span class='teamAbbr'> - " + definitiveArr[k][2] + "</span>";
							break;
						}
					}
				}
				*/
				
				var newCell = tbl.rows[i].insertCell(2);
				
				if(i>0) {
					if(tbl.rows[i].cells[2]) {
						var thisCell = tbl.rows[i].cells[2];
						var tblRacer = tbl.rows[i].cells[1].innerHTML;
						
						for(var k=0; k<definitiveArr.length; k++) {
							if(definitiveArr[k][1] == tblRacer) {
								thisCell.innerHTML = definitiveArr[k][2];
								break;
							}
						}
					}
				} else {
					newCell.innerHTML = "Team";
					newCell.setAttribute("class", "dataHeaderTxt");
					newCell.align = "center";
				}
			}
			
			// second add team abbr to series standings
			cell = document.getElementById("seriesResultsCell_indiv");
			tbl = cell.childNodes[0];
			
			for(var i=0; i<tbl.rows.length; i++) {
				
				if(tbl.rows[i].cells.length > 1) { // if 1 or less it means that the race was excluded and there are no standings yet
				
					var newCell = tbl.rows[i].insertCell(3);
					
					if(i>0) {
						if(tbl.rows[i].cells[3]) {
							var thisCell = tbl.rows[i].cells[3];
							var tblRacer = tbl.rows[i].cells[2].innerHTML;
							
							for(var k=0; k<definitiveArr.length; k++) {
								if(definitiveArr[k][1] == tblRacer) {
									thisCell.innerHTML = definitiveArr[k][2];
									break;
								}
							}
						}
					} else {
						tbl.rows[i].cells[2].width = "40%";
						//
						newCell.innerHTML = "Team";
						newCell.setAttribute("class", "dataHeaderTxt");
						newCell.align = "center";
						newCell.width = "20%";
					}
				
				}
				
			}
			
			
			return true;
		}
	}
	
	function showTeamSeriesStandings(results1, results2) {
		var rows1 = getRows(results1);
		if(rows1[0] == "error") {
			var errMsg = "This page encountered an error: E07" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			<cfif g_dlg EQ "1">
				document.getElementById("divLoading").style.top = "100px";
				document.getElementById("overlay").style.backgroundColor = "white";
			</cfif>
			return false;
		}
		
		var rows2 = getRows(results2);
		if(rows2[0] == "error") {
			var errMsg = "This page encountered an error: E08" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			<cfif g_dlg EQ "1">
				document.getElementById("divLoading").style.top = "100px";
				document.getElementById("overlay").style.backgroundColor = "white";
			</cfif>
			return false;
		}
		
		buildTeamStandingsTbl(rows1, rows2);
		return true;
	}
	
	function buildTeamStandingsTbl(rows1, rows2) {
		
		// rows1 = standings including this race
		// rows2 = standings before this race
		var definitiveArray = [];
		var arrNewStandings = [];
		var arrOldStandings = [];
		var pos = 0;
		var prevPoints = 0;
		
		// deal with the new standings first
		if(rows1.length > 0) {
			for(var i=0; i<rows1.length; i++) {
				var fields = rows1[i].split("|");
				
				var name = fields[0];
				var abbr = fields[1];
				var points = parseInt(fields[2]);
				
				if(points != prevPoints || i == 0) {
					pos++;
				}
				prevPoints = points;
				
				var tempArr = [abbr, pos, name, points];
				arrNewStandings.push(tempArr);
				
			}
		}
		
		pos = 0;
		prevPoints = 0;
		
		// deal with the old standings next
		if(rows2.length > 0) {
			for(var i=0; i<rows2.length; i++) {
				var fields = rows2[i].split("|");
				
				var name = fields[0];
				var abbr = fields[1];
				var points = parseInt(fields[2]);
				
				if(points != prevPoints || i == 0) {
					pos++;
				}
				prevPoints = points;
				
				var tempArr = [abbr, pos, name, points];
				arrOldStandings.push(tempArr);
				
			}
		}
		
		//compare old pos vs new pos for each racer_id
		for(var i=0; i<arrNewStandings.length; i++) {
			var name = arrNewStandings[i][2];
			var diff = arrNewStandings[i][1];
			
			// figure out the position difference if any
			var idx = getIdx(arrOldStandings, 2, name);
			if(idx > -1) {
				var newPos = arrNewStandings[i][1];
				var oldPos = arrOldStandings[idx][1];
				diff = parseInt(oldPos) - parseInt(newPos);
			}
			
			// make a definitive array that we can output
			var thisAbbr = arrNewStandings[i][0];
			var thisPos = arrNewStandings[i][1];
			var thisName = arrNewStandings[i][2];
			var thisPoints = arrNewStandings[i][3];
			definitiveArray.push([thisPos,diff,thisName,thisAbbr,thisPoints]);
		}
		
		
		var div = document.getElementById("seriesResultsCell_teams");
		
		var tbl = document.createElement("table");
		tbl.width = "45%";
		div.appendChild(tbl);
		
		var row;
		var cell;
		
		if(definitiveArray.length > 0) {
			row = tbl.insertRow(-1);
			row.setAttribute("class","dataHeaderBG");
			
			cell = row.insertCell(-1);
			cell.innerHTML = "Pos";
			cell.setAttribute("class", "dataHeaderTxt");
			cell.align = "center";
			cell.width = "15%";
			
			cell = row.insertCell(-1);
			cell.innerHTML = "Chg";
			cell.setAttribute("class", "dataHeaderTxt");
			cell.align = "center";
			cell.width = "13%";
			
			cell = row.insertCell(-1);
			cell.innerHTML = "Name";
			cell.setAttribute("class", "dataHeaderTxt");
			cell.align = "center";
			cell.width = "60%";
			
			cell = row.insertCell(-1);
			cell.innerHTML = "Pts";
			cell.setAttribute("class", "dataHeaderTxt");
			cell.align = "center";
			cell.width = "12%";

			
			for(var i=0; i<definitiveArray.length; i++) {
				var pos = definitiveArray[i][0];
				var change = definitiveArray[i][1];
				if(change == 0) {
					change = "-";
				}
				
				var name = decodeString(definitiveArray[i][2]);
				var abbr = decodeString(definitiveArray[i][3]);
				var points = definitiveArray[i][4];
				
				var row = tbl.insertRow(-1);
				row.style.backgroundColor = getRowColor(i);
				
				cell = row.insertCell(-1);
				cell.innerHTML = pos;
				cell.setAttribute("class", "cellData");
				cell.align = "center";
				
				cell = row.insertCell(-1);
				cell.innerHTML = change;
				cell.setAttribute("class", "cellData");
				cell.align = "center";
				
				cell = row.insertCell(-1);
				cell.innerHTML = name + "<span class='teamAbbr'> - " + abbr + "</span>";
				cell.setAttribute("class", "cellData");
				
				cell = row.insertCell(-1);
				cell.innerHTML = points;
				cell.setAttribute("class", "cellData");
				cell.align = "center";
			}
		}
		//document.getElementById("rowSeriesType2").style.display = "none";
	}
	
	function showPrivateerRaceResults(results) {
		
	}
	
	function showDesc(id) {
		var div = document.getElementById(id);
		if(div.style.display == "") {
			div.style.display = "none";
		} else {
			div.style.display = "";
		}
	}

	function toggleResultsType(strType) {
		toggleResultsHide();
		
		g_strResultsType = strType;
		
		toggleResults(g_strResultsType2); // initially show indiv by default, then show last clicked
	}
	
	function toggleResults(strToggleButton) {
		toggleResultsHide();
		
		g_strResultsType2 = strToggleButton;
		
		// show level 2 toggle buttons
		if(g_seriesType == "Teams") {
			document.getElementById("teamsResultsOptions").style.display = "";
		}
		
		// highlight top level button
		document.getElementById("resultsToggle_" + g_strResultsType).style.backgroundColor = "#FF9800";
		
		// highlight the second level button
		document.getElementById("resultsToggle_" + g_strResultsType2).style.backgroundColor = "#FF9800";
		
		// show the correct results table
		document.getElementById(g_strResultsType + "ResultsCell_" + g_strResultsType2).style.display = "";
	}
	
	function toggleResultsHide() {
		
		// un-highlight all the toggle buttons
		document.getElementById("resultsToggle_race").style.backgroundColor = "#263248";
		document.getElementById("resultsToggle_series").style.backgroundColor = "#263248";
		document.getElementById("resultsToggle_indiv").style.backgroundColor = "#263248";
		document.getElementById("resultsToggle_teams").style.backgroundColor = "#263248";
		document.getElementById("resultsToggle_privateer").style.backgroundColor = "#263248";
		
		// hide the level 2 toggle buttons
		document.getElementById("teamsResultsOptions").style.display = "none";
		
		// hide all of the results tables
		document.getElementById("raceResultsCell_indiv").style.display = "none";
		document.getElementById("raceResultsCell_teams").style.display = "none";
		document.getElementById("raceResultsCell_privateer").style.display = "none";
		
		document.getElementById("seriesResultsCell_indiv").style.display = "none";
		document.getElementById("seriesResultsCell_teams").style.display = "none";
		document.getElementById("seriesResultsCell_privateer").style.display = "none";
		
	}
	
	function goBackNWB() {
		window.history.back();
	}
	
	function goFull() {
		parent.window.location.href = g_thisURL;
	}
	
	function goRaceFlags() {
		parent.window.location.href = "flags.cfm?race=" + g_raceId;
	}

</script>
</html>
