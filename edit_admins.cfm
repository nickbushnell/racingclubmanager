<cfajaxproxy cfc="edit_admins_server" jsclassname="admin_proxy" />

<cfif Not IsDefined("Session.club_id")>
	<cfset session.goto = "edit_admins.cfm">
	<cflocation url="login.cfm?adminDlg=1" addtoken="no">
</cfif>

<html>
<head>
<title>Racing Club Manager | Edit Admins</title>
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
	
	#divAddAdmin {
		width:90%;
	}
	
	#divAdminsTbl {
		width:90%;
	}
	
	#instructionsContainer {
		width:90%;
		text-align: left;
		background-color:#FF9800;
		cursor:pointer;
		color: #000;
	}
	
	#divInstructions {
		width:90%;
		text-align: left;
	}

</style>
<cfoutput>
<script type="text/javascript">
	var g_loggedInAdmin = parseInt("#Session.admin_id#");
</script>
</cfoutput>
<script language='javascript' src='common.js'></script>
<script type="text/javascript">
	if(!String.prototype.trim) {
		String.prototype.trim=function(){return this.replace(/(?:(?:^|\n)\s+|\s+(?:$|\n))/g,'').replace(/\s+/g,' ');};
	}
	
	var g_adminId = -1;
	
	function init() {
		getAdmins();
	}
	
	function getAdmins() {
		g_adminId = -1;
		document.getElementById("divAdminsTbl").innerHTML = "";
		document.getElementById("addNewAdminlink").style.visibility = "visible";
		
		var instance = new admin_proxy();
		instance.setCallbackHandler(getAdmins_callback);
		instance.get_admins();
	}
	
	function getAdmins_callback(result) {
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E01" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			document.getElementById("divLoading").style.top = "75px";
			document.getElementById("overlay").style.backgroundColor = "white";
		} else {
			var div = document.getElementById("divAdminsTbl");
			
			var tbl = document.createElement("table");
			tbl.id = "adminsTbl";
			tbl.width = "100%";
			div.appendChild(tbl);
			
			if(rows.length <= 0) {
				cell.innerHTML = "No Admins Yet";
			} else {
				var row = tbl.insertRow(-1);
				row.setAttribute("class","dataHeaderBG");
				
				var cell = row.insertCell(-1);
				cell.innerHTML = "Login";
				cell.setAttribute("class", "dataHeaderTxt");
				cell.align = "center";
				cell.width = "28%";
				
				cell = row.insertCell(-1);
				cell.innerHTML = "E-mail";
				cell.setAttribute("class", "dataHeaderTxt");
				cell.align = "center";
				cell.width = "35%";
				
				cell = row.insertCell(-1);
				cell.innerHTML = "Permission";
				cell.setAttribute("class", "dataHeaderTxt");
				cell.align = "center";
				cell.width = "15%";
				
				cell = row.insertCell(-1);
				cell.innerHTML = "Join Mail";
				cell.setAttribute("class", "dataHeaderTxt");
				cell.align = "center";
				cell.width = "12%";
				
				cell = row.insertCell(-1);
				cell.innerHTML = "&nbsp;";
				cell.setAttribute("class", "dataHeaderTxt");
				cell.align = "center";
				cell.width = "10%";
			}
			
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				
				var admin_id = parseInt(fields[0]);
				var admin_login = decodeString(fields[1]);
				var admin_permission = parseInt(fields[2]);
				var admin_email = decodeString(fields[3]);
				var admin_joinMail = parseInt(fields[4]);;
				
				row = tbl.insertRow(-1);
				row.style.backgroundColor = getRowColor(i);
				
				cell = row.insertCell(-1);
				cell.innerHTML = "<input type='text' value='" + admin_login + "' id='txtLogin_" + admin_id + "' style='width:85%;' onchange='validateLogin(" + admin_id + ")' maxlength='50' /> <span id='imgLogin_" + admin_id + "'></span>";
				cell.setAttribute("class", "cellData");
				
				cell = row.insertCell(-1);
				cell.innerHTML = "<input type='text' value='" + admin_email + "' id='txtEmail_" + admin_id + "' style='width:85%;' onchange='validateEmail(" + admin_id + ")' maxlength='100' /> <span id='imgEmail_" + admin_id + "'></span>";
				cell.setAttribute("class", "cellData");
				
				cell = row.insertCell(-1);
				cell.innerHTML = createPermissionSelect(admin_id,admin_permission);
				cell.setAttribute("class", "cellData");
				cell.align = "center";
				
				cell = row.insertCell(-1);
				var strChecked = "";
				if(admin_joinMail == 1) {
					strChecked = "checked";
				}
				cell.innerHTML = "<input type='checkbox' id='chkJoinMail_" + admin_id + "' " + strChecked + " />";
				cell.setAttribute("class", "cellData");
				cell.align = "center";
				
				cell = row.insertCell(-1);
				var strHTML = "";
					if(admin_id != g_loggedInAdmin) {
						strHTML += "<img src='imgs/delete-icon.png' onclick='confirmDelete(" + admin_id + ");' style='cursor:pointer;' title='Delete this admin.' /> ";
					}
					strHTML += "<img src='imgs/save_icon.png' onclick='saveAdmin(" + admin_id + ");' style='cursor:pointer;' height='20' title='Save this admin.' />";
				cell.innerHTML = strHTML;
				cell.setAttribute("class", "cellData");
				cell.align = "center";
			}
		}
	}
	
	function createPermissionSelect(id, perm) {
		var strHTML = "<select id='selPerm_" + id + "' style='width:3em;'>";
			
		for(var i=0; i<3; i++) {
			var strSelected = "";
			if(i==perm) {
				strSelected = 'selected="selected"';
			}
			strHTML += "<option value='" + i + "' " + strSelected + ">" + i + "</option>";
		}
		
		strHTML += "</select>";
		
		return strHTML;
	}
	
	function validateLogin(admin_id) {
		g_adminId = admin_id;
		var txtLogin = document.getElementById("txtLogin_" + admin_id).value;
		
		if((txtLogin.length >= 4) && checkFirstChar(txtLogin) && checkLastChar(txtLogin) && onlyNormalChars(txtLogin)) {
			var instance = new admin_proxy();
			instance.setCallbackHandler(validateLogin_callback);
			instance.check_login_unique(admin_id,txtLogin);
		} else {
			showBadImg("imgLogin_", g_adminId);
		}
	}
	
	function validateLogin_callback(result) {
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E02" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			document.getElementById("divLoading").style.top = "75px";
			document.getElementById("overlay").style.backgroundColor = "white";
		} else {
			var fields = rows[i].split("|");
			
			var msg = fields[0];
			

			if(msg == "good") {
				showGoodImg("imgLogin_", g_adminId);
			} else if(msg == "taken") {
				showBadImg("imgLogin_", g_adminId);
			} else {
				var errMsg = "This page encountered an error: E03" + dlgCloseBtn;
				showLoadingDiv(true, errMsg);
				document.getElementById("divLoading").style.top = "75px";
				document.getElementById("overlay").style.backgroundColor = "white";
			}
		}
	}
	
	function checkFirstChar(txtLogin) {
		var upperAchar = 65;
		var upperZchar = 90;
		var lowerAchar = 97;
		var lowerZchar = 122;
		if((txtLogin.charCodeAt(0) >= upperAchar && txtLogin.charCodeAt(0) <= upperZchar) || (txtLogin.charCodeAt(0) >= lowerAchar && txtLogin.charCodeAt(0) <= lowerZchar)) {
			return true;
		} else {
			return false;
		}
	}
	
	function checkLastChar(txtLogin) {
		if(txtLogin.charAt(txtLogin.length-1) == " ") {
			return false;
		} else {
			return true;
		}
	}
	
	function showGoodImg(imgId,admin_id) {
		var img = document.getElementById(imgId + admin_id);
		if(imgId.length > 0) {
			img.innerHTML = "<img src='imgs/green-check.png' />";
		} else {
			img.innerHTML = "";
		}
	}
	
	function showBadImg(imgId,admin_id) {
		var img = document.getElementById(imgId + admin_id);
		if(imgId.length > 0) {
			img.innerHTML = "<img src='imgs/red-x.png' />";
		} else {
			img.innerHTML = "";
		}
	}
	
	function getIdx(arr,id) {
		if(arr) {
			for(var i=0; i<arr.length; i++) {
				if(arr[i][0] == id) {
					return i;
				}
			}
		}
		return(-1);
	}
	
	function showDesc(id) {
		var div = document.getElementById(id);
		if(div.style.display == "") {
			div.style.display = "none";
		} else {
			div.style.display = "";
		}
	}
	
	function confirmDelete(admin_id) {
		g_adminId = admin_id;
		var errMsg  = "Are you sure you want to delete this admin?";
			errMsg += "<br /><br /><input type='button' value='Yes' onclick='doDeleteAdmin();' />&nbsp;&nbsp;";
			errMsg += "<input type='button' value='No' onclick='showLoadingDiv(false, \"\");' />";
		showLoadingDiv(true, errMsg);
		document.getElementById("divLoading").style.top = "75px";
		document.getElementById("overlay").style.backgroundColor = "white";
	}
	
	function doDeleteAdmin() {
		showLoadingDiv(false, "");
		if(g_adminId > 0) {
			var instance = new admin_proxy();
			instance.setCallbackHandler(deleteAdmin_callback);
			instance.delete_admin(g_adminId);
		}
	}
	
	function deleteAdmin_callback(result) {
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E04" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			document.getElementById("divLoading").style.top = "75px";
			document.getElementById("overlay").style.backgroundColor = "white";
		} else {
			var fields = rows[i].split("|");
			
			var msg = fields[0];
			if(msg == "good") {
				getAdmins();
			}
		}
	}
	
	function saveAdmin(admin_id) {
		// so what if there are red Xs, we don't care
		// we will validate server side and send back an error if still not valid
		var login = document.getElementById("txtLogin_" + admin_id).value.trim();
		var email = document.getElementById("txtEmail_" + admin_id).value.trim();
		var selPerm = document.getElementById("selPerm_" + admin_id)
		var permission = selPerm.options[selPerm.selectedIndex].value;
		var joinMail = 0;
		if(document.getElementById("chkJoinMail_" + admin_id).checked) {
			joinMail = 1;
		}
		
		var instance = new admin_proxy();
		instance.setCallbackHandler(saveAdmin_callback);
		instance.save_admin(admin_id,login,email,permission,joinMail);
	}
	
	function saveAdmin_callback(result) {
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E05" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			document.getElementById("divLoading").style.top = "75px";
			document.getElementById("overlay").style.backgroundColor = "white";
		} else if(rows[0] == "invalidError") {
			var errMsg = "This login name is invalid." + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			document.getElementById("divLoading").style.top = "75px";
			document.getElementById("overlay").style.backgroundColor = "white";
		} else if(rows[0] == "loginError") {
			var errMsg = "This login name is already in use." + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			document.getElementById("divLoading").style.top = "75px";
			document.getElementById("overlay").style.backgroundColor = "white";
		} else if(rows[0] == "emailError") {
			var errMsg = "The e-mail address is not in a valid format." + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			document.getElementById("divLoading").style.top = "75px";
			document.getElementById("overlay").style.backgroundColor = "white";
		} else if(rows[0] == "sendMailError") {
			var errMsg = "There was a problem sending an email to the new admin." + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			document.getElementById("divLoading").style.top = "75px";
			document.getElementById("overlay").style.backgroundColor = "white";
		} else {
			var fields = rows[i].split("|");
			
			var msg = fields[0];
			if(msg == "good") {
				getAdmins();
			}
		}
	}
	
	function validateEmail(admin_id) {
		var txt = document.getElementById("txtEmail_" + admin_id);
		var email = txt.value.trim();
		
		
		var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
		if(re.test(email)) {
			showGoodImg("imgEmail_",admin_id);
		} else {
			showBadImg("imgEmail_",admin_id);
		}
	}
	
	function addNewAdmin() {
		var link = document.getElementById("addNewAdminlink");
		link.style.visibility = "hidden";
		
		
		var tbl = document.getElementById("adminsTbl");
		row = tbl.insertRow(-1);
		row.style.backgroundColor = getRowColor(tbl.rows.length-1);
				
		cell = row.insertCell(-1);
		cell.innerHTML = "<input type='text' value='' id='txtLogin_0' style='width:85%;' onchange='validateLogin(0)' maxlength='50' /> <span id='imgLogin_0'></span>";
		cell.setAttribute("class", "cellData");
		
		cell = row.insertCell(-1);
		cell.innerHTML = "<input type='text' value='' id='txtEmail_0' style='width:85%;' onchange='validateEmail(0)' maxlength='100' /> <span id='imgEmail_0'></span>";
		cell.setAttribute("class", "cellData");
		
		cell = row.insertCell(-1);
		cell.innerHTML = createPermissionSelect(0,2);
		cell.setAttribute("class", "cellData");
		cell.align = "center";
		
		cell = row.insertCell(-1);
		cell.innerHTML = "<input type='checkbox' id='chkJoinMail_0' checked />";
		cell.setAttribute("class", "cellData");
		cell.align = "center";
		
		cell = row.insertCell(-1);
		var strHTML = "";
		strHTML += "<img src='imgs/delete-icon.png' onclick='removeAdminRow();' style='cursor:pointer;' title='Remove this admin row.' /> ";
		strHTML += "<img src='imgs/save_icon.png' onclick='saveAdmin(0);' style='cursor:pointer;' height='20' title='Save this admin.' />";
		cell.innerHTML = strHTML;
		cell.setAttribute("class", "cellData");
		cell.align = "center";
	}
	
	function removeAdminRow() {
		var tbl = document.getElementById("adminsTbl");
		tbl.deleteRow(tbl.rows.length-1);
		document.getElementById("addNewAdminlink").style.visibility = "visible";
	}
	
</script>
</head>
<body onload="init()">
<!---<cfinclude template="include/navigation.cfm">--->
<cfinclude template="include/dialogs.cfm">

<br /><br />

<div style="width:100%;" align="center">

<div id="instructionsContainer" onclick="showDesc('divInstructions');">
 &#9662; Help
</div>

<div id="divInstructions" style="display:none;">
	<ul>
		<li>Login Names</li>
			<ul>
				<li>Must be at least 4 characters long</li>
				<li>Can contain letters, numbers, underscores, periods and spaces</li>
				<li>Must start with a letter</li>
				<li>Cannot end in a space</li>
			</ul>
		<li>Permissions</li>
			<ul>
				<li>0 - Access to everything. Can add/edit admins, manage series/races, add/edit racers, accept/deny requests to join.</li>
				<li>1 - Ability to manage series/races, add/edit racers, accept/deny requests to join.</li>
				<li>2 - Only able to accept/deny requests to join.</li>
			</ul>
	</ul>
</div>

<div style="font-size:15px;">&nbsp;</div>

<div id="divAddAdmin" align="right">
	<a href="javascript:addNewAdmin();" id="addNewAdminlink">Add New</a>
</div>

<div id="divAdminsTbl"></div>





</div>


</body>
</html>