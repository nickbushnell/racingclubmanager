<cfajaxproxy cfc="club_home_server" jsclassname="club_proxy" />
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

<html>
<head>
<link href='http://fonts.googleapis.com/css?family=Monda:400' rel='stylesheet' type='text/css'>
<link href='nav_list.css' rel='stylesheet' type='text/css'>
<title>Racing Club Manager</title>
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
		/*font-family: 'Monda', sans-serif;*/
	}
	
	a {
		color: #FF9800;
	}
	
	#divClubName {
		font-size:48px;
		font-weight:bold;
		width:100%;
	}
	
	#chartContainer {
		width:900px;
		background-color:#FF9800;
		cursor:pointer;
		color: #000;
		font-size: 14pt;
	}
	
	#descContainer {
		width:900px;
		background-color:#FF9800;
		cursor:pointer;
		color: #000;
		font-size: 14pt;
	}
	
	#divNextRace {
		font-size: 18pt;
	}
	
	#divNextRaceData {
		font-size: 14pt;
	}
	
	.club_traits_title {
		font-size: 16pt;
		font-weight:bold;
		color: #000;
	}
	
	.club_trait {
		font-size: 13pt;
		color: #000;
	}
	
	#divDefault {
		background-color: #7E8AA2;
		padding: 5px;
		font-size: 12pt;
		width:150px;
		cursor:pointer;
	}
	
	#divAskToJoin {
		background-color: #FF9800;
		padding: 5px;
		font-size: 12pt;
		width:150px;
		cursor:pointer;
	}

</style>
<cfinclude template="include/analytics.cfm" />
<script src="charts/chart.js"></script>
<cfoutput>
<script type="text/javascript">
	var g_clubId = parseInt("#g_clubId#");
