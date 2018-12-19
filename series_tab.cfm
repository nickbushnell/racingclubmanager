<cfajaxproxy cfc="series_server" jsclassname="series_proxy" />
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
<title>Racing Club Manager - Series</title>
<style type="text/css">
	body {
		margin: 0px;
		font-family: 'Monda', sans-serif;
		font-size: 10pt;
		background-color: #fff;
	}
	
	td {
		font-size: 10pt;
	}
	
	a {
		text-decoration: none;
	}
	
	.screen_title {
		font-size: 22pt;
		font-weight: bold;
	}
	
	#divSeriesDetails {
		position: absolute;
		z-index: 500;
		top: 50px;
		width: 100%;
	}
	
	.inactive {
		color: #FF9800;
	}
	
	.divSeries {
		background-color: #263248;
		color: white;
		height: 250px;
		width: 250px;
		padding: 10px;
		margin: 20px;
		cursor: pointer;
		display: inline-block;
		vertical-align: top;
	}
	
	.divSeries:hover {
		background-color: #7E8AA2;
	}
	
	.divSeriesName {
		font-size: 20pt;
		height: 180px;
	}
	
	.hr {
		height: 2px;
		background-color: white;
	}
	
	.divNextRace {
		font-size: 16pt;
	}
</style>
<script type="text/javascript" src="include/jquery-1.11.1.min.js"></script>
<script language='javascript' src='common.js'></script>
<script>
	if(!String.prototype.trim) {
		String.prototype.trim=function(){return this.replace(/(?:(?:^|\n)\s+|\s+(?:$|\n))/g,'').replace(/\s+/g,' ');};
	}
	
	<cfoutput>
	var g_clubId = parseInt("#g_clubId#");
	</cfoutput>
	var g_race_id = 0;
	
	$(window).resize(function () { resizeOverlay() });
	
	function init() {
		getSeries();
	}

	function getSeries() {
		var instance = new series_proxy();
		instance.setCallbackHandler(fillSeries);
		instance.get_series(g_clubId);
	}
	
	function removeTblRows(tblObj) {
		// remove rows from table before filling
		for(var i = tblObj.rows.length - 1; i > 0; i--) {
			tblObj.deleteRow(i);
		}
	}
	
	function fillSeries(result) {
		var divSeriesContainer = document.getElementById("seriesContainer");
		
		if(result.length > 0) {
			result = result + "<row>";
			var rows = result.split("<row>");
			rows.pop();
			for(var i=0; i<rows.length; i++) {
				
				var fields = rows[i].split("|");
				var series_id = fields[0];
				var series_name = decodeString(fields[1].trim());
				var next_race = displayDate(fields[2]);
				if(next_race.length == 0) {
					next_race = "<span class='inactive'>Inactive</span>";
				} else {
					var date = next_race.split(" ")[0];
					var time = next_race.split(" ")[1] + " " + next_race.split(" ")[2];
					var month = displayMonth(parseInt(date.split("/")[0]));
					var day = date.split("/")[1]
					var year = date.split("/")[2];
					next_race = month + " " + day + ", " + year + "<br />" + time;
				}
				
				
				var div = createDiv(series_id, series_name, next_race);
				divSeriesContainer.appendChild(div);
			}
		}
	}
	
	function createDiv(series_id, series_name, next_race) {
		var divSeriesName = document.createElement("div");
		divSeriesName.innerHTML = series_name;
		divSeriesName.className = "divSeriesName";
		
		var divHR = document.createElement("div");
		divHR.innerHTML = "";
		divHR.className = "hr";
		
		var divNextRace = document.createElement("div");
		divNextRace.innerHTML = next_race;
		divNextRace.className = "divNextRace";
		
		var div = document.createElement("div");
		div.className = "divSeries";
		
		if (div.addEventListener) {  // all browsers except IE before version 9
			div.addEventListener("click", function() { getSeriesDetails(true, series_id); }, false);
		} else {
			if (div.attachEvent) {   // IE before version 9
				div.attachEvent("click", function() { getSeriesDetails(true, series_id); });
			}
		}
		
		div.appendChild(divSeriesName);
		div.appendChild(divHR);
		div.appendChild(divNextRace);
		
		return div;
	}
	
	function displayMonth(intMonth) {
		var retVal = "";
		switch(intMonth) {
			case 1:
				retVal = "January";
				break;
			case 2:
				retVal = "February";
				break;
			case 3:
				retVal = "March";
				break;
			case 4:
				retVal = "April";
				break;
			case 5:
				retVal = "May";
				break;
			case 6:
				retVal = "June";
				break;
			case 7:
				retVal = "July";
				break;
			case 8:
				retVal = "August";
				break;
			case 9:
				retVal = "September";
				break;
			case 10:
				retVal = "October";
				break;
			case 11:
				retVal = "November";
				break;
			case 12:
				retVal = "December";
				break;
			default:
				retVal = "";
				break;
		}
		
		return retVal;
	}
	
	function getSeriesDetails(bln, race_id) {
		if(bln) {
			var ptsHeight = parseInt(screen.availHeight)/1.5;
			var dlg = document.getElementById("divDialog");
			var frame = document.getElementById("frameDialog");

			dlg.style.display = "";
			frame.style.height = ptsHeight+"px";
			frame.style.width = "935px";
			dlg.style.top = "100px";
			
			var frameSrc = "series_details.cfm?club=" + g_clubId + "&series=" + race_id + "&dlg=1";
			frame.src = frameSrc;
			
			document.getElementById("spanDialogName").innerHTML = "Series Details";
			document.getElementById("linkDialogClose").setAttribute("onclick", "getSeriesDetails(false,null)");
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

<div id="divSeriesDetails" align="center" style="display: none;z-index:3000;">
	<table border="0" style="background-color: white;border: 2px solid #ccc;width: 60%;">
		<tr>
			<td align="right">
				<a href="javascript:displayId('divSeriesDetails', 'none');showOverlay(false);">Close</a>
			</td>
		</tr>
		<tr>
			<td id="seriesDetails">
			
			</td>
		</tr>
	</table>
</div>

<div class="screen_title" align="center">Series</div>
<br />
<div style="width:100%;" align="center" id="seriesContainer">
</div>






</body>
</html>
