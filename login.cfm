<cfajaxproxy cfc="login_server" jsclassname="details_proxy" />

<cfset doingRelease = "NO">

<cfif IsDefined("URL.club")>
	<cfset g_clubId = "#URL.club#">
<cfelse>
	<cfif IsDefined("Cookie.defaultClub") is "True">
		<cfset g_clubId = "#Cookie.defaultClub#">
	<cfelse>
		<cfset g_clubId = "1">
	</cfif>
</cfif>

<cfif IsDefined("URL.adminDlg")>
	<cfset g_adminDlg = Int(URL.adminDlg)>
<cfelse>
	<cfset g_adminDlg = "-1">
</cfif>

<cfset body = "<body onload='init();'>">
<html>
<head>
<title>Racing Club Manager - Admin Login</title>

<link href='http://fonts.googleapis.com/css?family=Monda:400' rel='stylesheet' type='text/css'>
<link href='nav_list.css' rel='stylesheet' type='text/css'>
<style type="text/css">
	body {
		background-color: #263248;
		font-family: 'Monda', sans-serif;
		color: #fff;
		margin:0px;
	}
	
	td {
		font-size: 10pt;
		font-family: 'Monda', sans-serif;
	}
	
	a {
		color: #FF9800;
	}
	
	#divRaceDetails {
		position: absolute;
		z-index: 500;
		top: 50px;
		width: 100%;
	}
	
	#login_title {
		color: #FF9800;
		font-size: 30px;
	}
	
	#btnLogin{
		font-size:13pt;
		font-family: 'Monda', sans-serif;
		border:none;
		background-color:#FF9800;
		color:white;
		cursor:pointer;
		padding: 5px;
	}
	
	#rcmTitle_login {
		font-family: 'Monda', sans-serif;
		font-size: 85px;
		/*color: #FF9800;*/
	}
</style>
<script language='javascript' src='common.js'></script>
<script type="text/javascript" src="include/jquery-1.11.1.min.js"></script>
<script type="text/javascript">
	$(window).resize(function () { doResize() });
	
	var didInit = false;
	<cfif IsDefined("session.goto")>
		<cfoutput>
		var sessionGoTo = "#SESSION.goto#";
		</cfoutput>
	<cfelse>
		var sessionGoTo = "";
	</cfif>
	
	$(document).keypress(function(e) {
		if(e.which == 13) {
			attemptLogin();
		}
	});
	
	function init() {
		didInit = true;
		doResize();
	}
	
	function doResize() {
		if(didInit) {
			var perc = .75;
			if(parseInt(document.body.offsetWidth) > 1200) {
				perc = .50;
			}
			resizeText("rcmTitle_login", parseInt(document.body.offsetWidth), 85, 875, perc);
			resizeOverlay();
		}
	}
	
	function resizeText(id, divWidth, fontControlSize, actualWidthAtCtrlSize, perc) {
		// font-size: 100px is actually 240px wide
		var logoMaxWidth = divWidth * perc; // get max width that the logo can be
		var ratio = logoMaxWidth / actualWidthAtCtrlSize;
		var newFontSize = Math.floor(ratio * fontControlSize);
		//alert(newFontSize);
		document.getElementById(id).style.fontSize = newFontSize + "px";
		//console.log(id + ": " + newFontSize);
	}
	
	function attemptLogin()
	{
		var username = document.getElementById("userName").value;
		var password = document.getElementById("userPass").value;
		
		var instance = new details_proxy();
		instance.setCallbackHandler(attemptLogin_callback);
		instance.attempt_login(username, password, sessionGoTo);
	}
	
	function attemptLogin_callback(result)
	{
		//alert("RESULT: " + result);
		if(result == "failedLogin")
		{
			window.location.href = "login.cfm?login=false";
		} else {
			window.location.href = result;
		}
		
	}
</script>
</head>







<cfif IsDefined("Session.loginAttempts")>
<cfif Session.loginAttempts GTE 3>
	<cflocation url="lockedout.cfm" addtoken="no">
</cfif>
</cfif>

<cfif doingRelease EQ "YES">
	<cfoutput>
		<div align="center" style="color:red; padding:10px; border: 1px solid red;">Releasing an update. Follow <a href="https://twitter.com/RacingClubMgr">@RacingClubMgr</a> on twitter for up-to-date information.</div>
	</cfoutput>
</cfif>


<cfoutput>#body#</cfoutput>

<cfinclude template="include/dialogs.cfm">
<cfif g_adminDlg LT 1>
	<cfinclude template="include/navigation.cfm">
</cfif>

<cfif doingRelease EQ "YES">
	<cfabort />
</cfif>


<cfif IsDefined("session.club_id")>
	<div id="loggedin" align="center" style="width: 100%; font-size: 10pt;">
		You are currently logged in. <a href="logout.cfm" style="color: #FF9800">Logout</a>
	</div>
</cfif>
<!--- start content --->

<cfif IsDefined("URL.login")>
	<cfif URL.login IS "false">
		<div align="center">
			<br />&nbsp;
			<span style="border: 2px solid red;">
				ERROR! Make sure your CAPS LOCK is OFF.
			</span>
		</div>
	</cfif>
</cfif>

<cfif IsDefined("URL.message")>
	<div align="center">
		<br />&nbsp;
		<span style="border: 2px solid red;padding:10px;">
			<cfif URL.message EQ "loggedout">
				You are now logged out!
			<cfelseif URL.message EQ "permission">
				You do not have permission to view that page.
			<cfelseif URL.message EQ "error1">
				Login encountered an error: 1
			<cfelseif URL.message EQ "error2">
				Login encountered an error: 2
			<cfelseif URL.message EQ "error3">
				Login encountered an error: 3
			</cfif>
		</span>
	</div>
</cfif>

<div style="font-size:30px;">&nbsp;</div>
	
<div style="width:100%;" align="center">
	<div id="rcmTitle_login">
		<!--Racing Club Manager-->
			<!--<span style="font-weight:bold;font-style:italic;color: #FF9800;">racing </span><span style="font-weight:bold;">club</span><span style="font-weight:bold;color: #FF9800;">manager</span>-->
			<img src="imgs/rcm-logo-new-jpg.jpg" style="width:600px;" />
	</div>
</div>

<div style="font-size:20pt;">&nbsp;</div>

<table cellspacing="0" cellpadding="3" align="center">
	<tr>
		<td colspan="2">
			<div style="font-size: 14pt;">
				Username:
			</div>
			<div style="padding:5px;background-color:white;">
				<input type="text" name="userName" id="userName" style="width:15em;font-size:16pt;border:none;" />
			</div>
		</td>
	</tr>
	
	<tr>
		<td colspan="2">
			<div style="font-size: 14pt;">
				Password:
			</div>
			<div style="padding:5px;background-color:white;">
				<input type="password" name="userPass" id="userPass" style="width:15em;font-size:16pt;border:none;" />
			</div>
		</td>
	</tr>
	
	<tr>
		<td>
			<a href="resetPass.cfm" style="font-size:14pt;">Forgot Password</a>
		</td>
		<td align="right">
			<input type="button" name="btnLogin" id="btnLogin" value="Log Me In" onclick="attemptLogin();" />
		</td>
	</tr>
</table>

</body>
</html>

