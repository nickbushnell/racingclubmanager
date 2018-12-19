<cfajaxproxy cfc="club_profile_server" jsclassname="admin_proxy" />
<cfif Not IsDefined("Session.club_id")>
	<cfset session.goto = "club_profile.cfm">
	<cflocation url="login.cfm" addtoken="no">
</cfif>

<cfif Not IsDefined("Session.permission")>
	<cflocation url="logout.cfm" addtoken="no">
<cfelseif Session.permission GT 0>
	<cflocation url="logout.cfm?message=permission" addtoken="no">
</cfif>

<html>
<head>
<title>Racing Club Manager | Admin Club Profile Editor</title>
<link href='http://fonts.googleapis.com/css?family=Monda:400' rel='stylesheet' type='text/css'>
<link href='nav_list.css' rel='stylesheet' type='text/css'>
<style type="text/css">
	body {
		margin: 0px;
		font-family: 'Monda', sans-serif;
		font-size: 10pt;
	}
	
	select {
		font-family: 'Monda', sans-serif;
	}
	
	input {
		font-family: 'Monda', sans-serif;
	}
	
	td {
		font-size: 10pt;
	}
	
	a {
		text-decoration: none;
	}
	
	#txtClubName {
		width: 20em;
	}
	
	#selPersonality {
		width: 20em;
	}
	
	#btnDelete {
		background-color: red;
		color: white;
		padding: 3px;
		border: 0px;
		cursor:pointer;
	}
