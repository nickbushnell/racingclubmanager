<cfajaxproxy cfc="racer_detail_server" jsclassname="club_proxy" />
<cfif IsDefined("URL.club")>
	<cfset g_clubId = "#URL.club#">
<cfelse>
	<cfif IsDefined("Cookie.defaultClub")>
		<cfset g_clubId = "#Cookie.defaultClub#">
	<cfelseif IsDefined("Session.club_id")>
		<cfset g_clubId = "#Session.club_id#">
	<cfelse>
		<cfset g_clubId = "1">
	</cfif>
</cfif>

<cfif IsDefined("URL.racer")>
	<cfset g_racerId = "#URL.racer#">
<cfelse>
	<cfset g_racerId = "-1">
</cfif>

<cfif IsDefined("URL.dlg")>
	<cfset g_dlg = "#URL.dlg#">
<cfelse>
	<cfset g_dlg = "0">
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
	<cfset thisURL = "http://racingclubmanager.com/racer_detail.cfm?club=" & g_clubId & "&racer=" & g_racerId>
<cfelse>
	<cfset thisURL = "http://clbmgr.com/rdt3/racer_detail.cfm?club=" & g_clubId & "&racer=" & g_racerId>
</cfif>

<cfset share_txt = "">
<cfquery name="shareQRY" datasource="ds_rdt3">
	<cfoutput>
	EXEC [dbo].[get_racer_share] #g_clubId#, #g_racerId#
	</cfoutput>
</cfquery>

<cfoutput query="shareQRY">
	<cfset share_txt = "#share_txt#">
</cfoutput>
<cfset share_txt = REPLACE(share_txt, "~chr35~", Chr(35), "all")>
<cfset share_txt = Replace(share_txt, "~chr34~", "", "All")>
<cfset share_txt = Replace(share_txt, "~chr39~", Chr(39),  "All")>
<cfset share_txt = Replace(share_txt, "~chr60~", Chr(60), "All")>
<cfset share_txt = Replace(share_txt, "~chr62~", Chr(62), "All")>
<cfset share_txt = Replace(share_txt, "~chr124~", Chr(124), "All")>

<html>
<head>
<head prefix="og: http://ogp.me/ns# fb: http://ogp.me/ns/fb# rcm-club: http://ogp.me/ns/fb/rcm-club#">
<meta property="fb:app_id" content="1528583814052054" />
<meta property="og:type"   content="rcm-club:racer" />
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
<title>Racing Club Manager | Racer Detail</title>
<style type="text/css">
/*
	body {
		background-color: #263248;
		font-family: 'Monda', sans-serif;
		color: #fff;
		margin:0px;
		font-size: 10pt;
	}
*/

	body {
		margin: 0px;
		font-family: 'Monda', sans-serif;
		font-size: 10pt;
		background-color: #fff;
		color: black
	}
	
	td {
		font-size: 10pt;
		/*font-family: 'Monda', sans-serif;*/
	}
	
	/*
	a {
		color: #FF9800;
	}
	*/
	
	#chartBar {
		width:900px;
		background-color:#FF9800;
		cursor:pointer;
		color: #000;
		font-size: 14pt;
	}
	
	#spanGraphDesc {
		color: #fff;
	}
	
	#racerName {
		font-size: 30pt;
	}
	
	.chartSpan {
		background-color: #263248;
		padding:3px;
	}
	
	.tdRacerDetailsBox {
		width: 250px;
		background-color: #263248;
		color: #fff;
	}
	
	.racerDetailTitle {
		font-size: 14pt;
		font-weight:bold;
		color: #fff;
	}

</style>
<cfinclude template="include/analytics.cfm" />
<script src="charts/chart.js"></script>
<cfoutput>
<script type="text/javascript">
	var g_clubId = parseInt("#g_clubId#");
	var g_racerId = parseInt("#g_racerId#");
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

<cfif g_dlg EQ "1">
	<div id="divFull" style="position:absolute;top:0px;left:0px;z-index:3000;">
		<img src="imgs/fullscreen.gif" width="25" style="cursor:pointer;" onclick="goFull();" />
	</div>
<cfelse>
	<cfinclude template="include/navigation.cfm">
