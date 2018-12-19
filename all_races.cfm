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
<link href='http://fonts.googleapis.com/css?family=Monda:400' rel='stylesheet' type='text/css'>
<link href='nav_list.css' rel='stylesheet' type='text/css'>
<title>Racing Club Manager - All Results</title>

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
	var g_raceName = "";

	$(window).resize(function () { resizeOverlay() });
	
	function init() {
		getAllResults();
	}

	function getAllResults() {
		var instance = new races_proxy();
		instance.setCallbackHandler(fillRecentResults);
		instance.get_all_results(g_clubId);
	}
	
	function fillRecentResults(result) {
		var tbl = document.getElementById("tblRecent");
		var rows = getRows(result);
		if(rows.length > 0) {
			for(var i=0; i<rows.length; i++) {
				
				var fields = rows[i].split("|");
				var race_id = fields[0];
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
				
				cell = row.insertCell(-1);
				cell.innerHTML = "<a href='javascript:getRaceDetails(true," + race_id + ")' title='View full results from this race'>" + race_name + "</a>";
				
				cell = row.insertCell(-1);
				cell.innerHTML = winner;
				
				cell = row.insertCell(-1);
				cell.innerHTML = second;
				
				cell = row.insertCell(-1);
				cell.innerHTML = third;
			}
		} else {
			var row = tbl.insertRow(-1);
			var cell = row.insertCell(-1);
			cell.align = "center";
			cell.colSpan = "5";
			cell.innerHTML = "No races have been completed.";
		}
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

</script>

</head>
<body onload="init();">
<cfinclude template="include/navigation.cfm">
<cfinclude template="include/dialogs.cfm">

<div id="divRaceDetails" align="center" style="display: none;z-index:3000;">
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
<h2>All Results</h2>
<a href="javascript:goBack();">Back</a>
<table id="tblRecent" border="0" cellspacing="2" cellpadding="3" width="75%">
	<tr class="dataHeaderBG">
		<td align="center" class="dataHeaderTxt">
			<b>Date</b>
		</td>
		<td align="center" class="dataHeaderTxt">
			<b>Name</b>
		</td>
		<td align="center" class="dataHeaderTxt">
			<b>Winner</b>
		</td>
		<td align="center" class="dataHeaderTxt">
			<b>Second</b>
		</td>
		<td align="center" class="dataHeaderTxt">
			<b>Third</b>
		</td>
	</tr>
</table>
</div>






</body>
</html>
