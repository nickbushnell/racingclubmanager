<cfajaxproxy cfc="admin_edit_teams_server" jsclassname="admin_proxy" />
<cfif Not IsDefined("Session.club_id")>
	<cfset session.goto = "admin_races_results.cfm">
	<cflocation url="login.cfm?adminDlg=1" addtoken="no">
</cfif>

<cfif Not IsDefined("Session.permission")>
	<cflocation url="logout.cfm" addtoken="no">
<cfelseif Session.permission GT 1>
	<cflocation url="logout.cfm?message=permission" addtoken="no">
</cfif>

<cfif IsDefined("URL.series")>
	<cfset g_seriesId = "#URL.series#">
<cfelse>
	<cfset g_seriesId = "-1">
</cfif>

<html>
<head>
<title>Racing Club Manager - Edit Teams</title>
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
		font-size: 10pt;
	}
	
	input {
		font-family: 'Monda', sans-serif;
		font-size: 10pt;
	}
	
	td {
		font-size: 10pt;
	}
	
	a {
		text-decoration: none;
	}

	
	#divLoading {
		position: absolute;
		top: 200px;
	}
</style>
<cfoutput>
<script type="text/javascript">
	var g_seriesId = parseInt("#g_seriesId#");
</script>
</cfoutput>
<script language='javascript' src='common.js'></script>
<script type="text/javascript">
	if(!String.prototype.trim) {
		String.prototype.trim=function(){return this.replace(/(?:(?:^|\n)\s+|\s+(?:$|\n))/g,'').replace(/\s+/g,' ');};
	}
	
	var g_teamId = -1;
	var g_racer_id = 0;
	var g_racer_name = "";
	var g_arrMembers = [];
	var g_strType = "team";
	
	function bodyOnLoad() {
		// check for 
		if(window.location.href.indexOf("?") > -1) {
			var qs = window.location.href.split("?")[1];
			if(qs.indexOf("type=") > -1) {
				if(qs.indexOf("type=t") > -1) {
					// make dialog say teams
					// it does by defualt, so don't need to do anything for now
					document.getElementById("cellTeamsLabel").innerHTML = "Teams:";
					document.getElementById("selTeam").options[0].innerHTML = "-- Select Team --";
					document.getElementById("cellTeamMembersText").innerHTML = "Team Members";
				} else if(qs.indexOf("type=mc") > -1) {
					// make dlg say multi-class
					g_strType = "class";
					document.getElementById("cellTeamsLabel").innerHTML = "Classes:";
					document.getElementById("selTeam").options[0].innerHTML = "-- Select Class --";
					document.getElementById("cellTeamMembersText").innerHTML = "Class Members";
				}
			}
		}
		
		init();
	}
	
	function init() {
		showLoadingDiv(true, "Loading...");
		document.getElementById("divLoading").style.top = "50px";
		document.getElementById("overlay").style.backgroundColor = "white";
		

		clearTeamName();
		clearMembersTable();
		showTeamRows(false);
		
		getTeams();
	}
	
	function getTeams() {
		// clear teams except select and add new
		document.getElementById("selTeam").options.length = 2;
		
		var instance = new admin_proxy();
		instance.setCallbackHandler(getTeams_callback);
		instance.get_teams(g_seriesId);
	}
	
	function getTeams_callback(result) {
		var rows = getRows(result);
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E01" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			document.getElementById("divLoading").style.top = "50px";
			document.getElementById("overlay").style.backgroundColor = "white";
		} else {
			var sel = document.getElementById("selTeam");
			
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				
				var team_id = parseInt(fields[0]);
				var team_name = fields[1];
				
				var opt = document.createElement("option");
				opt.value = team_id;
				sel.appendChild(opt);
				sel.options[sel.options.length-1].innerHTML = team_name;
				if(g_teamId > 0 && team_id == g_teamId) {
					sel.options[sel.options.length-1].selected = true;
				}
			}
			
			showLoadingDiv(false, "");
			
			if(g_teamId > 0) {
				loadTeam(g_teamId);
			}
		}
	}
	
	function loadTeam(team_id) {
		if(team_id == -1) {
			var sel = document.getElementById("selTeam");
			g_teamId = parseInt(sel.options[sel.selectedIndex].value);
		}
		
		g_arrMembers = []; // clear members array
		document.getElementById("cellTeamNameStatus").innerHTML = "&nbsp;"; // reset teamname status
		document.getElementById("cellTeamAbbrStatus").innerHTML = "&nbsp;";
		
		if(g_teamId == -1) {
			showTeamRows(false);
			var errMsg = "Please select a " + g_strType + " to edit, or add a new team." + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			document.getElementById("divLoading").style.top = "50px";
			document.getElementById("overlay").style.backgroundColor = "white";
			return;
		} else if(g_teamId == 0) {
			checkNumberTeams();
		} else if(g_teamId > 0) {
			clearMembersTable();
			
			var instance = new admin_proxy();
			instance.setCallbackHandler(loadTeam_callback);
			instance.load_team(g_seriesId, g_teamId);
		}
	}
	
	function loadTeam_callback(result) {
		var rows = getRows(result);
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E03" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			document.getElementById("divLoading").style.top = "50px";
			document.getElementById("overlay").style.backgroundColor = "white";
		} else {
		
			showTeamRows(true);
			
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				
				var team_id = parseInt(fields[0]);
				var team_name = fields[1];
				var team_abbr = fields[2];
				var racer_id = parseInt(fields[3]);
				var racer_name = fields[4];
				
				if(i == 0) {
					// for first record only, we want to use the team name and team abbreviation
					document.getElementById("txtTeamName").value = team_name;
					document.getElementById("txtTeamAbbr").value = team_abbr;
				}
				
				if(racer_id > 0) {
					g_arrMembers.push([racer_id, racer_name]); // add member to array
					addRacerToTbl(racer_id, racer_name, i);// false = do not fire AJAX save
					
				}
			}
			
			getAvailMembers();
		}
	}
	
	function addRacerToTbl(racer_id, racer_name, i) {
		var tbl = document.getElementById("tblCurrMembers");
		
		var row = tbl.insertRow(-1);
		row.style.backgroundColor = getRowColor(i);
		
		var cell = row.insertCell(-1);
		cell.innerHTML = racer_name;
		
		cell = row.insertCell(-1);
		cell.align = "center";
		cell.innerHTML = "<img src='imgs/delete-icon.png' onclick='removeRacerFromTeam_confirm(" + racer_id + ");' title='Remove this racer from this team.' style='cursor:pointer;' />";
	}
	
	function addRacerToTeam() {
		var sel = document.getElementById("selRacer");
		g_racer_id = sel.options[sel.selectedIndex].value;
		g_racer_name = sel.options[sel.selectedIndex].innerHTML;
		
		// save to team
		var instance = new admin_proxy();
		instance.setCallbackHandler(addRacerToTeam_callback);
		instance.add_racer_to_team(g_seriesId, g_teamId, g_racer_id);
	}
	
	function addRacerToTeam_callback(result) {
		var rows = getRows(result);
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E03" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			document.getElementById("divLoading").style.top = "50px";
			document.getElementById("overlay").style.backgroundColor = "white";
		} else {
			
			var sel = document.getElementById("selRacer");
			
			// add racer to member array
			g_arrMembers.push([g_racer_id, g_racer_name]);
			
			// add racer to tbl
			addRacerToTbl(g_racer_id, g_racer_name, g_arrMembers.length-1);
		
			// remove racer from sel
			sel.remove(sel.selectedIndex);
		}
		
		// reset these global vars no matter what
		g_racer_id = 0;
		g_racer_name = "";
	}
	
	function removeRacerFromTeam_confirm(racer_id) {
		// do confirm
		var errMsg  = "Are you sure you want to remove this racer from this?";
			errMsg += "<br /><br /><input type='button' value='Yes' onclick='removeRacerFromTeam(" + racer_id + ");' />&nbsp;&nbsp;";
			errMsg += "<input type='button' value='No' onclick='showLoadingDiv(false, \"\");' />";
		showLoadingDiv(true, errMsg);
		document.getElementById("divLoading").style.top = "75px";
		document.getElementById("overlay").style.backgroundColor = "white";
		window.scrollTo(0,0);
	}
	function removeRacerFromTeam(racer_id) {
		g_racer_id = racer_id;
		var instance = new admin_proxy();
		instance.setCallbackHandler(removeRacerFromTeam_callback);
		instance.remove_racer_from_team(g_seriesId, g_teamId, racer_id);
	}
	
	function removeRacerFromTeam_callback(result) {
		var rows = getRows(result);
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E01" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			document.getElementById("divLoading").style.top = "50px";
			document.getElementById("overlay").style.backgroundColor = "white";
		} else {
			var racer_id = g_racer_id;
			var racer_name = "";
			g_racer_id = 0;
			// get racer name and remove from array of members
			for(var i=0; i<g_arrMembers.length; i++) {
				if(g_arrMembers[i][0] == racer_id){
					racer_name = g_arrMembers[i][1];
					g_arrMembers.splice(i,1); // remove this member from the members array
				}
			}
			
			// remove member from table
			var tbl = document.getElementById("tblCurrMembers");
			for(var i=0; i<tbl.rows.length; i++) {
				if(tbl.rows[i].cells[0].innerHTML == racer_name) {
					tbl.deleteRow(i);
				}
			}
			
			// add member back to dropdown
			var sel = document.getElementById("selRacer");
			var opt = document.createElement("option");
			opt.value = racer_id;
			sel.appendChild(opt);
			sel.options[sel.options.length-1].innerHTML = racer_name;
			
			// hide the confirm message
			showLoadingDiv(false, "");
		}
	}
	
	function checkNumberTeams() {
		var instance = new admin_proxy();
		instance.setCallbackHandler(checkNumberTeams_callback);
		instance.check_number_teams(g_seriesId);
	}
	
	function checkNumberTeams_callback(result) {
		var rows = getRows(result);
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E03" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			document.getElementById("divLoading").style.top = "50px";
			document.getElementById("overlay").style.backgroundColor = "white";
		} else {
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				
				if(fields[0] == "good") {
					//if(parseInt(fields[1]) >= 24) {
					//	var errMsg = "Currently, you can only create 24 " + g_strType + " per series. E-mail me and I'll change it." + dlgCloseBtn;
					//	showLoadingDiv(true, errMsg);
					//	document.getElementById("divLoading").style.top = "50px";
					//	document.getElementById("overlay").style.backgroundColor = "white";
					//} else {
						// # teams less than 24, clear all fields to prep for adding new team, then get available members
						showTeamRows(true);
						clearTeamName();
						clearMembersTable();
						// hide racers dropdown and members table
						document.getElementById("rowAvailMembers").style.display = "none";
						document.getElementById("rowCurrMembers").style.display = "none";
					//}
				} else {
					var errMsg = "This page encountered an error: E03.5" + dlgCloseBtn;
					showLoadingDiv(true, errMsg);
					document.getElementById("divLoading").style.top = "50px";
					document.getElementById("overlay").style.backgroundColor = "white";
				}
			}
		}
	}
	
	function getAvailMembers() {
		clearMembersDropdown();
		
		var instance = new admin_proxy();
		instance.setCallbackHandler(getAvailMembers_callback);
		instance.get_avail_members(g_seriesId);
	}
	
	function getAvailMembers_callback(result) {
		var rows = getRows(result);
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E04" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			document.getElementById("divLoading").style.top = "50px";
			document.getElementById("overlay").style.backgroundColor = "white";
		} else {
			var sel = document.getElementById("selRacer");
			
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				
				var racer_id = parseInt(fields[0]);
				var racer_name = decodeString(fields[1]);
				
				var opt = document.createElement("option");
				opt.value = racer_id;
				sel.appendChild(opt);
				sel.options[sel.options.length-1].innerHTML = racer_name;
			}
		}
	}
	
	function showTeamRows(bln) {
		var showHide = "none";
		if(bln) {
			showHide = "";
		}
		
		document.getElementById("rowTeamName").style.display = showHide;
		document.getElementById("rowTeamAbbr").style.display = showHide;
		document.getElementById("rowSaveTeam").style.display = showHide;
		document.getElementById("rowAvailMembers").style.display = showHide;
		document.getElementById("rowCurrMembers").style.display = showHide;
	}
	
	function clearTeamName() {
		document.getElementById("txtTeamName").value = "";
		document.getElementById("txtTeamAbbr").value = "";
	}
	
	function clearMembersDropdown() {
		document.getElementById("selRacer").options.length = 1;
	}
	
	function clearMembersTable() {
		var tbl = document.getElementById("tblCurrMembers");
		// remove rows from table before filling
		for(var i = tbl.rows.length - 1; i > 0; i--) {
			tbl.deleteRow(i);
		}
	}
	
	function deleteTeam_confirm() {
		// do confirm
		var errMsg  = "Are you sure you want to delete this?";
			errMsg += "<br /><br /><input type='button' value='Yes' onclick='deleteTeam();' />&nbsp;&nbsp;";
			errMsg += "<input type='button' value='No' onclick='showLoadingDiv(false, \"\");' />";
		showLoadingDiv(true, errMsg);
		document.getElementById("divLoading").style.top = "75px";
		document.getElementById("overlay").style.backgroundColor = "white";
	}
	
	function deleteTeam() {
		var instance = new admin_proxy();
		instance.setCallbackHandler(deleteTeam_callback);
		instance.delete_team(g_seriesId, g_teamId);
	}
	
	function deleteTeam_callback(result) {
		var rows = getRows(result);
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E05" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			document.getElementById("divLoading").style.top = "50px";
			document.getElementById("overlay").style.backgroundColor = "white";
		} else {
			// successfully deleted team, reload teams
			showLoadingDiv(false, "");
			g_teamId = -1;
			init();
		}
	}
	
	function saveTeam() {
		var txt = document.getElementById("txtTeamName");
		var team_name = txt.value.trim();
		
		txt = document.getElementById("txtTeamAbbr");
		var team_abbr = txt.value.trim();
		
		if(checkTeamName() && checkTeamAbbr()) {
			
			var errMsg = "Saving..."
			showLoadingDiv(true, errMsg);
			document.getElementById("divLoading").style.top = "50px";
			document.getElementById("overlay").style.backgroundColor = "white";
			
			var instance = new admin_proxy();
			instance.setCallbackHandler(saveTeam_callback);
			instance.add_save_team(g_seriesId, g_teamId, team_name, team_abbr);
		}
	}
	
	function saveTeam_callback(result) {
		var rows = getRows(result);
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E06" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			document.getElementById("divLoading").style.top = "50px";
			document.getElementById("overlay").style.backgroundColor = "white";
		} else if(rows[0] == "invalidError") {
			var errMsg = "Names and abbreviations can only contain letters, numbers, spaces, periods, and underscores." + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			document.getElementById("divLoading").style.top = "50px";
			document.getElementById("overlay").style.backgroundColor = "white";
		} else if(rows[0] == "lenError") {
			var errMsg = "You must enter a Name before saving." + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			document.getElementById("divLoading").style.top = "50px";
			document.getElementById("overlay").style.backgroundColor = "white";
		} else {
			// successfully saved team name
			// change innerHTML of option in dropdown
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				
				if(fields[0] == "good") {
					if(fields.length == 2) { // this only happens when we add a new team
						g_teamId = parseInt(fields[1]);
						getTeams();
					} else {
						var sel = document.getElementById("selTeam");
						for(var k=0; k<sel.options.length; k++) {
							if(parseInt(sel.options[k].value) == g_teamId) {
								var txt = document.getElementById("txtTeamName");
								var team_name = txt.value.trim();
								sel.options[k].innerHTML = team_name;
								break;
							}
						}
						showLoadingDiv(false, "");
					}
				} else {
					var errMsg = "This page encountered an error: E07" + dlgCloseBtn;
					showLoadingDiv(true, errMsg);
					document.getElementById("divLoading").style.top = "50px";
					document.getElementById("overlay").style.backgroundColor = "white";
				}
			}
			
		}
	}
		

	function checkTeamName() {
		var txt = document.getElementById("txtTeamName");
		var team_name = txt.value.trim();

		if(team_name.length <= 0) {
			var errMsg = "You must enter a Name before saving." + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			document.getElementById("divLoading").style.top = "50px";
			document.getElementById("overlay").style.backgroundColor = "white";
			
			document.getElementById("cellTeamNameStatus").innerHTML = "<img src='imgs/red-x.png' title='Names can only contain letters, numbers, spaces, periods, and underscores.' />";
			return false;
		}
		
		if(onlyNormalChars(team_name)) {
			document.getElementById("cellTeamNameStatus").innerHTML = "<img src='imgs/green-check.png' />";
			return true;
		} else {
			var errMsg = "Names can only contain letters, numbers, spaces, periods, and underscores." + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			document.getElementById("divLoading").style.top = "50px";
			document.getElementById("overlay").style.backgroundColor = "white";
			
			document.getElementById("cellTeamNameStatus").innerHTML = "<img src='imgs/red-x.png' title='Names can only contain letters, numbers, spaces, periods, and underscores.' />";
			return false;
		}
	}
	
	function checkTeamAbbr() {
		var txt = document.getElementById("txtTeamAbbr");
		var team_abbr = txt.value.trim();
		
		if(team_abbr.length > 0) {
			if(onlyNormalChars(team_abbr)) {
				document.getElementById("cellTeamAbbrStatus").innerHTML = "<img src='imgs/green-check.png' />";
				return true;
			} else {
				var errMsg = "Abbreviations can only contain letters, numbers, spaces, periods, and underscores." + dlgCloseBtn;
				showLoadingDiv(true, errMsg);
				document.getElementById("divLoading").style.top = "50px";
				document.getElementById("overlay").style.backgroundColor = "white";
				
				document.getElementById("cellTeamAbbrStatus").innerHTML = "<img src='imgs/red-x.png' title='Abbreviations can only contain letters, numbers, spaces, periods, and underscores.' />";
				return false;
			}
		} else {
			return true;
		}
	}
	
	