</cfif>
<cfinclude template="include/dialogs.cfm">

<div id="divContainer" style="width:100%;" align="center">
	
	<div style="font-size:20px;">&nbsp;</div>
	
	<div id="divRacerDetails"></div>
	
	<cfoutput>
	<div class="fb-share-button" data-href="#thisURL#" data-layout="button"></div>
	<a href="https://twitter.com/share" class="twitter-share-button" data-url="#thisURL#" data-text="#share_txt#" data-via="RacingClubMgr">Tweet</a>
	<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>
	</cfoutput>
	
	<div style="font-size:20px;">&nbsp;</div>
	
	<div style="width:900px;" align="center">
		<table border="0" cellspacing="0" cellpadding="10" style="width:100%;">
			<tr>
				<td>&nbsp;</td>
				<td class="tdRacerDetailsBox" align="center" valign="center"><!-- series won -->
					<span class="racerDetailTitle">Series Won</span>
					<br />
					<span id="racerDetail_series">Loading...</span>
				</td>
				<td>&nbsp;</td>
				<td class="tdRacerDetailsBox" align="center" valign="center"><!-- races won -->
					<span class="racerDetailTitle">Races Won</span>
					<br />
					<span id="racerDetail_races">Loading...</span>
				</td>
				<td>&nbsp;</td>
				<td class="tdRacerDetailsBox" align="center" valign="center"><!-- attendance -->
					<span class="racerDetailTitle">Attendance</span>
					<br />
					<table style="width:100%;" cellspacing="0" cellpadding="0">
						<tr>
							<td style="color:#fff;width:50%;font-weight:bold;" align="center">
								Series
							</td>
							<td style="color:#fff;width:50%;font-weight:bold;" align="center">
								Races
							</td>
						</tr>
						<tr>
							<td id="series_attendance" style="color:#fff;" align="center">
								Loading...
							</td>
							<td id="races_attendance" style="color:#fff;" align="center">
								Loading...
							</td>
						</tr>
					</table>
				</td>
				<td>&nbsp;</td>
			</tr>
		</table>
	</div>
	
	<div style="font-size:20px;">&nbsp;</div>
	
	<!-- Graph -->
	<div id="chartBar" align="left" onclick="showGraphs();">
		&#9662; Graphs
	</div>
	
	<div id="chartContainer" style="width:900px;display:none;">
		<div align="left" style="padding:10px;">
			&nbsp;&nbsp;
			<span class="chartSpan" id="btnWinnnersCircle">
			<a href="javascript:getWinnersCircle();" style="color: #fff;text-decoration:none;">Winners Circle</a>
			</span>
			
			&nbsp;
			<span class="chartSpan" id="btnAvgFin">
			<a href="javascript:getAvgFinChart();" style="color: #fff;text-decoration:none;">Average Finish</a>
			</span>
			<br /><br />
		</div>
		
		<div id="graphMsg" style="display:none;"></div>
		
		<div id="divWinnersCircle" style="width:900px;display:none;">
			<table width="100%">
				<tr>
					<td valign="top" width="50%" align="left">
						<table width="95%" id="tblGraphData" align="center" cellpadding="3" cellspacing="2">
							<tr style="background-color: #263248;">
								<td>
									<span id="spanGraphDesc"></span>
								</td>
							</tr>
						</table>
					</td>
					<td valign="top" width="50%" align="center">
						<canvas id="canvas"></canvas>
					</td>
				</tr>
			</table>
		</div>

		<div id="divAvgFinChart" style="width:900px;display:none;">
			Y-Axis: Avg Finish Position<br />
			X-Axis: Month/Day of Race - Finish Position
			<br />
			<canvas id="avgFinCanvas"></canvas>
		</div>
	</div>
	
	
	
	<div style="font-size:10px;">&nbsp;</div>

	
	
	
</div>



