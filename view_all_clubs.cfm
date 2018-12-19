<cfajaxproxy cfc="search_proxy" jsclassname="search_proxy" />
<cfif IsDefined("URL.from")>
	<cfset g_comingFrom = "#URL.from#">
<cfelse>
	<cfset g_comingFrom = "N">
</cfif>
<html>
<head>
<link href='http://fonts.googleapis.com/css?family=Monda:400' rel='stylesheet' type='text/css'>
<title>Racing Club Manager</title>

<style type="text/css">
	body {
		background-color: white;
		margin: 0px;
		/*font-family: Verdana;*/
		font-family: 'Monda', sans-serif;
	}
	
	td {
		font-size: 10pt;
		font-family: 'Monda', sans-serif;
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
	
	.title {
		color: #FF9800;
	}
	
	.block {
		background-color: #FF9800;
	}
	
	#clubSearchLink {
		color: #fff;
	}
	
	#clubSearchLink a {
		color: #FF9800;
		padding: 5px;
	}

	.dataHeaderTxt {
		color: #000;
	}

	.dataHeaderTxt a {
		color: #000;
		text-decoration: underline;
	}
</style>
<cfinclude template="include/analytics.cfm" />
<script language='javascript' src='common.js'></script>
<script>
	<cfoutput>
	var g_comingFrom = "#g_comingFrom#";
	</cfoutput>
	
	function init() {
		
		if(g_comingFrom == "index") {
			document.getElementById("clubSearchLink").style.display = "none";
		}
		
		getAllClubs();
	}
	
	function getAllClubs() {
		var instance = new search_proxy();
		instance.setCallbackHandler(fillAllClubs);
		instance.get_all_clubs();
	}
	
	function fillAllClubs(result) {
		
		if(result.length > 0) {
			result = result + "<row>";
			var rows = result.split("<row>");
			rows.pop();
			for(var i=0; i<rows.length; i++) {
				
				var fields = rows[i].split("|");
				var club_id = fields[0]
				var club_name = decodeString(fields[1]);
				var game_name = fields[2];
				var platform = fields[3];
				var platformImg = "";
				
				if(platform == "XBOX One" || platform == "XBOX 360") {
					platformImg = "xbox.png";
				} else if(platform == "Playstation 3" || platform == "Playstation 4") {
					platformImg = "ps.png";
				} else if(platform == "PC") {
					platformImg = "PC.png";
				}
				
				if(platform.length > 0) {
					platformImg = "<img src='imgs/" + platformImg + "' height='16' width='16' title='" + platform + "' />";
				}
				
				var tbl = document.getElementById("tblAllClubs");
				var row = tbl.insertRow(-1);
				row.style.backgroundColor = getRowColor(i);
				
				var cell = row.insertCell(-1);
				cell.innerHTML = "<a href='javascript:goToClub(" + club_id + ")' title='Click here to view this club's home page.'>" + club_name + " - " + game_name + "</a>&nbsp;&nbsp;&nbsp;" + platformImg;
				
				//cell = row.insertCell(-1);
				//cell.innerHTML = "<a href='javascript:askToJoin(" + club_id + ")' title='Click here to submit a request to join this club.'>Ask to Join</a>";
				
			}
		}
	}
	

	function goToClub(club_id) {
		parent.window.location = "club_home.cfm?club=" + club_id
	}
	
	function askToJoin(club_id) {
		window.location = "ask_to_join.cfm?from=" + g_comingFrom + "&club=" + club_id
	}
	
	function showClubSearch(blnShow) {
		var strDisplay = "";
		if(!blnShow) {
			strDisplay = "none";
		}
		
		document.getElementById("overlay").style.display = strDisplay;
		document.getElementById("overlay").style.width = document.body.offsetWidth;
		document.getElementById("overlay").style.height = document.body.offsetHeight;
		document.getElementById("clubSearchDiv").style.display = strDisplay;
		document.body.style.overflow = "hidden";
	}
	
	function goHome() {
		window.location = "index.html?stay=yes";
	}
	

</script>

</head>
<body onload="init();">
<div style="width:100%;" align="center">

<div style="width:100%;background-color: #263248;" align="center">
<div id="clubSearchLink" align="left" style="width:95%; font-size: 10pt;">
	<a href="club_search_white.cfm" onclick="parent.makeDlgSmaller();">Club Search</a> &gt; View All Clubs
</div>
</div>

<div style="font-size: 24px;">All Clubs</div>



<table id="tblAllClubs" border="0" cellspacing="2" cellpadding="3" width="100%">
	<tr>
		<td align="center">
			&nbsp;
		</td>
	</tr>
</table>
</div>






</body>
</html>