</script>
</cfoutput>
<script language='javascript' src='common.js'></script>
<script type="text/javascript" src="include/jquery-1.11.1.min.js"></script>
<script type="text/javascript">

	var g_arrChartData = [];
	var myLine = null;
	var lineChartData = null;
	
	$(window).resize(function () { doResize() });
	
	function init() {
		if(getCookie("defaultClub")) {
			if(getCookie("defaultClub") == g_clubId.toString()) {
				showAsDefault(true);
			}
		}
		
		doResize();
		getClubNamePlatform();
	}
	
	function showAsDefault(bln) {
		var div = document.getElementById("divDefault");
		div.style.backgroundColor = "#FF9800";
		div.innerHTML = "&#10003; My Default";
	}
	
	function setDefaultClub() {
		setCookie("defaultClub",g_clubId.toString(), (365*3));
		showAsDefault();
	}
	
	function doResize() {
		var chartContainer = document.getElementById("chartContainer");
		var divAttendance = document.getElementById("divAttendance");
		var descContainer = document.getElementById("descContainer");
		var divDesc = document.getElementById("divDesc");
		var divNoAttendance = document.getElementById("divNoAttendance");
		
		var body = parseInt(document.body.offsetWidth);
		if(body < 900) {
			chartContainer.style.width = "100%";
			divAttendance.style.width = "100%";
			descContainer.style.width = "100%";
			divDesc.style.width = "100%";
			divNoAttendance.style.width = "100%";
		} else {
			chartContainer.style.width = "900px";
			divAttendance.style.width = "900px";
			descContainer.style.width = "900px";
			divDesc.style.width = "900px";
			divNoAttendance.style.width = "900px";
		}
		
		resizeOverlay();
	}
	
	function getClubNamePlatform() {
		var instance = new club_proxy();
		instance.setCallbackHandler(getClubNamePlatform_callback);
		instance.get_club_name_platform(g_clubId);
	}
	
	function getClubNamePlatform_callback(result) {
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E01" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		} else {
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				// write out club name
				document.getElementById("divClubName").innerHTML = decodeString(fields[1]);
				// write out game
				var platImg = "";
				var strPlatform = decodeString(fields[4]);
				if(strPlatform == "XBOX One" || strPlatform == "XBOX 360") {
					platImg = "xbox.png";
				} else if(strPlatform == "Playstation 3" || strPlatform == "Playstation 4") {
					platImg = "ps.png";
				} else if(strPlatform == "PC") {
					platImg = "PC.png";
				}

				if(strPlatform.length > 0) {
					document.getElementById("spanPlatform").innerHTML = "<img src='imgs/" + platImg + "' height='25' width='25' title='" + strPlatform + "' />";
				}
				
				var strClubSlug = decodeString(fields[6]);
				var clubSlugHTML = "";
				if(strClubSlug.length > 0) {
					clubSlugHTML = "<span style='color:#7E8AA2;'> | </span><span style='color:#FF9800;'>racingclubmanager.com/" + encodeURI(strClubSlug) + "</span>";
				}
				
				// write out platform
				document.getElementById("spanGame").innerHTML = decodeString(fields[5]) + clubSlugHTML;
				
				if(parseInt(fields[3]) == 1) {
					document.getElementById("divAskToJoin").style.display = "";
				}
			}
		}
		
		getNextRace();
	}
	
	function getNextRace() {
		var instance = new club_proxy();
		instance.setCallbackHandler(getNextRace_callback);
		instance.get_next_race(g_clubId);
	}
	
	function getNextRace_callback(result) {
		var div = document.getElementById("divNextRaceData");
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E02" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		} else if(rows[0] == "No Races Scheduled") {
			div.innerHTML = rows[0];
		} else {
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				
				var race_id = fields[0];
				var series_name = decodeString(fields[1]);
				var race_name = decodeString(fields[2]);
				var race_date = UTC2Local(fields[3]);
				
				strHTML = "<a href='javascript:showRaceDetails(" + race_id + ")'>" + series_name + " - " + race_name + "</a>"
				strHTML +="<br />" + race_date;
				strHTML +="<br /><a href='flags.cfm?race=" + race_id + "' style='color:#7E8AA2;'>Live Race Flags</a>";
				
				div.innerHTML = strHTML;
			}
		}
		
		getClubTraitsDesc();
		
	}
	
	function getClubTraitsDesc() {
		var instance = new club_proxy();
		instance.setCallbackHandler(getClubTraitsDesc_callback);
		instance.get_club_traits_desc(g_clubId);
	}
	
	function getClubTraitsDesc_callback(result) {
		var div = document.getElementById("divNextRaceData");
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E03" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		} else {
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				
				var club_since = new Date(UTC2Local(fields[0]));
				var club_since_string = (club_since.getMonth()+1) + "/" + club_since.getDate() + "/" + club_since.getFullYear();
				var personality = fields[1];
				var members = fields[2];
				var desc = decodeString(fields[3]);
				
				document.getElementById("spanPersonality").innerHTML = personality;
				document.getElementById("spanClubSince").innerHTML = club_since_string;
				document.getElementById("spanMembers").innerHTML = members;
				document.getElementById("divDesc").innerHTML = desc;
			}
		}
		
		getAttendanceData();
	}
	
	function getAttendanceData() {
		g_arrChartData = [];
		var instance = new club_proxy();
		instance.setCallbackHandler(getAttendanceData_callback);
		instance.get_attendance_data(g_clubId);
	}
	
	function getAttendanceData_callback(result) {
		//g_arrChartData
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E03" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		} else if(rows[0] == "noResults") {
			g_arrChartData = [];
		}else{
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				
				var attendees = parseInt(fields[0]);
				var race_date_raw = UTC2Local(fields[1]);
				//    10/15/2014 10:30 PM
				var race_date = race_date_raw.split("/")[0] + "/" + race_date_raw.split("/")[1];
				
				var tempArr = [];
				tempArr.push(attendees);
				tempArr.push(race_date);
				
				g_arrChartData.push(tempArr);
				
			}
		}
	}
	
	function setCookie(c_name,value,exdays) {
		var exdate=new Date();
		exdate.setDate(exdate.getDate() + exdays);
		var c_value=escape(value) + ((exdays==null) ? "" : "; expires="+exdate.toUTCString());
		document.cookie=c_name + "=" + c_value;
	}
	
	function getCookie(c_name) {
		var c_value = document.cookie;
		var c_start = c_value.indexOf(" " + c_name + "=");
		if (c_start == -1)
		  {
		  c_start = c_value.indexOf(c_name + "=");
		  }
		if (c_start == -1)
		  {
		  c_value = null;
		  }
		else
		  {
		  c_start = c_value.indexOf("=", c_start) + 1;
		  var c_end = c_value.indexOf(";", c_start);
		  if (c_end == -1)
		  {
		c_end = c_value.length;
		}
		c_value = unescape(c_value.substring(c_start,c_end));
		}
		return c_value;
	}
	
	function showChart() {
		var div = document.getElementById("divAttendance");
		var div2 = document.getElementById("divNoAttendance");
		if(div.style.display == "" || div2.style.display == "") {
			div.style.display = "none";
			div2.style.display = "none";
		} else {
			if(g_arrChartData.length > 0) {
				div.style.display = "";
				initChart();
			} else {
				div2.style.display = "";
			}
		}
	}
	
	function destroyChart() {
		for(var i=0; i<g_arrChartData.length; i++) { // remove all data
			myLine.removeData();
		}
	}
	
	function initChart() {
		var labels = [];
		var data = [];
		
		for(var i=0; i<g_arrChartData.length; i++) { // add the data
			var thisArr = g_arrChartData[i];
			labels.push(thisArr[1])
			data.push(thisArr[0]);
		}
		
		lineChartData = {
			labels : labels,
			datasets : [
				{
					fillColor : "rgba(255,152,0,0.2)",
					strokeColor : "rgba(255,152,0,1)",
					pointColor : "rgba(255,152,0,1)",
					pointStrokeColor : "#fff",
					pointHighlightFill : "#fff",
					pointHighlightStroke : "rgba(255,152,0,1)",
					data : data
				}
			]
		}
		
		var ctx = document.getElementById("canvas").getContext("2d");
		myLine = new Chart(ctx).Line(lineChartData, {
			responsive: true,
			bezierCurve: false,
			scaleGridLineColor : "rgba(255,255,255,.08)",
			datasetFill : false,
			scaleFontColor: "#fff",
			scaleFontFamily: "'Monda', sans-serif",
			scaleFontSize: 16,
			scaleBeginAtZero: true
		});
	}

	function showDesc() {
		var div = document.getElementById("divDesc");
		if(div.style.display == "") {
			div.style.display = "none";
		} else {
			div.style.display = "";
		}
	}
	
	function showAskToJoin(bln) {
		if(bln) {
			displayId('clubSearchDiv', '');
			showOverlay(true);
			
			var dlgHeight = parseInt(screen.availHeight)/1.5;
			var dlg = document.getElementById("clubSearchDiv");
			dlg.style.top = "100px";
			makeDlgBigger();
			
			document.getElementById("iframe_clubSearch").src = "ask_to_join.cfm?club=" + g_clubId;
		} else {
			displayId('clubSearchDiv', 'none');
			showOverlay(false);
		}
	}
	
	function showRaceDetails(race_id) {
		window.location.href = "race_details.cfm?club=" + g_clubId + "&race=" + race_id;
	}