</style>
<script src="include/ckeditor_basic/ckeditor.js"></script>
<script type="text/javascript" src="include/jquery-1.11.1.min.js"></script>
<script language='javascript' src='common.js'></script>
<script type="text/javascript">
	if(!String.prototype.trim) {
		String.prototype.trim=function(){return this.replace(/(?:(?:^|\n)\s+|\s+(?:$|\n))/g,'').replace(/\s+/g,' ');};
	}
	
	var g_origClubName = "";
	var g_newClubName = "";
	var g_origSlugName = "";
	var g_newSlugName = "";
	var g_CKloaded = false;
	var g_chunkSize = 250;
	var g_chunkIdx = -1;
	var g_chunks = [];
	var g_okayToSave = false;

	$(window).resize(function () { resizeOverlay() });
	
	function init() {
		showLoadingDiv(true, "Loading...");
		g_origClubName = "";
		g_newClubName = "";
		g_origSlugName = "";
		g_newSlugName = "";
		document.getElementById("imgNameGood").style.visibility = "hidden";
		document.getElementById("imgNameBad").style.visibility = "hidden";
		document.getElementById("imgSlugGood").style.visibility = "hidden";
		document.getElementById("imgSlugBad").style.visibility = "hidden";
		getPersonalities();
	}
	
	function getPersonalities() {
		var instance = new admin_proxy();
		instance.setCallbackHandler(getPersonalities_callback);
		instance.get_all_personalities();
	}
	
	function getPersonalities_callback(result) {
		if(result.length > 0) {
			
			var sel = document.getElementById("selPersonality");
			sel.options.length = 1; // remove all options except the default
			
			result = result + "<row>";
			var rows = result.split("<row>");
			rows.pop();
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				var id = fields[0];
				var name = fields[1].trim();
				
				var opt = document.createElement("option");
				opt.value = id;
				sel.appendChild(opt);
				sel.options[sel.options.length-1].innerHTML = name;
			}
			
			// got our personalities, now we should get the data for this club profile
			getClubProfileData();
			
		} else {
			var errMsg = "This page encountered an error: E01";
			errMsg += "<br /><input type='button' onclick='showLoadingDiv(false, \"\")' value='Close' />";
			showLoadingDiv(true, errMsg);
		}
	}
	
	function getClubProfileData() {
		var instance = new admin_proxy();
		instance.setCallbackHandler(getClubProfileData_callback);
		instance.get_admin_club_profile_data();
	}
	
	function getClubProfileData_callback(result) {
		if(result.length > 0) {
			result = result + "<row>";
			var rows = result.split("<row>");
			rows.pop();
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				
				var club_name = fields[0].trim();
				g_origClubName = club_name;
				var club_started = fields[1];
				var game = fields[2];
				var personality = fields[3];
				var club_desc = decodeString(fields[4].trim());
				var ask_to_join = fields[5];
				var slug_name = decodeString(fields[6].trim());
				g_origSlugName = slug_name;
				var platform = decodeString(fields[7].trim());
				
				loadClubName(club_name);
				loadSlugName(slug_name);
				loadPersonality(personality);
				loadPlatform(platform);
				loadAskToJoin(ask_to_join);
				loadClubDesc(club_desc);
				showLoadingDiv(false, "");
			}
			
			
		} else {
			var errMsg = "This page encountered an error: E02";
			errMsg += "<br /><input type='button' onclick='showLoadingDiv(false, \"\")' value='Close' />";
			showLoadingDiv(true, errMsg);
		}
	}
	
	function validateClubName() {
		// make sure only regular chars
			// if only reg chars, check if name already taken
				// if name taken, show bad img
				// if name not taken, show good img
			// if not reg chars, show bad img
		
		var txt = document.getElementById("txtClubName");
		g_newClubName = txt.value.trim();
		if(g_newClubName.length > 0 && g_newClubName != g_origClubName) {
			if(onlyNormalChars(g_newClubName)) {
				// do ajax call to check name
				var instance = new admin_proxy();
				instance.setCallbackHandler(checkClubNameUnique_callback);
				instance.check_club_name_unique(g_newClubName);
			} else {
				clubNameBad();
			}
		} else {
			if(g_newClubName.length > 0) {
				// club name hasn't changed from when we came into page
				clubNameGood();
			} else {
				// nothing entered
				clubNameBad();
			}
		}
	}
	
	function checkClubNameUnique_callback(result) {
		if(result.length > 0) {
			result = result + "<row>";
			var rows = result.split("<row>");
			rows.pop();
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				var ajaxResult = fields[0];
				if(ajaxResult == "good") {
					clubNameGood();
				} else {
					clubNameBad();
				}
			}
		} else {
			var errMsg = "There was an error processing your club name";
			errMsg += "<br /><input type='button' onclick='showLoadingDiv(false, \"\")' value='Close' />";
			showLoadingDiv(true, errMsg);
		}
	}
	
	function clubNameBad() {
		// clear new club name var
		g_newClubName = "";
		// hide good image
		document.getElementById("imgNameGood").style.display = "none";
		document.getElementById("imgNameGood").style.visibility = "hidden";
		// show bad image
		document.getElementById("imgNameBad").style.display = "";
		document.getElementById("imgNameBad").style.visibility = "visible";
		// disable save button
		toggleSaveBtn();
	}
	
	function clubNameGood() {
		// hide bad image
		document.getElementById("imgNameBad").style.display = "none";
		document.getElementById("imgNameBad").style.visibility = "hidden";
		// show good image
		document.getElementById("imgNameGood").style.display = "";
		document.getElementById("imgNameGood").style.visibility = "visible";
		// enable save button
		toggleSaveBtn();
	}
	
	function loadClubName(str) {
		var obj = document.getElementById("txtClubName");
		obj.value = str;
	}

	function validateSlugName(doingSave) {
		// make sure only regular chars
			// if only reg chars, check if name already taken
				// if name taken, show bad img
				// if name not taken, show good img
			// if not reg chars, show bad img
		
		var txt = document.getElementById("txtSlugName");
		g_newSlugName = txt.value.trim();
		if(g_newSlugName.length > 0 && g_newSlugName != g_origSlugName) {
			if(onlyNormalChars(g_newSlugName)) {
				// do ajax call to check name
				if(g_newSlugName.indexOf(" ") >= 0 && !doingSave) {
					var errMsg = "<b>Warning:</b><br />You are allowed to use spaces in your slug and it will work when typing into your browser, but please know that your links will be broken if you were to type them into social media without first URL encoding any spaces.";
					errMsg += "<br /><input type='button' onclick='showLoadingDiv(false, \"\")' value='Close' />";
					showLoadingDiv(true, errMsg);
				}
				
				var instance = new admin_proxy();
				instance.setCallbackHandler(checkSlugNameUnique_callback);
				instance.check_slug_name_unique(g_newSlugName);
			} else {
				slugNameBad();
			}
		} else {
			if(g_newSlugName.length > 0) {
				// club name hasn't changed from when we came into page
				slugNameGood();
			} else {
				// nothing entered
				slugNameBad();
			}
		}
	}
	
	function checkSlugNameUnique_callback(result) {
		if(result.length > 0) {
			result = result + "<row>";
			var rows = result.split("<row>");
			rows.pop();
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				var ajaxResult = fields[0];
				if(ajaxResult == "good") {
					slugNameGood();
				} else {
					slugNameBad();
				}
			}
		} else {
			var errMsg = "There was an error processing your URL slug name";
			errMsg += "<br /><input type='button' onclick='showLoadingDiv(false, \"\")' value='Close' />";
			showLoadingDiv(true, errMsg);
		}
	}
	
	function slugNameBad() {
		// clear new club name var
		g_newSlugName = "";
		// hide good image
		document.getElementById("imgSlugGood").style.display = "none";
		document.getElementById("imgSlugGood").style.visibility = "hidden";
		// show bad image
		document.getElementById("imgSlugBad").style.display = "";
		document.getElementById("imgSlugBad").style.visibility = "visible";
		toggleSaveBtn();
	}
	
	function slugNameGood() {
		// hide bad image
		document.getElementById("imgSlugBad").style.display = "none";
		document.getElementById("imgSlugBad").style.visibility = "hidden";
		// show good image
		document.getElementById("imgSlugGood").style.display = "";
		document.getElementById("imgSlugGood").style.visibility = "visible";
		toggleSaveBtn();
	}
	
	function loadSlugName(str) {
		var obj = document.getElementById("txtSlugName");
		obj.value = str;
	}
	
	function toggleSaveBtn() {
		var saveBtn = document.getElementById("btnSave");
		var clubBad = document.getElementById("imgNameBad").style.display;
		var slugBad = document.getElementById("imgSlugBad").style.display;
		
		// if both club and slug are okay, enable
		if(clubBad == "none" && slugBad == "none") {
			saveBtn.disabled = false;
			g_okayToSave = true;
		}

		// if either club and/or slug are bad, disable
		if(clubBad == "" || slugBad == "") {
			saveBtn.disabled = true;
			g_okayToSave = false;
		}

	}

	function loadPersonality(intValue) {
		var sel = document.getElementById("selPersonality");
		for(var i=0; i<sel.options.length; i++) {
			if(parseInt(sel.options[i].value) == parseInt(intValue)) {
				sel.selectedIndex = i;
				break;
			}
		}
	}
	
	function loadPlatform(strValue) {
		if(strValue != "") {
			var sel = document.getElementById("selPlatform");
			for(var i=0; i<sel.options.length; i++) {
				if(sel.options[i].value == strValue) {
					sel.selectedIndex = i;
					break;
				}
			}
		}
	}
	
	
	function loadAskToJoin(ask_to_join) {
		if(ask_to_join == 1) {
			document.getElementById("radJoin_yes").checked = true;
			document.getElementById("radJoin_no").checked = false;
		} else {
			document.getElementById("radJoin_no").checked = true;
			document.getElementById("radJoin_yes").checked = false;
		}
	}
	
	function loadClubDesc(str) {
		document.getElementById("textarea_1").value = str;
		loadCK();
	}
	
	function editAdmins() {
		displayId('divDialog', '');
		document.getElementById("spanDialogName").innerHTML = "Edit Admins";
		document.getElementById("frameDialog").src = "edit_admins.cfm";
		document.getElementById("frameDialog").style.height = "500px";
		document.getElementById("linkDialogClose").setAttribute("onclick", "closeEditAdmins()");
		showOverlay(true);
	}
	
	function closeEditAdmins() {
		document.getElementById("frameDialog").src ="";
		displayId('divDialog', 'none');
		showOverlay(false);
	}
	
	function doSave() {
		validateClubName();
		validateSlugName(true);
		if(!g_okayToSave) {
			return;
		}

		var errMsg = "";
		
		//get club name
		var club_name = "";
		if(g_newClubName != g_origClubName) {
			if(g_newClubName.length > 0 && confirm("Are you sure you want to change your club name to " + g_newClubName + "?")) {
				club_name = g_newClubName;
			} else {
				club_name = g_origClubName;
			}
		} else {
			club_name = g_origClubName;
		}
		
		//get slug name
		var slug_name = "";
		if(g_newSlugName != g_origSlugName) {
			if(g_newSlugName.length > 0 && confirm("Are you sure you want to change your URL Slug to " + g_newSlugName + "?")) {
				slug_name = g_newSlugName;
			} else {
				slug_name = g_origSlugName;
			}
		} else {
			slug_name = g_origSlugName;
		}
		
		//get personality
		var sel = document.getElementById("selPersonality");
		var personality_id = 0;
		if(sel.selectedIndex > 0) {
			personality_id = sel.options[sel.selectedIndex].value;
		} else {
			errMsg = appendErrMsg(errMsg, "You need to select a personality for your club.<br />If you aren't sure, then just choose 'Open' or 'Private'. You can change it later.");
		}
		
		//get platform
		var sel = document.getElementById("selPlatform");
		var platform = 0;
		if(sel.selectedIndex > 0) {
			platform = sel.options[sel.selectedIndex].value;
		} else {
			errMsg = appendErrMsg(errMsg, "You need to select a gaming platform for your club.");
		}
		
		//get allow join requests
		var join = 0;
		var join_yes = document.getElementById("radJoin_yes");
		if(join_yes.checked) {
			join = 1;
		}
		//get club description
		CKEDITOR.instances.textarea_1.updateElement();
		var club_desc = document.getElementById("textarea_1").value;
		club_desc = encodeSpaces(club_desc);
		if(club_desc.length > 0) {
			chunkClubDesc(club_desc);
		}
		
		if(errMsg.length > 0) {
			errMsg += "<br /><input type='button' onclick='showLoadingDiv(false, \"\")' value='Close' />";
			showLoadingDiv(true, errMsg);
		} else {
			var instance = new admin_proxy();
			instance.setCallbackHandler(doSave_callback);
			instance.save_admin_club_profile_data(club_name, slug_name, personality_id, join, platform);
		}
	}
	
	function doSave_callback(result) {
		var iserror = false;
		var errMsg = "";
		
		if(result.length > 0) {
			if(result == "good") {
				if(g_chunks.length > 0) {
					saveClubDesc("good");
				}
				
			} else if(result == "clubExists") {
				errMsg = "The Club Name you requested is already in use, please choose a different name.";
			} else if(result == "invalidClubError") {
				errMsg = "Club Names can only contain letters, numbers, spaces, periods, and underscores.";
			} else if(result == "invalidSlugError") {
				errMsg = "URL slugs can only contain letters, numbers, spaces, periods, and underscores.";
			} else if(result == "slugExists") {
				errMsg = "The URL slug you requested is already in use, please choose a different one.";
			} else if(result == "error") {
				errMsg = "There was an error trying to save your club data: E04";
			} else {
				errMsg = "There was an error trying to save your club data: E05";
			}
			
			if(errMsg.length > 0) {
				errMsg += "<br /><br /><input type='button' value='Close' onclick='init();' />";
				showLoadingDiv(true, errMsg);
			}
		}
	}
	
	function saveClubDesc(result) {
		if(result.length > 0) {
			if(result == "good") {
				if(g_chunks.length > 0) {
					// we know to keep going if there are still items left in the array
					g_chunkIdx++;
					var strToSave = g_chunks[0]; // extract the first item in array
					g_chunks.shift(); // now remove that first item from array
					showLoadingDiv(true, "Saving <br />" + getProgressBar(g_totalChunks, g_chunks.length)); // show the progress bar
					var instance = new admin_proxy();
					instance.setCallbackHandler(saveClubDesc); // callback to itself
					instance.save_admin_club_desc(strToSave, g_chunkIdx);
				} else {
					// we are done
					g_chunkIdx = -1;
					showLoadingDiv(false, "");
					init();
				}
			} else {
				var errMsg = "The was an error trying to save your club data: E03" + dlgCloseBtn;
				showLoadingDiv(true, errMsg);
			}
		} else {
			var errMsg = "The was an error trying to save your club data: E02" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		}
	}
	
	function chunkClubDesc(str) {
		g_chunks = [];
		if(str.length > 0) {
		
		
		
			var timesToLoop = Math.ceil(str.length/g_chunkSize);
			var start = 0;
			var go = 0;
			for(var i=0; i<timesToLoop; i++) {
				go = g_chunkSize; // the number of chars we want to push always starts with 250 chars
				var tempStringToPush = str.substr(start, go); // get the string we want to try to push
				while(tempStringToPush.charAt(tempStringToPush.length-1) == " ") { // if the last char is a space, get the next non space char
					go++;
					tempStringToPush = str.substr(start, go); // get new string to push after the space character
				}
				
				g_chunks.push(tempStringToPush); // push the string into array
				start = start + go; // set start to start + go so we start where we left off
			}
			
			g_totalChunks = g_chunks.length;
			
		} else {
			return;
		}
	}
	
	function loadCK() {
		if(!g_CKloaded) {
			CKEDITOR.replace( 'textarea_1', {
				width: 700,
				height: 400
			});
			g_CKloaded = true;
		}
	}
	
	function appendErrMsg(errMsg, str) {
		if(errMsg.length > 0) {
			errMsg += "<br />";
		}
		
		return(errMsg += str);
	}
	
	function doDelete_confirm() {
		var errMsg  = "You can never un-delete this club. This is permanent.<br />Are you sure you want to delete this club and all of the data?";
			errMsg += "<br /><br /><input type='button' value='Delete Club' onclick='doDelete();' />&nbsp;&nbsp;";
			errMsg += "<input type='button' value='No' onclick='showLoadingDiv(false, \"\");' />";
		showLoadingDiv(true, errMsg);
	}
	
	function doDelete() {
		var instance = new admin_proxy();
		instance.setCallbackHandler(doDelete_callback);
		instance.delete_club();
	}
	
	function doDelete_callback(result) {
		if(result == "error") {
			showLoadingDiv(true, "There was a problem deleting your club and all of the data. Please contact us immediately.");
		} else {
			window.location.href = "logout.cfm"
		}
	}
