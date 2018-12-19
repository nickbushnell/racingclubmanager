<cfajaxproxy cfc="admin_club_members_server" jsclassname="admin_proxy" />
<cfif Not IsDefined("Session.club_id")>
	<cfset session.goto = "admin_club_members.cfm">
	<cflocation url="login.cfm" addtoken="no">
</cfif>

<cfif Not IsDefined("Session.permission")>
	<cflocation url="logout.cfm" addtoken="no">
<cfelseif Session.permission GT 1>
	<cflocation url="logout.cfm?message=permission" addtoken="no">
</cfif>

<cfif IsDefined("URL.dlg")>
	<cfset g_dlg = "#URL.dlg#">
<cfelse>
	<cfset g_dlg = "0">
</cfif>


<html>
<head>
<link href='http://fonts.googleapis.com/css?family=Monda:400' rel='stylesheet' type='text/css'>
<title>Racing Club Manager | Admin Club Members</title>
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
	
	.infoBtn {
		cursor:pointer;
	}
	
	<cfinclude template="include/nav_list.cfm" />
</style>
<script type="text/javascript" src="include/jquery-1.11.1.min.js"></script>
<script language='javascript' src='common.js'></script>
<script>
	
	var g_sortBy = "nameASC";
	var arr = [];
	
	$(window).resize(function () { resizeOverlay() });
	
	function init() {
		arr = [];
		showLoadingDiv(true, "Loading...");
		<cfif g_dlg EQ "1">
			document.getElementById("divLoading").style.top = "100px";
			document.getElementById("overlay").style.backgroundColor = "white";
		</cfif>
		getRacers(g_sortBy);
	}

	function getRacers(strSortBy) {
		var instance = new admin_proxy();
		instance.setCallbackHandler(getRacers_callback);
		instance.get_racers(strSortBy);
	}
	
	function getRacers_callback(result) {
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E01" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			<cfif g_dlg EQ "1">
				document.getElementById("divLoading").style.top = "100px";
				document.getElementById("overlay").style.backgroundColor = "white";
			</cfif>
			window.scroll(0,0);
		} else {
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				arr.push(fields);
			}
			
			fillRacers(arr);
		}
		
		showLoadingDiv(false, null);
	}
	
	function fillRacers(arr) {
		var tbl = document.getElementById("tblRacers");
		
		// remove rows from table before filling
		for(var i = tbl.rows.length - 1; i > 1; i--) {
			tbl.deleteRow(i);
		}
		
		if(arr.length > 0) {
			for(var i=0; i<arr.length; i++) {
				
				var fields = arr[i];
				var racer_id = fields[0];
				var racer_name = decodeString(fields[1]);
				var active = parseInt(fields[2]);
				var last_race = fields[3];
				if(last_race == "1900-01-01 00:00:00.0") {
					last_race = "";
				} else {
					last_race = displayDate(last_race);
				}
				
				var row = tbl.insertRow(-1);
				row.style.backgroundColor = getRowColor(i);
				
				var cell = row.insertCell(-1);
				cell.innerHTML = "<a href='javascript:editMember_dlg(" + racer_id + ", \"Edit\");'>" + racer_name + "</a>";
				cell.setAttribute("class","cellData");
				
				cell = row.insertCell(-1);
				cell.align = "center";
				cell.innerHTML = last_race;
				cell.setAttribute("class","cellData");
				

				var strActions = "";
				
				if(active) {
					strActions = "<a href='javascript:setRacerActive_confirm(" + racer_id + ", 0)'>Deactivate</a>";
				} else {
					strActions = "<a href='javascript:setRacerActive(" + racer_id + ", 1)'>Activate</a>";
				}
				
				if(last_race == "") {
					strActions += "<br /><a href='javascript:removeRacer_confirm(" + racer_id + ")'>Remove</a>";
				}
				
				cell = row.insertCell(-1);
				cell.align = "center";
				cell.innerHTML = strActions;
				cell.setAttribute("class","cellData");

			}
		} else {
			var row = tbl.insertRow(-1);
			var cell = row.insertCell(-1);
			cell.align = "center";
			cell.colSpan = "3";
			cell.innerHTML = "There are no racers set-up for this club.";
		}
	}
	
	function sortBy(strSortBy) {
		if(strSortBy == "race") {
			if(g_sortBy == "lastRaceDESC") {
				g_sortBy = "lastRaceASC";
			} else if(g_sortBy == "lastRaceASC") {
				g_sortBy = "lastRaceDESC";
			} else {
				g_sortBy = "lastRaceDESC";
			}
		} else if(strSortBy == "name") {
			if(g_sortBy == "nameDESC") {
				g_sortBy = "nameASC";
			} else if(g_sortBy == "nameASC") {
				g_sortBy = "nameDESC";
			} else {
				g_sortBy = "nameASC";
			}
		}
		
		init();
	}
	
	function editMember_dlg(racerId, strAddEdit) {
		var racer_name = lookupRacerName(racerId);
		
		var errMsg  = "<b>" + strAddEdit + " Member</b><br /><br />";
			errMsg += "<input type='text' name='txtRacerName' id='txtRacerName' maxlength='50' value='" + racer_name + "' /><br /><br />";
			errMsg += "<input type='button' value='Save' onclick='saveMember(" + racerId + ");' />&nbsp;&nbsp;";
			errMsg += "<input type='button' value='Cancel' onclick='showLoadingDiv(false,null);' />";
		showLoadingDiv(true, errMsg);
		<cfif g_dlg EQ "1">
			document.getElementById("divLoading").style.top = "100px";
			document.getElementById("overlay").style.backgroundColor = "white";
		</cfif>
		window.scroll(0,0);
	}
	
	function lookupRacerName(racerId) {
		var racer_name = "";
		
		for(var i=0; i<arr.length; i++) {
			if(arr[i][0] == racerId) {
				racer_name = decodeString(arr[i][1]);
			}
		}
		
		return racer_name;
	}
	
	function saveMember(racerId) {
		var racerName = document.getElementById("txtRacerName").value;
		
		var instance = new admin_proxy();
		instance.setCallbackHandler(saveMember_callback);
		instance.save_member(racerId, racerName);
	}
	
	function saveMember_callback(result) {
		if(result == "error") {
			var errMsg = "This page encountered an error: E02" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			<cfif g_dlg EQ "1">
				document.getElementById("divLoading").style.top = "100px";
				document.getElementById("overlay").style.backgroundColor = "white";
			</cfif>
			window.scroll(0,0);
		} else {
			init();
		}
	}
	
	function setRacerActive_confirm(racerId, active) {
		var errMsg  = "<b>Deactivate Member</b><br /><br />";
			errMsg += "Are you sure you want to deactivate this member?<br /><br />";
			errMsg += "<input type='button' value='Yes' onclick='setRacerActive(" + racerId + ", " + active + ");' />&nbsp;&nbsp;";
			errMsg += "<input type='button' value='Cancel' onclick='showLoadingDiv(false,null);' />";
		showLoadingDiv(true, errMsg);
		<cfif g_dlg EQ "1">
			document.getElementById("divLoading").style.top = "100px";
			document.getElementById("overlay").style.backgroundColor = "white";
		</cfif>
		window.scroll(0,0);
	}
	
	function setRacerActive(racerId, active) {
		
		var instance = new admin_proxy();
		instance.setCallbackHandler(setRacerActive_callback);
		instance.set_member_inactive(racerId, active);
	}
	
	function setRacerActive_callback(result) {
		if(result == "error") {
			var errMsg = "This page encountered an error: E03" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			<cfif g_dlg EQ "1">
				document.getElementById("divLoading").style.top = "100px";
				document.getElementById("overlay").style.backgroundColor = "white";
			</cfif>
			window.scroll(0,0);
		} else {
			init();
		}
	}
	
	function removeRacer_confirm(racerId) {
		var errMsg  = "<b>Remove Member</b><br /><br />";
			errMsg += "Are you sure you want to completely remove this member?<br /><br />";
			errMsg += "<input type='button' value='Yes' onclick='removeRacer(" + racerId + ");' />&nbsp;&nbsp;";
			errMsg += "<input type='button' value='Cancel' onclick='showLoadingDiv(false,null);' />";
		showLoadingDiv(true, errMsg);
		<cfif g_dlg EQ "1">
			document.getElementById("divLoading").style.top = "100px";
			document.getElementById("overlay").style.backgroundColor = "white";
		</cfif>
		window.scroll(0,0);
	}
	
	function removeRacer(racerId) {
		var instance = new admin_proxy();
		instance.setCallbackHandler(removeRacer_callback);
		instance.remove_member(racerId);
	}
	
	function removeRacer_callback(result) {
		if(result == "hasHistory") {
			var errMsg =  "Since this member has a racing history with the club, they have been deactivated instead of being removed.<br /><br />";
				errMsg += "<input type='button' value='Close' onclick='init();' />";
			showLoadingDiv(true, errMsg);
			<cfif g_dlg EQ "1">
				document.getElementById("divLoading").style.top = "100px";
				document.getElementById("overlay").style.backgroundColor = "white";
			</cfif>
			window.scroll(0,0);
		} else if(result == "success") {
			init();
		} else {
			var errMsg = "This page encountered an error: E04";
			    errMsg += "<input type='button' value='Close' onclick='init();' />";
			showLoadingDiv(true, errMsg);
			<cfif g_dlg EQ "1">
				document.getElementById("divLoading").style.top = "100px";
				document.getElementById("overlay").style.backgroundColor = "white";
			</cfif>
			window.scroll(0,0);
		}
	}

