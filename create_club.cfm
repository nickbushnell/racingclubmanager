<cfajaxproxy cfc="create_club_server" jsclassname="club_proxy" />
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
<title>Racing Club Manager - Create A Club</title>
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
	
	a {
		color: #FF9800;
	}
	
	#createTitle {
		color: #FF9800;
		font-size: 30px;
	}
	
	.myButton {
		font-size:14pt;
		font-family: 'Monda', sans-serif;
	}
	
	#btnSave{
		font-size:14pt;
		font-family: 'Monda', sans-serif;
		border:none;
		background-color:#FF9800;
		color:white;
		cursor:pointer;
		padding: 5px;
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
		var rows = getRows(result);
		var sel = document.getElementById("selGames");
		
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
			
			getPersonalities();
		}
	}
	
	function clearGames() {
		var sel = document.getElementById("selGames");
		sel.options.length = 1;
	}
	
	function getPersonalities() {
		clearPersonalities();
		var instance = new club_proxy();
		instance.setCallbackHandler(getPersonalities_callback);
		instance.get_all_personalities();
	}
	
	function getPersonalities_callback(result) {
		var rows = getRows(result);
		var sel = document.getElementById("selPersonality");
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E02" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		} else {
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				var id = fields[0];
				var name = fields[1].trim();
				
				var opt = document.createElement("option");
				opt.value = id;
				sel.appendChild(opt);
				sel.options[sel.options.length-1].innerHTML = name;
			}	
		}
		
		showLoadingDiv(false, "");
	}
	
	function clearPersonalities(result) {
		var sel = document.getElementById("selPersonality");
		sel.options.length = 1; // remove all options except the default
	}
	
	function validateClubName() {
		// make sure only regular chars
			// if only reg chars, check if name already taken
				// if name taken, show bad img
				// if name not taken, show good img
			// if not reg chars, show bad img
		
		var txt = document.getElementById("txtClubName");
		var club_name = txt.value.trim();
		if(club_name.length > 0) {
			if(onlyNormalChars(club_name)) {
				// do ajax call to check name
				var instance = new club_proxy();
				instance.setCallbackHandler(checkClubNameUnique_callback);
				instance.check_club_name_unique(club_name);
			} else {
				clubNameBad();
			}
		} else {
			if(club_name.length > 0) {
				// club name hasn't changed from when we came into page
				clubNameGood();
			} else {
				// nothing entered
				clubNameBad();
			}
		}
	}
	
	function checkClubNameUnique_callback(result) {
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E03" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		} else {
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				var ajaxResult = fields[0];
				if(ajaxResult == "good") {
					clubNameGood();
					return true;
				} else {
					clubNameBad();
					return false;
				}
			}
		}
	}
	
	function clubNameBad() {
		// clear new club name var
		club_name = "";
		// hide good image
		document.getElementById("imgNameGood").style.display = "none";
		document.getElementById("imgNameGood").style.visibility = "hidden";
		// show bad image
		document.getElementById("imgNameBad").style.display = "";
		document.getElementById("imgNameBad").style.visibility = "visible";
	}
	
	function clubNameGood() {
		// hide bad image
		document.getElementById("imgNameBad").style.display = "none";
		document.getElementById("imgNameBad").style.visibility = "hidden";
		// show good image
		document.getElementById("imgNameGood").style.display = "";
		document.getElementById("imgNameGood").style.visibility = "visible";
	}
	
	function validateEmail() {
		var email = document.getElementById("txtEmail").value;
		
		var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
		if(re.test(email)) {
			emailGood();
			return true;
		} else {
			emailBad();
			return false;
		}
	}
	
	function emailBad() {
		// clear new club name var
		club_name = "";
		// hide good image
		document.getElementById("imgEmailGood").style.display = "none";
		document.getElementById("imgEmailGood").style.visibility = "hidden";
		// show bad image
		document.getElementById("imgEmailBad").style.display = "";
		document.getElementById("imgEmailBad").style.visibility = "visible";
	}
	
	function emailGood() {
		// hide bad image
		document.getElementById("imgEmailBad").style.display = "none";
		document.getElementById("imgEmailBad").style.visibility = "hidden";
		// show good image
		document.getElementById("imgEmailGood").style.display = "";
		document.getElementById("imgEmailGood").style.visibility = "visible";
	}

	
	function saveClub() {
		var club = document.getElementById("txtClubName").value;
		var email = document.getElementById("txtEmail").value;
		var game_id = parseInt(document.getElementById("selGames").value);
		var personality_id = parseInt(document.getElementById("selPersonality").value);
		var platform = document.getElementById("selPlatform").value;
		
		if(club.length > 0 && email.length > 0 && game_id > 0 && personality_id > 0 && platform != "") {
			var instance = new club_proxy();
			instance.setCallbackHandler(saveClub_callback);
			instance.create_club(club,email,game_id,personality_id,platform);
		} else {
			var errMsg = "All of the fields are required." + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		}
	}
	
	function saveClub_callback(result) {
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E04" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		} else if(rows[0] == "clubExists") {
			var errMsg = "This club name is already in use." + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		} else if(rows[0] == "sendMailError") {
			var errMsg = "There was a problem trying to send you the welcome e-mail which contains your login name and password." + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		} else if(rows[0] == "invalidError") {
			var errMsg = "This club name contains invalid characters." + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		} else if(rows[0] == "platformError") {
			var errMsg = "A valid platform must be selected." + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		} else {
			// success
			var button = "<br /><input type='button' onclick='goToLogin();' value='Close' />";
			var errMsg = "Thanks for adding your club to the Racing Club Manager. Check your e-mail to get your login name and temporary password. You will be asked to change your password on login." + button;
			showLoadingDiv(true, errMsg);
		}
	}
	
	function goToLogin() {
		showLoadingDiv(false, "");
		window.location.href = "login.cfm";
	}
	
	function selDefaultPlatform() {
		var selGames = document.getElementById("selGames");
		var selectedGame = "";
		var selPlatform = document.getElementById("selPlatform");
		var defaultPlatform = "";
		
		if(selGames.selectedIndex > 0) {
			selectedGame = selGames.options[selGames.selectedIndex].innerHTML;
		} else {
			return;
		}
		
		if (selectedGame == "iRacing" || selectedGame == "rFactor 2" || selectedGame == "Assetto Corsa" || selectedGame == "Live for Speed" || selectedGame == "RaceRoom" || selectedGame == "simraceway") 
		{
			defaultPlatform = "PC";
		} 
		else if (selectedGame == "Forza 4") 
		{
			defaultPlatform = "XBOX 360";
		} 
		else if (selectedGame == "Forza 5" || selectedGame == "Forza 6") 
		{
			defaultPlatform = "XBOX One";
		} 
		else if (selectedGame == "Driveclub") 
		{
			defaultPlatform = "Playstation 4";
		} 
		else if (selectedGame == "Gran Turismo 5" || selectedGame == "Gran Turismo 6") 
		{
			defaultPlatform = "Playstation 3";
		} else {
			defaultPlatform = "";
		}
		
		var selIdx = 0;
		for(var i=0; i<selPlatform.options.length; i++) {
			var thisOpt = selPlatform.options[i].innerHTML;
			if(defaultPlatform == thisOpt) {
				selIdx = i;
				break;
			}
		}
		selPlatform.selectedIndex = selIdx;
	}

