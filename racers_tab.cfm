<cfajaxproxy cfc="racers_server" jsclassname="racers_proxy" />
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
<link href='http://fonts.googleapis.com/css?family=Monda:400' rel='stylesheet' type='text/css'>
<link href='nav_list.css' rel='stylesheet' type='text/css'>
<title>Racing Club Manager - Racers</title>
<style type="text/css">
	body {
		margin: 0px;
		font-family: 'Monda', sans-serif;
		font-size: 10pt;
		background-color: #fff;
		color: black;
	}
	
	td {
		font-size: 10pt;
	}
	
	a {
		text-decoration: none;
	}
	
	.cellData {
		/*font-size: 36px;*/
	}
	
	.infoBtn {
		cursor:pointer;
	}
</style>
<script type="text/javascript" src="include/jquery-1.11.1.min.js"></script>
<script language='javascript' src='common.js'></script>
<script>
	<cfoutput>
	var g_clubId = parseInt("#g_clubId#");
	</cfoutput>
	var g_arr = [];
	var currSort = -1;
	
	$(window).resize(function () { resizeOverlay() });
	
	function init() {
		getRacers();
	}

	function getRacers() {
		var instance = new racers_proxy();
		instance.setCallbackHandler(parseResults);
		instance.get_racers(g_clubId);
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
		
		fillRacers(g_arr);
	}
	
	function fillRacers(arr) {
		var tbl = document.getElementById("tblRacers");
		
		// remove rows from table before filling
		for(var i = tbl.rows.length - 1; i > 0; i--) {
			tbl.deleteRow(i);
		}
		
		if(arr.length > 0) {
			for(var i=0; i<arr.length; i++) {
				
				var fields = arr[i];
				var racer_name = decodeString(fields[0]);
				var total_pts = fields[1];
				var num_races = fields[2];
				var podiums = fields[3];
				var avg_start = fields[4];
				var avg_finish = fields[5];
				var rival = decodeString(fields[6]);
				var podiumPerc = fields[7];
				var racer_id = fields[8];
				
				var row = tbl.insertRow(-1);
				row.style.backgroundColor = getRowColor(i);
				
				var cell = row.insertCell(-1);
				cell.innerHTML = "<a href='javascript:showRacerDetail(" + racer_id + ");'>" + racer_name + "</a>";
				cell.setAttribute("class","cellData");
				
				cell = row.insertCell(-1);
				cell.align = "center";
				cell.innerHTML = total_pts;
				cell.setAttribute("class","cellData");
				
				cell = row.insertCell(-1);
				cell.align = "center";
				cell.innerHTML = num_races;
				cell.setAttribute("class","cellData");
				
				cell = row.insertCell(-1);
				cell.align = "center";
				cell.innerHTML = podiums;
				cell.setAttribute("class","cellData");
				
				cell = row.insertCell(-1);
				cell.align = "center";
				cell.innerHTML = podiumPerc;
				cell.setAttribute("class","cellData");
				
				cell = row.insertCell(-1);
				cell.align = "center";
				cell.innerHTML = avg_start;
				cell.setAttribute("class","cellData");
				
				cell = row.insertCell(-1);
				cell.align = "center";
				cell.innerHTML = avg_finish;
				cell.setAttribute("class","cellData");
				
				cell = row.insertCell(-1);
				cell.align = "center";
				cell.innerHTML = rival;
				cell.setAttribute("class","cellData");

			}
		} else {
			var row = tbl.insertRow(-1);
			var cell = row.insertCell(-1);
			cell.align = "center";
			cell.colSpan = "5";
			cell.innerHTML = "There are no racers set-up for this club.";
		}
	}
	
	function showRacerDetail(racer_id) {
		var url = "racer_detail.cfm?dlg=1&club=" + g_clubId + "&racer=" + racer_id;
		var title = "Racer Detail";
		openInDlgWindow(title, url);
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
			if(col == 0 | col == 6) {
				g_arr.sort(function(a,b) {
					if(a[col].toLowerCase() > b[col].toLowerCase()) {
						return 1;
					} else if(a[col].toLowerCase() < b[col].toLowerCase()) {
						return -1;
					}
				});
			} else {
				g_arr.sort(function(a,b) {
					return a[col] - b[col];
				});
			}
		} else {
			if(col == 0 | col == 6) {
				g_arr.sort(function(a,b) {
					if(a[col].toLowerCase() < b[col].toLowerCase()) {
						return 1;
					} else if(a[col].toLowerCase() > b[col].toLowerCase()) {
						return -1;
					}
				});
			} else {
				g_arr.sort(function(a,b) {
					return b[col] - a[col];
				});
			}
		}
		
		fillRacers(g_arr);
	}
	
	function showInfoButton(strHelp) {
		var strMsg = "";
		
		switch(strHelp) {
			case "rival":
				strMsg = "<b>Rival Help</b><br />";
				strMsg += "<br />Your rival is determined by first finding everyone who finishes 1 spot ahead of you, whoever finishes 1 spot ahead of you the most is your rival.";
				break;
		}
		
		showLoadingDiv(true, strMsg + "<br />" + dlgCloseBtn);
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
<h2>Racers</h2>
<br />
</cfif>
<!--<table id="tblYears" border="0" cellspacing-->
<table id="tblRacers" border="0" cellspacing="2" cellpadding="3" width="75%">
	<tr class="dataHeaderBG">
		<td valign="middle" align="center" class="dataHeaderTxt">
			<a href="javascript:sortBy(0)" title="Click to sort by Racer Name">Name</a>
		</td>
		<td valign="middle" align="center" class="dataHeaderTxt">
			<a href="javascript:sortBy(1)" title="Click to sort by Points Earned">Points<br />Earned</a>
		</td>
		<td valign="middle" align="center" class="dataHeaderTxt">
			<a href="javascript:sortBy(2)" title="Click to sort by Races Attended">Races<br />Attended</a>
		</td>
		<td valign="middle" align="center" class="dataHeaderTxt">
			<a href="javascript:sortBy(3)" title="Click to sort by Number of Podium Finishes">Podiums</a>
		</td>
		<td valign="middle" align="center" class="dataHeaderTxt">
			<a href="javascript:sortBy(7)" title="Click to sort by Number of Podium Percentage">Podium %</a>
		</td>
		<td valign="middle" align="center" class="dataHeaderTxt">
			<a href="javascript:sortBy(4)" title="Click to sort by Average Start">Avg<br />Start</a>
		</td>
		<td valign="middle" align="center" class="dataHeaderTxt">
			<a href="javascript:sortBy(5)" title="Click to sort by Average Finish">Avg<br />Finish</a>
		</td>
		<td valign="middle" align="center" class="dataHeaderTxt">
			<a href="javascript:sortBy(6)" title="Click to sort by Rival">Rival</a>
			<img src="imgs/info_button.png" onclick="showInfoButton('rival');" id="info_rival" class="infoBtn" />
		</td>
	</tr>
</table>
</div>


</body>
</html>