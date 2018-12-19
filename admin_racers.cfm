<cfajaxproxy cfc="admin_racers_server" jsclassname="admin_proxy" />

<cfif Not IsDefined("Session.club_id")>
	<cfset session.goto = "admin_racers.cfm">
	<cflocation url="login.cfm?adminDlg=1" addtoken="no">
</cfif>

<html>
<head>
<title>Racing Club Manager - Admin Racers</title>
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
	#divEditRacers {
		position: absolute;
		z-index: 500;
		top: 50px;
		width: 100%;
	}
</style>
<script language='javascript' src='common.js'></script>
<script type="text/javascript">
	
	var g_savedId = 0;
	var arrRacers = [];
	
	function init() {
		getAdminRacers();
	}
	
	function getAdminRacers() {
		document.getElementById("rowActive").style.display = "none";
		document.getElementById("btnSave").style.display = "none";
		document.getElementById("btnRemove").style.display = "none";
		
		var instance = new admin_proxy();
		instance.setCallbackHandler(fillRacers);
		instance.get_admin_racers();
	}
	
	function fillRacers(result) {
		// clear all options
		arrRacers = [];
		var sel = document.getElementById("selRacers");
		sel.options.length = 2;
		
		var optGroup_active;
		var optGroup_inactive;
		
		if(!document.getElementById("optGroup_active")) {
			optGroup_active = document.createElement("optgroup");
			optGroup_active.label = "Active";
			optGroup_active.id = "optGroup_active";
			sel.appendChild(optGroup_active);
		} else {
			optGroup_active = document.getElementById("optGroup_active");
		}
		
		if(!document.getElementById("optGroup_inactive")) {
			optGroup_inactive = document.createElement("optgroup");
			optGroup_inactive.label = "Inactive";
			optGroup_inactive.id = "optGroup_inactive";
			sel.appendChild(optGroup_inactive);
		} else {
			optGroup_inactive = document.getElementById("optGroup_inactive");
		}
		
		var addedIdx = -1;
		
		if(result.length > 0) {
			// parse ajax result
			result = result + "<row>";
			var rows = result.split("<row>");
			rows.pop();
			for(var i=0; i<rows.length; i++) {
				
				var fields = rows[i].split("|");
				
				if(fields[0] == "error") {
					alert("There was an Ajax Result Error.");
				} else {
					// fill select with racers
					arrRacers.push(fields);
					
					var opt = document.createElement("option");
					opt.value = fields[0];
					if(fields[2].toString() == "1") { // active
						optGroup_active.appendChild(opt);
						sel.options[sel.options.length-1].innerHTML = fields[1];
					} else {
						optGroup_inactive.appendChild(opt);
						sel.options[sel.options.length-1].innerHTML = fields[1];
					}
					
					
					if(g_savedId > 0 && g_savedId == fields[0]) { // if a user was saved, we want to reselect that user
						addedIdx = sel.options.length-1; // remember the selectedIndex of the saved racer
						g_savedId = 0; // reset the saved racer_id
					}
				}
			}
			
			
			
			if(addedIdx >= 0) { // if we have a selectIndex, use it
				sel.selectedIndex = addedIdx; // select the saved racer
				addedIdx = -1; // reset the index
				selRacer(document.getElementById("selRacers")); // get the racer data
			}
		}
	}
	
	function selRacer(sel) {
		if(sel.selectedIndex >= 1) {
			// always show divRacer
			document.getElementById("divRacer").style.display = "";
			if(sel.selectedIndex > 1) { // if > 1 then we are selecting existing racer
				// show remove button
				document.getElementById("btnRemove").style.display = "";
				// show save button
				document.getElementById("btnSave").style.display = "";
				// show gamertag field
				document.getElementById("txtRacer").style.display = "";
				// show active box
				document.getElementById("rowActive").style.display = "";
				// get racer data
				var racer_id = sel.options[sel.selectedIndex].value;
				getRacerData(racer_id);
			} else { // Add New
				// clear the gamertag field
				document.getElementById("txtRacer").value = "";
				// hide remove button
				document.getElementById("btnRemove").style.display = "none";
				// hide active box
				document.getElementById("rowActive").style.display = "none";
				// show save button
				document.getElementById("btnSave").style.display = "";
				// show gamertag field
				document.getElementById("txtRacer").style.display = "";
			}
		} else if(sel.selectedIndex == 0) { // --Select Racer--
			document.getElementById("divRacer").style.display = "none";
		}
	}
	
	function getRacerData() {
		var sel = document.getElementById("selRacers");
		var racer_id = sel.options[sel.selectedIndex].value;
		
		if(parseInt(racer_id) > 0) {
			
			// get the record from arrRacers
			var racerIdx = sel.selectedIndex - 2;
			
			// set racer name field
			document.getElementById("txtRacer").value = arrRacers[racerIdx][1];
			
			// if active set active checkbox
			if(arrRacers[racerIdx][2].toString() == "1") {
				document.getElementById("chkActive").checked = true;
			} else {
			// if inactive uncheck active checkbox
				document.getElementById("chkActive").checked = false;
			}
			
			
			if(arrRacers[racerIdx][3].toString() == "0") {
				document.getElementById("btnRemove").style.display = "";
			} else { // if more than 0 races, hide delete button
				//document.getElementById("btnRemove").style.display = "none";
			}
		}
	}
	
	function saveRacer() {
		var sel = document.getElementById("selRacers");
		var racer_id = sel.options[sel.selectedIndex].value;
		var txtRacer = document.getElementById("txtRacer").value;
		var active = (document.getElementById("chkActive").checked ? "true" : "false");
		
		if(txtRacer.length > 0 && parseInt(racer_id) >= 0) {
			var instance = new admin_proxy();
			instance.setCallbackHandler(saveRacer_callback);
			instance.save_racer(racer_id,txtRacer,active);
		}
	}
	
	function saveRacer_callback(result) {
		var msg = "";
		// parse ajax result
		result = result + "<row>";
		var rows = result.split("<row>");
		rows.pop();
		for(var i=0; i<rows.length; i++) {
			
			var fields = rows[i].split("|");
			msg = fields[0];
		}
		
		if(msg == "error") {
			alert("There was an Ajax Result Error.");
		} else {
			g_savedId = msg; // remember the saved racer_id
			getAdminRacers();
		}
	}
	
	function deleteRacer() {
		var sel = document.getElementById("selRacers");
		var racer_id = sel.options[sel.selectedIndex].value;
		if(confirm("Are you sure you want to delete this racer?")) {
			var instance = new admin_proxy();
			instance.setCallbackHandler(deleteRacer_callback);
			instance.delete_racer(racer_id);
		}
	}
	
	function deleteRacer_callback(result) {
		var msg = "";
		// parse ajax result
		result = result + "<row>";
		var rows = result.split("<row>");
		rows.pop();
		for(var i=0; i<rows.length; i++) {
			
			var fields = rows[i].split("|");
			msg = fields[0];
		}
		
		// clear the gamertag field
		document.getElementById("txtRacer").value = "";
		// hide the racer data div
		document.getElementById("divRacer").style.display = "none";
		
		if(msg == "error") {
			alert("There was an Ajax Result Error.");
		} else if(msg == "hasHistory") {
			showLoadingDiv(true, "Since this racer has history with this club, they have been made inactive instead of being deleted." + dlgCloseBtn);
			document.getElementById("divLoading").style.top = "50px";
			document.getElementById("overlay").style.backgroundColor = "white";
			getAdminRacers();
		} else if(msg == "success") {
			getAdminRacers();
		}
	}