</script>

</head>
<body onload="init();">
<cfif g_dlg EQ "1">
	<!--- do nothing here --->
<cfelse>
	<cfinclude template="include/navigation.cfm">
	<div align="center" style="width:100%;font-size:16pt;">
		Manage Club Members
	</div>
</cfif>


<br />


<div style="width:100%;" align="center">
<cfinclude template="include/dialogs.cfm">

<cfif g_dlg EQ "1">
<table id="tblRacers" border="0" cellspacing="0" cellpadding="3" width="90%">
<cfelse>
<table id="tblRacers" border="0" cellspacing="0" cellpadding="3" width="50%">
</cfif>
	<tr>
		<td width="50%"></td>
		<td width="30%"></td>
		<td width="20%" align="center" style="background-color:#263248;">
			<a href="javascript:editMember_dlg(0, 'Add New');" style="color:#FF9800;text-decoration:underline;">Add New Member</a>
		</td>
	</tr>
	<tr class="dataHeaderBG">
		<td valign="middle" align="center" class="dataHeaderTxt">
			<a href="javascript:sortBy('name')" title="Click to sort by Name">Name</a>
		</td>
		<td valign="middle" align="center" class="dataHeaderTxt">
			<a href="javascript:sortBy('race')" title="Click to sort by Last Race">Last Race</a>
		</td>
		<td valign="middle" align="center" class="dataHeaderTxt">
			&nbsp;
		</td>
	</tr>
</table>
</div>


</body>
</html>