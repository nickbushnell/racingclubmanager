<cfajaxproxy cfc="changePass_server" jsclassname="admin_proxy" />
<cfif Not IsDefined("session.changePass_admin_id") And Not IsDefined("session.changePass_club_id")>
	<cflocation url="logout.cfm" addtoken="no">
</cfif>
<!--- if changePass IDs defined, continue --->

<html>
<head>
<title>Racing Club Manager - Change Password</title>
<link href='http://fonts.googleapis.com/css?family=Monda:400' rel='stylesheet' type='text/css'>
<link href='nav_list.css' rel='stylesheet' type='text/css'>
<style type="text/css">
	body {
		background-color: #263248;
		font-family: 'Monda', sans-serif;
		color: #fff;
		margin-top:30px;
	}
	
	td {
		font-size: 10pt;
		font-family: 'Monda', sans-serif;
	}
	
	a {
		text-decoration: none;
	}
	
	#changePassTitle {
		color: #FF9800;
		font-size: 30px;
	}
</style>
<script language='javascript' src='common.js'></script>
<script type="text/javascript">


function validateChangePass() {
	var newPass = document.getElementById("txtNewPass").value;
	// new pass must be at least 6 characters
	if(newPass.length < 6) {
		var msg = "Your password needs to be at least 6 characters long.";
		showLoadingDiv(true,msg + dlgCloseBtn);
		return false;
	}
	
	if(newPass.charAt(0) == " " || newPass.charAt(newPass.length-1) == " ") {
		var msg = "Your new password cannot start or end with a space character.";
		showLoadingDiv(true,msg + dlgCloseBtn);
		return false;
	}
	
	if(!onlyTheseChars(newPass)) {
		var msg = "Passwords can only contain a-z, A-Z, 0-9, spaces and these specials characters: !@$%^&*_+.";
		showLoadingDiv(true,msg + dlgCloseBtn);
		return false;
	}
	
	// confirm pass length must match new pass length
	var confirmPass = document.getElementById("txtConfirmPass").value;
	if(newPass.length != confirmPass.length) {
		var msg = "Your new passwords need to match.";
		showLoadingDiv(true,msg + dlgCloseBtn);
		return false;
	}
	
	// newPass and confirmPass must match exactly
	for(var i=0; i<newPass.length; i++) {
		if(newPass.charCodeAt(i) != confirmPass.charCodeAt(i)) {
			var msg = "Your new passwords need to match.";
			showLoadingDiv(true,msg + dlgCloseBtn);
			return false;
		}
	}
	
	// must supply old pass
	var oldPass = document.getElementById("txtOldPass").value;
	if(oldPass.length <= 0) {
		var msg = "You must supply your current password.";
		showLoadingDiv(true,msg + dlgCloseBtn);
		return false;
	}

	var instance = new admin_proxy();
	instance.setCallbackHandler(change_password_callback);
	instance.change_password(oldPass, newPass, confirmPass);
}

function change_password_callback(result) {
	if(result == "good") {
		window.location.href = "club_home.cfm";
	} else {
		var msg = "This page has encountered an error: " + result;
		showLoadingDiv(true,msg + dlgCloseBtn);
		return false;
	}
}

function onlyTheseChars(str) {
	for(var i=0; i<str.length; i++) { // loop thru chars
		var thisChar = str.charCodeAt(i);
		var spaceChar = 32;
		var periodChar = 46;
		var underscoreChar = 95;
		var zeroChar = 48;
		var nineChar = 57;
		var exclamChar = 33;
		var dollarChar = 36;
		var percChar = 37;
		var ampChar = 38;
		var starChar = 42;
		var plusChar = 43;
		var upChar = 94;
		var atChar = 64;
		var upperAchar = 65;
		var upperZchar = 90;
		var lowerAchar = 97;
		var lowerZchar = 122;
		if(thisChar == spaceChar 
			|| thisChar == periodChar 
			|| thisChar == underscoreChar 
			|| (thisChar >= zeroChar && thisChar <= nineChar) 
			|| (thisChar >= upperAchar && thisChar <= upperZchar) 
			|| (thisChar >= lowerAchar && thisChar <= lowerZchar)
			|| thisChar == exclamChar
			|| thisChar == dollarChar
			|| thisChar == percChar
			|| thisChar == ampChar
			|| thisChar == starChar
			|| thisChar == plusChar
			|| thisChar == upChar
			|| thisChar == atChar
		) {
			// good!
		} else {
			// this character is bad, exit function
			return false;
		}
	}
	
	return true;
}

function goToLogin() {
	window.location.href = "login.cfm";
}


</script>
</head>
<body>
<cfinclude template="include/dialogs.cfm">

<div style="width:100%;" align="center">
	
	<div id="changePassTitle">
		Change Password
	</div>
	
	<div id="divForm">
		<table>
		<tr id="rowOldPass" style="display:;">
			<td align="right" style="font-size:20pt;">
				Old Password:
			</td>
			<td align="left">
				<input type="password" name="txtOldPass" id="txtOldPass" maxlength="50" style="width:10em;font-size:20pt;" />
			</td>
		</tr>
		<tr id="rowNewPass">
			<td align="right" style="font-size:20pt;">
				New Password:
			</td>
			<td align="left">
				<input type="password" name="txtNewPass" id="txtNewPass" maxlength="50" style="width:10em;font-size:20pt;" />
			</td>
		</tr>
		<tr id="rowConfirmPass">
			<td align="right" style="font-size:20pt;">
				Confirm:
			</td>
			<td align="left">
				<input type="password" name="txtConfirmPass" id="txtConfirmPass" maxlength="50" style="width:10em;font-size:20pt;" />
			</td>
		</tr>
		<tr id="rowSubmit">
			<td colspan="2" align="right">
				<input type="button" value="Submit" onclick="validateChangePass();" style="font-size:14pt;" />
				<input type="button" value="Cancel" onclick="goToLogin();" style="font-size:14pt;" />
			</td>
		</tr>
		</table>
	</div>
	
	
	
	
</div>



</body>
</html>