</script>

</head>
<body onload="init();">
<cfinclude template="include/navigation.cfm">
<cfinclude template="include/dialogs.cfm">

<div id="divContainer" style="width:100%;" align="center">
	
	<div style="font-size:30px;">&nbsp;</div>
	
	<div id="createTitle">
		+Create a Club
	</div>

	<table cellspacing="3" cellpadding="2" border="0">
		<tr>
			<td align="right" style="font-size:20pt;">
				Club Name:
			</td>
			<td align="left">
				<input type="text" name="txtClubName" id="txtClubName" value="" maxlength="50" style="width:10em;font-size:20pt;" onchange="validateClubName()" />
			</td>
			<td>
				<img src="imgs/green-check.png" id="imgNameGood" style="visibility:hidden;" />
				<img src="imgs/red-x.png" id="imgNameBad" style="display:none;visibility:hidden;" title="Club Names have to be unique and cannot contain special characters." />
			</td>
		</tr>
		<tr>
			<td align="right" style="font-size:20pt;">
				Game:
			</td>
			<td align="left" colspan="2">
				<select name="selGames" id="selGames" onchange="selDefaultPlatform()" style="width:10em;font-size:20pt;">
					<option value="0">Select One...</option>
				</select>
			</td>
		</tr>
		<tr>
			<td align="right" style="font-size:20pt;">
				Platform:
			</td>
			<td align="left" colspan="2">
				<select name="selPlatform" id="selPlatform" style="width:10em;font-size:20pt;">
					<option value="">Select One...</option>
					<option value="PC">PC</option>
					<option value="Playstation 4">Playstation 4</option>
					<option value="Playstation 3">Playstation 3</option>
					<option value="XBOX One">XBOX One</option>
					<option value="XBOX 360">XBOX 360</option>
				</select>
			</td>
		</tr>
		<tr>
			<td align="right" style="font-size:20pt;">
				Personality:
			</td>
			<td align="left">
				<select id="selPersonality" name="selPersonality" style="width:10em;font-size:20pt;">
					<option value="0">Select One...</option>
				</select>
			</td>
			<td>
				<img src="imgs/info_button.png" id="info_personality" title="If you're not sure what the Club's personality should be, then just select Open or Private and you can decide later." />
			</td>
		</tr>
		<tr>
			<td align="right" style="font-size:20pt;">
				E-mail:
			</td>
			<td align="left">
				<input type="text" name="txtEmail" id="txtEmail" value="" maxlength="100" style="width:10em;font-size:20pt;" onchange="validateEmail()" />
			</td>
			<td>
				<img src="imgs/green-check.png" id="imgEmailGood" style="visibility:hidden;" />
				<img src="imgs/red-x.png" id="imgEmailBad" style="display:none;visibility:hidden;" title="E-mail must be in a valid format." />
			</td>
		</tr>
		<tr>
			<td colspan="2" align="right">
				<input type="button" id="btnSave" value="Create Club" onclick="saveClub();" />
			</td>
			<td>&nbsp;</td>
		</tr>
	</table>
	
</div>



</body>
</html>