</script>
</head>
<body onload="init();">
<cfinclude template="include/navigation.cfm">
<cfinclude template="include/dialogs.cfm">


<div align="center" style="width:100%;font-size:16pt;">
	Club Profile
</div>
<br />

<div style="width:100%;" align="center">


<table id="tblClubForm">
	<tr id="row_clubName">
		<td align="right">
			Club Name:
		</td>
		<td align="center">
			<input type="text" id="txtClubName" name="txtClubName" onchange="validateClubName();" maxlength="35" />
			<img src="imgs/green-check.png" id="imgNameGood" style="visibility:hidden;" />
			<img src="imgs/red-x.png" id="imgNameBad" style="display:none;visibility:hidden;" title="Club Names have to be unique and cannot contain special characters." />
		</td>
	</tr>
	
	<tr id="row_clubSlug">
		<td align="right" colspan="2" align="right">
			<table>
				<tr>
					<td align="right">
						racingclubmanager.com/
					</td>
					<td valign="middle">
						<input type="text" id="txtSlugName" name="txtSlugName" onchange="validateSlugName(false);" maxlength="50" />
						<img src="imgs/green-check.png" id="imgSlugGood" style="visibility:hidden;" />
						<img src="imgs/red-x.png" id="imgSlugBad" style="display:none;visibility:hidden;" title="URL Slugs have to be unique and cannot contain special characters." />
					</td>
				</tr>
			</table>
		</td>
	</tr>
	
	<tr id="row_personality">
		<td align="right">
			Personality:
		</td>
		<td align="center">
			<select id="selPersonality" name="selPersonality">
				<option value="-1">-- Choose a Personality --</option>
			</select>
			<!--<img src="imgs/green-check.png" style="visibility:hidden;" />-->
			<img src="imgs/info_button.png" id="info_personality" title="If you're not sure what the Club's personality should be, then just select Open or Private and you can decide later." />
		</td>
	</tr>
	
	<tr id="row_personality">
		<td align="right">
			Platform:
		</td>
		<td align="center">
			<select name="selPlatform" id="selPlatform">
					<option value="">Select One...</option>
					<option value="PC">PC</option>
					<option value="Playstation 4">Playstation 4</option>
					<option value="Playstation 3">Playstation 3</option>
					<option value="XBOX One">XBOX One</option>
					<option value="XBOX 360">XBOX 360</option>
				</select>
		</td>
	</tr>
	
	<tr id="row_join">
		<td align="right">
			Allow Join Requests?
		</td>
		<td align="center">
			<input type="radio" name="radJoin" id="radJoin_yes" checked /> Yes
			&nbsp;&nbsp;
			<input type="radio" name="radJoin" id="radJoin_no" /> No
		</td>
	</tr>
	
	<tr id="row_admins" style="background-color: #ccc;">
		<td align="right">
			Admins:
		</td>
		<td align="center">
			<a href="javascript:editAdmins();">Add/Edit Admins</a>
		</td>
	</tr>
</table>
<div align="center" style="width:700px;">
	<br />
	Below, you can enter a description or welcome message for your club.<br />
	You may want to include where your members are from, when you usually race, and what type of events your club likes to run.

	<br />
	<textarea id="textarea_1" name="textarea_1"></textarea>
	<br />
	
	<input type="button" id="btnSave" value="Save" onclick="doSave();" />
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<input type="button" id="btnDelete" value="  Delete Club  " onclick="doDelete_confirm();" />
</div>

</div>
</body>
</html>