<script type="text/javascript">

	var g_arrChartData = [];
	var myPie = null;
	var pieChartData = null;
	var g_defaultSlice = "Gold";
	
	var g_arrAvgFinData = [[5.81,0,""],[5.81,6,"5/19"]];
	//var g_arrAvgFinData = [[5.81,0,""],[5.81,6,"5/19"],[5.81,6,"5/20"],[5.83,7,"5/22"],[5.85,7,"5/29"],[5.9,9,"6/2"],[5.87,4,"6/3"],[5.93,10,"6/5"],[5.9,4,"6/9"],[5.89,5,"6/12"],[5.88,5,"6/16"],[5.9,8,"6/19"],[5.95,9,"6/23"],[5.95,6,"6/26"],[5.93,5,"6/30"],[5.95,7,"7/3"],[5.94,5,"7/6"],[5.92,5,"7/10"],[5.91,5,"7/13"]];
	var avgFinLine = null;
	var avgFinLineData = null;
	
	var g_totalNumRaces = 0;
	
	$(window).resize(function () { doResize() });
	
	function init() {
		doResize();
		/*
		showLoadingDiv(true, "Loading...");
		<cfif g_dlg EQ "1">
			document.getElementById("divLoading").style.top = "100px";
			document.getElementById("overlay").style.backgroundColor = "white";
		</cfif>
		*/
		getRacerNameClubStatus();
	}
	
	function doResize() {
		resizeOverlay();
	}
	
	function getRacerNameClubStatus() {
		var instance = new club_proxy();
		instance.setCallbackHandler(showRacerNameClubStatus);
		instance.getRacerNameClubStatus(g_clubId, g_racerId);
	}

	/*
	function getRacerDetails_callback(result) {
		// need to handle multiple record sets
		var resultSets = result.split("<resultSet>");
		var retArr = [];
		var ret = true;
		
		retArr.push(showRacerNameClubStatus(resultSets[0]));
		retArr.push(showSeriesWins(resultSets[1]));
		retArr.push(showRacesWins(resultSets[2]));
		showLoadingDiv(false, "");
	}
	*/
	
	function showRacerNameClubStatus(result) {
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
				
				var racer_name = decodeString(fields[0]);
				
				var active = fields[1];
				if(active == "1") {
					active = "active";
				} else {
					active = "deactivated";
				}
				
				var club_name = decodeString(fields[2]);
				
				var strHeader =  "<span id='racerName'>" + racer_name + "</span><br />";
					strHeader += active + " member of " + club_name;
				
				document.getElementById("divRacerDetails").innerHTML = strHeader;
			}
		}
		
		getRacesWins();
	}
	
	function getSeriesWins() {
		var instance = new club_proxy();
		instance.setCallbackHandler(showSeriesWins);
		instance.getSeriesWins(g_clubId, g_racerId);
	}
	
	function showSeriesWins(result) {
		var rows = getRows(result);
		var span = document.getElementById("racerDetail_series");
		var td = document.getElementById("series_attendance");
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E02" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			<cfif g_dlg EQ "1">
				document.getElementById("divLoading").style.top = "100px";
				document.getElementById("overlay").style.backgroundColor = "white";
			</cfif>
		} else {
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				
				var series_won = parseInt(fields[0]);
				var series_attended = parseInt(fields[1]);
				var series_win_perc = formatPerc(parseFloat(fields[2])*100);
				var series_att_perc = formatPerc(parseFloat(fields[3])*100);
				
				span.innerHTML = series_won + " (" + series_win_perc + "%)";
				td.innerHTML = series_attended + " (" + series_att_perc + "%)";
				
			}
		}
	}
	
	function getRacesWins() {
		var instance = new club_proxy();
		instance.setCallbackHandler(showRacesWins);
		instance.getRacesWins(g_clubId, g_racerId);
	}
	
	function showRacesWins(result) {
		var rows = getRows(result);
		var span = document.getElementById("racerDetail_races");
		var td = document.getElementById("races_attendance");
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E03" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			<cfif g_dlg EQ "1">
				document.getElementById("divLoading").style.top = "100px";
				document.getElementById("overlay").style.backgroundColor = "white";
			</cfif>
		} else if(rows[0] == "noData") {
			// set race data to 0
			span.innerHTML = "0 (0%)";
			td.innerHTML = "0 (0%)";
			
			// set series data to 0
			span = document.getElementById("racerDetail_series");
			td = document.getElementById("series_attendance");
			span.innerHTML = "0 (0%)";
			td.innerHTML = "0 (0%)";
		} else {
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				
				var won = parseInt(fields[0]);
				var attended = parseInt(fields[1]);
				var win_perc = formatPerc(parseFloat(fields[2])*100);
				var att_perc = formatPerc(parseFloat(fields[3])*100);
				
				span.innerHTML = won + " (" + win_perc + "%)";
				td.innerHTML = attended + " (" + att_perc + "%)";
				
			}
			// only call getSeriesWins if race data exists
			getSeriesWins();
		}
	}
	
	function formatPerc(dec) {
		var retVal = dec;
		
		dec = dec.toString();
		var arrParts = dec.split(".");
		if(arrParts.length > 1) {
			var afterDec = arrParts[1]
			if(afterDec.length > 2) {
				if(afterDec.substr(0,2) == "00") {
					retVal = arrParts[0];
				} else {
					retVal = arrParts[0].toString() + "." + afterDec.substr(0,2);
				}
			}
		}
		
		return retVal;
	}
	
	function showGraphs() {
		var divWinnersCircle = document.getElementById("divWinnersCircle");
		var divAvgFinish;
		
		// show/hide the graphContainer
		var cont = document.getElementById("chartContainer");
		if(cont.style.display == "") { // HIDE CHART CONTAINER
			// hide all graphs 
			hideAllGraphsInContainer();
			highlightGraph("");
			// hide container
			cont.style.display = "none";
		} else { // SHOW CHART CONTAINER
			cont.style.display = "";
		}
	}
	
	function highlightGraph(id) {
		document.getElementById("btnWinnnersCircle").style.backgroundColor = "#263248";
		document.getElementById("btnAvgFin").style.backgroundColor = "#263248";
		
		if(id.length > 0) {
			if(id == "btnAvgFin") {
				document.getElementById("graphMsg").style.display = "";
			} else {
				document.getElementById("graphMsg").style.display = "none";
			}
			
			document.getElementById(id).style.backgroundColor = "#FF9800";
		}
	}
	
	function hideAllGraphsInContainer() {
		showWinnersCircle(false);
		showAvgFinChart(false);
	}
	
	function getWinnersCircle() {
		g_arrChartData = [];
		g_totalNumRaces = 0;
		hideAllGraphsInContainer();
		highlightGraph("btnWinnnersCircle");
		
		var instance = new club_proxy();
		instance.setCallbackHandler(getWinnersCircle_callback);
		instance.getWinnersCircle(g_clubId, g_racerId);
	}
	
	function getWinnersCircle_callback(result) {
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E04" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			<cfif g_dlg EQ "1">
				document.getElementById("divLoading").style.top = "100px";
				document.getElementById("overlay").style.backgroundColor = "white";
			</cfif>
		} else {
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				
				// Gold
				var gold = parseInt(fields[0]);
				g_arrChartData.push([gold,'Gold']);
				
				// Silver
				var silver = parseInt(fields[1]);
				g_arrChartData.push([silver,'Silver']);
				
				// Bronze
				var bronze = parseInt(fields[2]);
				g_arrChartData.push([bronze,'Bronze']);
				
				// non podium
				var np = parseInt(fields[3]);
				g_arrChartData.push([np,'Non Podium']);
				
				// DNF
				var dnf = parseInt(fields[4]);
				g_arrChartData.push([dnf,'DNF']);
				
				
				if(gold > 0) {
					g_defaultSlice = "Gold";
				} else if(silver > 0) {
					g_defaultSlice = "Silver";
				} else if(bronze > 0) {
					g_defaultSlice = "Bronze";
				} else if(np > 0) {
					g_defaultSlice = "Non Podium";
				} else if(dnf > 0) {
					g_defaultSlice = "DNF";
				}

				// Total number of races
				g_totalNumRaces = parseInt(fields[5]);
				
			}
			
			if(rows[0] == "0|0|0|0|0|0") {
				var div = document.getElementById("graphMsg");
				div.style.display = "";
				div.innerHTML = "This racer has not completed any races.";
				
				g_defaultSlice = "";
			} else {
				showWinnersCircle(true);
			}
		}
	}
	
	function showWinnersCircle(bln) {
		var div = document.getElementById("divWinnersCircle");
		if(bln) {
			div.style.display = "";
			initWinnersCircle();
		} else {
			div.style.display = "none";
		}
	}
	
	function getAvgFinChart() {
		// do jax stuff later
		g_arrAvgFinData = [];
		hideAllGraphsInContainer();
		highlightGraph("btnAvgFin");
		
		var instance = new club_proxy();
		instance.setCallbackHandler(getAvgFinChart_callback);
		instance.getAvgFinChart(g_clubId, g_racerId);
	}
	
	function getAvgFinChart_callback(result) {
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E05" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			<cfif g_dlg EQ "1">
				document.getElementById("divLoading").style.top = "100px";
				document.getElementById("overlay").style.backgroundColor = "white";
			</cfif>
		} else if(rows[0] == "noData") {
			document.getElementById("graphMsg").innerHTML = "Not enough results in the past 60 days";
		} else {
			if(rows.length >= 2) {
				for(var i=0; i<rows.length; i++) {
					var fields = rows[i].split("|");
					
					var avg = fields[0];
					
					var place = parseInt(fields[1]);
					var strPlace = " - " + formatPlace(place);
					if(place == 0) {
						strPlace = "";
					}
					var race_date_raw = UTC2Local(fields[2]);
					var race_date = "";
					if(race_date_raw.length > 0) {
						race_date = race_date_raw.split("/")[0] + "/" + race_date_raw.split("/")[1];
					}
					
					g_arrAvgFinData.push([avg,place,race_date + strPlace]);
				}
				showAvgFinChart(true);
			} else {
				// not even 2 records
				document.getElementById("graphMsg").innerHTML = "Not enough results in the past 60 days";
			}
		}
	}
	
	function formatPlace(intPlace) {
		var strPlace = intPlace.toString();
		var lastNum = parseInt(strPlace.charAt(strPlace.length-1));
		var strAppend = "";
		
		if(intPlace == 0) {
			strAppend = "";
		} else if(intPlace > 3 && intPlace < 21) {
			strAppend = "th";
		} else {
			if(lastNum == 1) {
				strAppend = "st";
			} else if(lastNum == 2) {
				strAppend = "nd";
			} else if(lastNum == 3) {
				strAppend = "rd";
			} else {
				strAppend = "th";
			}
		}
		
		return intPlace.toString() + strAppend;
		
	}
	
	function showAvgFinChart(bln) {
		var div = document.getElementById("divAvgFinChart");
		if(bln) {
			div.style.display = "";
			initAvgFinChart();
		} else {
			div.style.display = "none";
		}
	}
	
	function initWinnersCircle() { // Pie Chart
		var labels = [];
		var data = [];
		
		for(var i=0; i<g_arrChartData.length; i++) { // add the data
			var thisArr = g_arrChartData[i];
			labels.push(thisArr[1])
			data.push(thisArr[0]);
		}
		
		var piedata = []
		var colorIdx = 0;
		for (i = 0; i <= data.length - 1; i++) {
			if(colorIdx == 5) { colorIdx = 0; }
			colorIdx++;
			piedata.push({
				value: data[i],
				label: labels[i],
				color: getRCMcolor(colorIdx)
			});
		}
		
		var ctx = document.getElementById("canvas").getContext("2d");
		ctx.canvas.width = 300;
		ctx.canvas.height = 300;
		var myPieChart = new Chart(ctx).Pie(piedata,{segmentStrokeColor : "#fff", segmentStrokeWidth: 2, animateRotate: true, animateScale: false});
		
		$("#canvas").click( 
			function(evt){
				var activePoints = myPieChart.getSegmentsAtEvent(evt);
				doSliceClick(activePoints[0].label);
			}
		);
		
		if(g_defaultSlice.length > 0) {
			doSliceClick(g_defaultSlice);
		}
	}
	
	function getRCMcolor(i) {
		if(i==1) { // gold
			return "#FFD700";
		} else if(i==2) { // silver
			return "#CCC";
		} else if(i==3) { // bronze
			return "#CD7F32";
		} else if(i==4) { // non podium
			//return "#7E8AA2";
			return "#263248";
		} else if(i==5) { // DNF
			return "#333";
		}
	}
	
	function doSliceClick(label) {
		//alert(label + ", " + value);
		document.getElementById("spanGraphDesc").innerHTML = label + " Finishes";
		getWinnersCircle_slice(label);
	}
	
	function getWinnersCircle_slice(slice) {
		var instance = new club_proxy();
		instance.setCallbackHandler(getWinnersCircle_slice_callback);
		instance.getWinnersCircle_slice(g_clubId, g_racerId, slice);
	}
	
	function getWinnersCircle_slice_callback(result) {
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E06" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			<cfif g_dlg EQ "1">
				document.getElementById("divLoading").style.top = "100px";
				document.getElementById("overlay").style.backgroundColor = "white";
			</cfif>
		} else {
			var tbl = document.getElementById("tblGraphData");
			
			// remove rows from table before filling
			for(var i = tbl.rows.length - 1; i > 0; i--) {
				tbl.deleteRow(i);
			}

			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				
				var race_name = decodeString(fields[0]);
				var race_id = parseInt(fields[1]);
				
				var row = tbl.insertRow(-1);
				//var row_color = getRowColor(i);
				row.style.backgroundColor  = getRowColor(i);
				/*if(row_color != "#fff") {
					row.style.backgroundColor = row_color;
				}*/
				
				var cell = row.insertCell(-1);
				<cfif g_dlg EQ "0">
					cell.innerHTML = "<a href='javascript:openInDlgWindow(\"Race Details\", \"race_details.cfm?club=" + g_clubId + "&race=" + race_id + "&dlg=1\");'>" + race_name + "</a>";
				<cfelseif g_dlg EQ "1">
					cell.innerHTML = "<a href='race_details.cfm?club=" + g_clubId + "&race=" + race_id + "&dlg=1&from=racer'>" + race_name + "</a>";
				</cfif>
				
				cell.setAttribute("class","cellData");

			}
		}
	}
	
	function goFull() {
		parent.window.location.href = "racer_detail.cfm?club=" + g_clubId + "&racer=" + g_racerId;
	}
	

	//****************************** LINE CHART *****************************
	function initAvgFinChart() {
		var labels = [];
		var data = [];
		
		for(var i=0; i<g_arrAvgFinData.length; i++) { // add the data
			var thisArr = g_arrAvgFinData[i];
			labels.push(thisArr[2])
			data.push(thisArr[0]);
		}
		
		avgFinLineData = {
			labels : labels,
			datasets : [
				{
					fillColor : "rgba(255,152,0,0.2)",
					strokeColor : "rgba(255,152,0,1)",
					pointColor : "rgba(255,152,0,1)",
					pointStrokeColor : "#7E8AA2",
					pointHighlightFill : "#7E8AA2",
					pointHighlightStroke : "rgba(255,152,0,1)",
					data : data
				}
			]
		}
		
		var ctx = document.getElementById("avgFinCanvas").getContext("2d");
		avgFinLine = new Chart(ctx).Line(avgFinLineData, {
			responsive: true,
			bezierCurve: false,
			scaleGridLineColor : "rgba(100,100,100,.08)",
			datasetFill : false,
			scaleFontColor: "#7E8AA2",
			scaleFontFamily: "'Monda', sans-serif",
			scaleFontSize: 16,
			scaleBeginAtZero: false
		});
	}
	
	function openInDlgWindow(title, url) {
		var frame = document.getElementById("frameDialog");
		var dlgHeight = parseInt(screen.availHeight)/1.5;
		var dlg = document.getElementById("divDialog");

		dlg.style.display = "";
		frame.style.height = dlgHeight+"px";
		frame.style.width = "935px";
		dlg.style.top = "100px";

		frame.src = url;
		
		document.getElementById("spanDialogName").innerHTML = title;
		document.getElementById("linkDialogClose").setAttribute("onclick", "closeDlgWindow();");
		showOverlay(true);
	}
	
	function closeDlgWindow() {
		document.getElementById("divDialog").style.display = "none";
		showOverlay(false);
	}

</script>
</body>
</html>
