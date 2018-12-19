<!---<cfif IsDefined("Session.lockedOut") AND IsDefined("session.loginAttempts")>
	<cfif DateCompare(now(), session.lockedOut) GTE 0>
		<!--- if it is now 10 minutes after we locked the user out, clear lockedOut and loginAttempts --->
		
		
		<!--- send back to login page --->
		<cflocation url="login.cfm" addtoken="no">
	</cfif>
<cfelse>
	<!--- send back to login page --->
	<cflocation url="login.cfm" addtoken="no">
</cfif>--->

<cfif IsDefined("URL.reset")>
<cfif URL.reset EQ "true">
<cfset msg = clearLockedOut()>
</cfif>
</cfif>

<!---
<cfdump var="#session#">
--->

<cffunction output="no" name="clearLockedOut">
	<cfif IsDefined("session.lockedOut")>
		<cfset structDelete(SESSION, "lockedOut")>
	</cfif>
	
	<cfif IsDefined("session.loginAttempts")>
		<cfset structDelete(SESSION, "loginAttempts")>
	</cfif>
	
	<cfreturn "okay">
</cffunction>


<html>
<head>
<link href='http://fonts.googleapis.com/css?family=Monda:400' rel='stylesheet' type='text/css'>
<style type="text/css">
	body {
		background-color: #263248;
		font-family: 'Monda', sans-serif;
		color: #FF9800;
		font-size:12px;
		margin:0px;
	}
</style>
<script type="text/javascript" src="include/jquery-1.11.1.min.js"></script>
<script type="text/javascript">

$(window).resize(function () { init() });

function init() {
	resizeText("divFailed", parseInt(document.body.offsetWidth), 12, 225, .99);
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

</script>
</head>
<body onload="init()">

<div align="center" style="width: 100%;position:absolute;top:300px;" id="divFailed">
You have failed login at least 3 times.
</div>

</body>
</html>