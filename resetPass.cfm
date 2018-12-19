<cfajaxproxy cfc="resetPass_server" jsclassname="admin_proxy" />

<html>
<head>
<title>Racing Club Manager - Reset Password</title>
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
	
	#resetPassTitle {
		color: #FF9800;
		font-size: 30px;
	}
	
	#btnSubmit{
		font-size:14pt;
		font-family: 'Monda', sans-serif;
		border:none;
		background-color:#FF9800;
		color:white;
		cursor:pointer;
		padding: 5px;
	}
	
	#btnCancel{
		font-size:14pt;
		font-family: 'Monda', sans-serif;
		border:none;
		background-color:#FF9800;
		color:white;
		cursor:pointer;
		padding: 5px;
	}
</style>
<script language='javascript' src='common.js'></script>
<script type="text/javascript">


function resetPassword() {
	var club = document.getElementById("txtClubName").value;
	var login = document.getElementById("txtLoginName").value;
	var email = document.getElementById("txtEmail").value;
	
	
	var instance = new admin_proxy();
	instance.setCallbackHandler(resetPassword_callback);
	instance.reset_password(club, login, email);
}

function resetPassword_callback(result) {
	if(result == "good") {
		var goToLoginBtn = "<br /><input type='button' onclick='goToLogin();' value='Close' />";
		var msg = "We sent you an e-mail containing a temporary password. Please login and change your password.";
		showLoadingDiv(true,msg + goToLoginBtn);
		return false;
	} else if(result == "sendMailError") {
		var msg = "There was a problem sending the e-mail containing your temporary password.";
		showLoadingDiv(true,msg + dlgCloseBtn);
		return false;
	} else {
		var msg = "This page has encountered an error.";
		showLoadingDiv(true,msg + dlgCloseBtn);
		return false;
	}
}

function goToLogin() {
	window.location.href = "login.cfm";
}


</script>
</head>
<body>
<cfinclude template="include/dialogs.cfm">


<div style="width:100%;" align="center">

	<br /><br />
	<div id="rcmTitle_login">
		<img src="imgs/rcm-logo-new-jpg.jpg" style="width:600px;" />
	</div>
	<br />
	
	<div id="resetPassTitle">
		Reset Password
	</div>
	
	<div id="divForm">
		<table>
		<tr>
			<td align="right" style="font-size:20pt;">
				Club:
			</td>
			<td align="left">
				<input type="text" name="txtClubName" id="txtClubName" maxlength="100" style="width:10em;font-size:20pt;" />
			</td>
		</tr>
		<tr>
			<td align="right" style="font-size:20pt;">
				Login:
			</td>
			<td align="left">
				<input type="text" name="txtLoginName" id="txtLoginName" maxlength="50" style="width:10em;font-size:20pt;" />
			</td>
		</tr>
		<tr>
			<td align="right" style="font-size:20pt;">
				E-mail:
			</td>
			<td align="left">
				<input type="text" name="txtEmail" id="txtEmail" maxlength="50" style="width:10em;font-size:20pt;" />
			</td>
		</tr>
		<tr id="rowSubmit">
			<td colspan="2" align="right">
				<input type="button" value="Submit" onclick="resetPassword();" id="btnSubmit" />&nbsp;&nbsp;
				<input type="button" value="Cancel" onclick="goToLogin();" id="btnCancel" />
			</td>
		</tr>
		</table>
	</div>
	
	
	
	
</div>



</body>
</html>