</script>
</head>
<body onload="bodyOnLoad()">
<cfinclude template="include/dialogs.cfm">

<br /><br />
<div style="width:100%;" align="center" id="pageContainer">
	
	
	<table>
		<tr>
			<td id="cellTeamsLabel">
				:
			</td>
			<td colspan="2">
				<select name="selTeam" id="selTeam" onchange="loadTeam(-1);">
					<option value="-1">-- Select --</option>
					<option value="0">-- Add New --</option>
				</select>
			</td>
		</tr>
		<tr id="rowTeamName" style="display:none;">
			<td>
				Name:
			</td>
			<td>
				<input type="text" name="txtTeamName" id="txtTeamName" onchange="checkTeamName();" />
			</td>
			<td id="cellTeamNameStatus">
			&nbsp;
			</td>
		</tr>
		<tr id="rowTeamAbbr" style="display:none;">
			<td>
				Abbreviation:
			</td>
			<td>
				<input type="text" name="txtTeamAbbr" id="txtTeamAbbr" onchange="checkTeamAbbr();" maxlength="4" />
				<img src="imgs/info_button.png" id="info_dateTime" style='cursor:pointer;' title="We use an abbreviation of the team name when rendering results." />
			</td>
			<td id="cellTeamAbbrStatus">
			&nbsp;
			</td>
		</tr>
		<tr id="rowSaveTeam" style="display:none;">
			<td colspan="3" align="center">
				<!-- Save Team Name -->
				<input type="button" value="Save" onclick="saveTeam();" title="" />
				<!-- Delete Team -->
				<input type="button" value="Delete" onclick="deleteTeam_confirm();" title="" />
				<div style="font-size:15px;">&nbsp;</div>
			</td>
		</tr>
		<tr id="rowAvailMembers" style="display:none;">
			<td>
				Racers:
			</td>
			<td>
				<select name="selRacer" id="selRacer">
					<option value="-1">-- Select Racer --</option>
				</select>
			</td>
			<td>
				<a href="javascript:addRacerToTeam();">Add</a>&nbsp;
				<img src="imgs/info_button.png" id="info_dateTime" style='cursor:pointer;' title="Clicking 'Add' will automatically save this team's line-up." />
			</td>
		</tr>
		<tr id="rowCurrMembers" style="display:none;">
			<td colspan="3">
				
				<br />
				
				<table id="tblCurrMembers" width="100%" cellspacing="2" cellpadding="3">
					<tr class="dataHeaderBG">
						<td colspan="2" class="dataHeaderTxt" align="center" id="cellTeamMembersText">
							Members
						</td>
					</tr>
				</table>
				
			</td>
		</tr>
	</table>
	
	
</div>


	
</body>
</html>