</script>
</head>
<body onload="init();">
<cfinclude template="include/navigation.cfm">
<cfinclude template="include/dialogs.cfm">

<div id="divContainer" style="width:100%;" align="center">
	
	<!-- Club Details -->
	<table width="90%" align="center">
		<tr>
			<td align="left" valign="top">
				<div id="divClubName"></div>
				
				<div id="divGamePlatform">
					<span id="spanPlatform"></span> 
					<span id="spanGame" style="font-size: 20px;"></span>
				</div>
				
				<div style="font-size:5px">&nbsp;</div>
				
				<div id="divDefault" align="center" onclick="setDefaultClub();">
					&#10005; Not My Default
				</div>
				
				<div style="font-size:5px">&nbsp;</div>
				
				<div id="divAskToJoin" style="display:none;" onclick="showAskToJoin(true);" align="center">
					Ask to Join
				</div>
			</td>
			<td align="right" valign="top">
				<div id="divNextRace">Next Race</div>
				<div id="divNextRaceData"></div>
			</td>
		</tr>
	</table>
	
	<div style="font-size:20px;">&nbsp;</div>
	
	<!-- Club Traits -->
	<div id="divClubTraits">
		<table style="width:90%;">
			<tr>
				<td width="20%" align="center" valign="middle" style="background-color:#fff;">
					<span class="club_traits_title">Personality</span>
					<br />
					<span class="club_trait" id="spanPersonality"></span>
				</td>
				<td width="20%">&nbsp;</td>
				<td width="20%" align="center" valign="middle" style="background-color:#fff;">
					<span class="club_traits_title">Club<br />Since</span>
					<br />
					<span class="club_trait" id="spanClubSince"></span>
				</td>
				<td width="20%">&nbsp;</td>
				<td width="20%" align="center" valign="middle" style="background-color:#fff;">
					<span class="club_traits_title">Active<br />Members</span>
					<br />
					<span class="club_trait" id="spanMembers"></span>
				</td>
			</tr>
		</table>
	</div>
	
	<div style="font-size:20px;">&nbsp;</div>
	
	<!-- Graph -->
	<div id="chartContainer" align="left" onclick="showChart();">
		&#9662; Attendance Chart
	</div>
	<div id="divAttendance" style="width:900px;display:none;">
		<canvas id="canvas"></canvas>
	</div>
	<div id="divNoAttendance" style="width:900px;display:none;">
		At least 2 races need to be recorded before we can display this graph.
	</div>
	
	<div style="font-size:10px;">&nbsp;</div>
	
	<!-- Graph -->
	<div id="descContainer" align="left" onclick="showDesc();">
		&#9662; Club Description
	</div>
	<div id="divDesc" style="width:900px;text-align:left;"></div>

	
	
	
</div>



</body>
</html>