</script>

</head>
<body onload="init();">

<cfinclude template="include/dialogs.cfm">
<br /><br />
<div align="center" style="width:100%;">
	<table cellspacing="0" cellpadding="3" border="0">
		<tr>
			<td>
				Racers:
			</td>
			<td>
				<select id="selRacers" name="selRacers" onchange="selRacer(this);">
					<option value="-1">--Select Racer--</option>
					<option value="0">Add New</option>
				</select>
			</td>
		</tr>
		
		<tr id="divRacer" style="display:none;">
			<td align="right">
				Gamertag:
			</td>
			<td align="left">
				<input type="text" id="txtRacer" name="txtRacer" value="" maxlength="100" style="display:none;" />
			</td>
		</tr>
		<tr id="rowActive" style="display:none;">
			<td align="right">
				Active:
			</td>
			<td align="left">
				<input type="checkbox" id="chkActive" name="chkActive" />
			</td>
		</tr>
		<tr>
			<td align="center" colspan="2">
				<br />
				<input type="button" id="btnSave" name="btnSave" value="Save" onclick="saveRacer();" style="display:none;" />
				<input type="button" id="btnRemove" name="btnRemove" value="Delete" onclick="deleteRacer();" style="display:none;" />
			</td>
		</tr>
	</table>
</div>

</body>
</html>