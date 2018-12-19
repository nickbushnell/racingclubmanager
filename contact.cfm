<cfif IsDefined("URL.club")>
	<cfset g_clubId = "#URL.club#">
<cfelse>
	<cfif IsDefined("Cookie.defaultClub") is "True">
		<cfset g_clubId = "#Cookie.defaultClub#">
	<cfelse>
		<cfset g_clubId = "1">
	</cfif>
</cfif>
<!---
rcm@racingclubmanager.com
--->
<html>
<head>
<link href='http://fonts.googleapis.com/css?family=Monda:400' rel='stylesheet' type='text/css'>
<link href='nav_list.css' rel='stylesheet' type='text/css'>
<style type="text/css">
body {
	background-color: #263248;
	font-family: 'Monda', sans-serif;
	margin:0px;
	font-size: 13px;
}

select {
	font-family: 'Monda', sans-serif;
	font-size: 13px;
}

input {
	font-family: 'Monda', sans-serif;
	font-size: 13px;
}

td {
	font-family: 'Monda', sans-serif;
	font-size: 13px;
}

textarea{
	font-family: 'Monda', sans-serif;
	font-size: 13px;
}

a {
	color: #FF9800;
}
</style>
<script type="text/javascript" src="include/jquery-1.11.1.min.js"></script>
<script language='javascript' src='common.js'></script>
<script type="text/javascript">
	var g_qs = "";
	
	$(window).resize(function () { resizeOverlay() });
	
	function init() {
		var contactTable = document.getElementById("contactTable");
		contactTable.style.height = document.body.clientHeight * .6; // % of screen height
		doQS();
	}
	
	function doQS() {
		g_qs = location.search;
		//alert(g_qs + ", " + g_qs.length);
		
		if(g_qs.indexOf("?sent=1") > -1) {
			showLoadingDiv(true, "Message Sent");
			
			setTimeout(function(){showLoadingDiv(false, '');},2000);
		} else if(g_qs.indexOf("?sent=0") > -1) {
			showLoadingDiv(true, "We encountered an issue sending your e-mail. Try Again.");
			
			setTimeout(function(){showLoadingDiv(false, '');},3000);
		}
	}
	
	function txtFocus(obj, defaultStr) {
		var txt = obj.value;
		if(txt == defaultStr || txt.indexOf("nonymous") > -1) {
			obj.value = "";
			obj.style.color = "black";
		}
	}
	
	function txtBlur(obj, defaultStr) {
		var txt = obj.value;
		if(txt.length == 0) {
			obj.style.color = "#ccc";
			obj.value = defaultStr;
		}
	}
	
	function doCheck() {
		var name = document.getElementById("txtName");
		var from = document.getElementById("txtFrom");
		var theBody = document.getElementById("txtBody");
		var theForm = document.getElementById("frmContact");
		var submit = document.getElementById("btnSubmit");
		var strError = "";
		
		if(name.value.length <= 0 || name.value == "Your Name") {
			strError += "We won't know your name if you don't fill out the name field.";
			name.value = "Anonymous";
		}
		
		if(from.value.length <= 0 || from.value == "Your E-mail Address") {
			if(strError.length > 0) {
				strError += "\n";
			}
			strError += "You did not supply your e-mail address. We will not be able to respond to your e-mail.";
			from.value = "anonymous-contact@racingclubmanager.com";
		}
		
		if(theBody.value.length <= 0) {
			if(strError.length > 0) {
				strError += "<br />";
			}
			strError += "You did not write anything to us.";
			theBody.value = "Empty Message";
		}
		
		if(strError.length > 0) {
			strError += "<br /><b>Do you still want to send us this e-mail?</b><br />";
			strError += "<input type='button' value='Yes' onclick='document.getElementById(\"btnSubmit\").click();' />";
			strError += "&nbsp;&nbsp;<input type='button' value='No' onclick='showLoadingDiv(false, \"\");' />";
			showLoadingDiv(true, strError);
		} else {
			submit.click();
			//alert("submit.click");
		}
	}
</script>
<title>Racing Club Manager - Contact</title>
</head>
<body onload="init();">
<cfinclude template="include/navigation.cfm">
<cfinclude template="include/dialogs.cfm">

	<div style="color: white;font-size:36px;" align="center">
		Contact Us
	</div>
	<div style="color: white;" align="center">
		<a href="mailto:rcm@racingclubmanager.com">rcm@racingclubmanager.com</a><br />&nbsp;
	</div>

	<div id="socialDiv" align="center">
		<a href="http://racingclubmanager.wordpress.com/"><img src="imgs/social/wp.png" id="wordpressImg" width="50" /></a>
		<a href="https://www.facebook.com/Racingclubmgr"><img src="imgs/social/fb.png" width="50" /></a>
		<a href="https://twitter.com/RacingClubMgr"><img src="imgs/social/twitter.png" width="50" border="0" /></a>
		<!--<img src="imgs/social/youtube.png" width="50" />
		<img src="imgs/social/insta.png" width="50" />-->
	</div>
	
	<form name="frmContact" method="post" action="contact_send.cfm">

	<table id="contactTable" width="100%">
	<tr>
	<td valign="center" align="center">
	<table width="50%" border="0">
		<tr>
			<td>
				<input type="text" name="txtName" id="txtName" value="Your Name" style="width:100%;color: #ccc;" onfocus="txtFocus(this, 'Your Name');"; onblur="txtBlur(this, 'Your Name');" />
			</td>
			<td>
				<input type="text" name="txtFrom" id="txtFrom" value="Your E-mail Address" style="width:100%;color: #ccc;" onfocus="txtFocus(this, 'Your E-mail Address');"; onblur="txtBlur(this, 'Your E-mail Address');" />
			</td>
		</tr>
		<tr>
			<td align="center" colspan="2">
				<textarea name="txtBody" id="txtBody" style="font-family: Tahoma, Geneva, sans-serif;width:100%;height:400px;"></textarea>
			</td>
		</tr>
		<tr>
			<td align="center" colspan="2">
				<input type="button" name="btnSend" id="btnSend" value="Send" onclick="doCheck();" />
			</td>
		</tr>
	</table>
	</td>
	</tr>
	</table>


	<input type="submit" name="btnSubmit" id="btnSubmit" style="display: none;" />
	</form>
	
	<div align="center" style="color: #fff;">
		<form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_top">
			<input type="hidden" name="cmd" value="_s-xclick">
			<input type="hidden" name="encrypted" value="-----BEGIN PKCS7-----MIIHRwYJKoZIhvcNAQcEoIIHODCCBzQCAQExggEwMIIBLAIBADCBlDCBjjELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAkNBMRYwFAYDVQQHEw1Nb3VudGFpbiBWaWV3MRQwEgYDVQQKEwtQYXlQYWwgSW5jLjETMBEGA1UECxQKbGl2ZV9jZXJ0czERMA8GA1UEAxQIbGl2ZV9hcGkxHDAaBgkqhkiG9w0BCQEWDXJlQHBheXBhbC5jb20CAQAwDQYJKoZIhvcNAQEBBQAEgYAtcbhfVD2LU4sp5W/SCeOlzes6xvbSJQA5vJI5N7jGDr3hAi5B3C6CYQm726zw1DDr8pmlrYo4pHSpAjMuPQ/vF5Lj2o+uIBK+16jYkKOKx1vXG6zMkTtT9ptwsXeKoZYg4eGPVcNQ833wsPX/LDdMTWfltPz+2e9CtQebgYesPjELMAkGBSsOAwIaBQAwgcQGCSqGSIb3DQEHATAUBggqhkiG9w0DBwQIX6z9n77i3tOAgaAPaEAJbk4IJ3aK35hVYmA4g7PLdmBfG2/JlINxvzPNMYpX/wObUQ3mv7IVFwKJLQN5oJifSqHSuoCYlidsCZKI9inRFvfGKFVhYoEbq0mYExTAdZdLYy9dw/k653N0uX/BgKMCMcafKe+EzZBTI3MdOvlaaGqZYzt2Hhj450OnZTzvYwtaaUsoo6ssf0UecX0b1eva8gZYEiuXkRB5XUfooIIDhzCCA4MwggLsoAMCAQICAQAwDQYJKoZIhvcNAQEFBQAwgY4xCzAJBgNVBAYTAlVTMQswCQYDVQQIEwJDQTEWMBQGA1UEBxMNTW91bnRhaW4gVmlldzEUMBIGA1UEChMLUGF5UGFsIEluYy4xEzARBgNVBAsUCmxpdmVfY2VydHMxETAPBgNVBAMUCGxpdmVfYXBpMRwwGgYJKoZIhvcNAQkBFg1yZUBwYXlwYWwuY29tMB4XDTA0MDIxMzEwMTMxNVoXDTM1MDIxMzEwMTMxNVowgY4xCzAJBgNVBAYTAlVTMQswCQYDVQQIEwJDQTEWMBQGA1UEBxMNTW91bnRhaW4gVmlldzEUMBIGA1UEChMLUGF5UGFsIEluYy4xEzARBgNVBAsUCmxpdmVfY2VydHMxETAPBgNVBAMUCGxpdmVfYXBpMRwwGgYJKoZIhvcNAQkBFg1yZUBwYXlwYWwuY29tMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDBR07d/ETMS1ycjtkpkvjXZe9k+6CieLuLsPumsJ7QC1odNz3sJiCbs2wC0nLE0uLGaEtXynIgRqIddYCHx88pb5HTXv4SZeuv0Rqq4+axW9PLAAATU8w04qqjaSXgbGLP3NmohqM6bV9kZZwZLR/klDaQGo1u9uDb9lr4Yn+rBQIDAQABo4HuMIHrMB0GA1UdDgQWBBSWn3y7xm8XvVk/UtcKG+wQ1mSUazCBuwYDVR0jBIGzMIGwgBSWn3y7xm8XvVk/UtcKG+wQ1mSUa6GBlKSBkTCBjjELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAkNBMRYwFAYDVQQHEw1Nb3VudGFpbiBWaWV3MRQwEgYDVQQKEwtQYXlQYWwgSW5jLjETMBEGA1UECxQKbGl2ZV9jZXJ0czERMA8GA1UEAxQIbGl2ZV9hcGkxHDAaBgkqhkiG9w0BCQEWDXJlQHBheXBhbC5jb22CAQAwDAYDVR0TBAUwAwEB/zANBgkqhkiG9w0BAQUFAAOBgQCBXzpWmoBa5e9fo6ujionW1hUhPkOBakTr3YCDjbYfvJEiv/2P+IobhOGJr85+XHhN0v4gUkEDI8r2/rNk1m0GA8HKddvTjyGw/XqXa+LSTlDYkqI8OwR8GEYj4efEtcRpRYBxV8KxAW93YDWzFGvruKnnLbDAF6VR5w/cCMn5hzGCAZowggGWAgEBMIGUMIGOMQswCQYDVQQGEwJVUzELMAkGA1UECBMCQ0ExFjAUBgNVBAcTDU1vdW50YWluIFZpZXcxFDASBgNVBAoTC1BheVBhbCBJbmMuMRMwEQYDVQQLFApsaXZlX2NlcnRzMREwDwYDVQQDFAhsaXZlX2FwaTEcMBoGCSqGSIb3DQEJARYNcmVAcGF5cGFsLmNvbQIBADAJBgUrDgMCGgUAoF0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwMzE1MTMyNjM5WjAjBgkqhkiG9w0BCQQxFgQUTBJ3YQORff/ZjNOOisVzhNLDF9IwDQYJKoZIhvcNAQEBBQAEgYAXulqCG+ZFiMPzgR2lNUuDEj4SZttq8+D3LQsVBbNRptC0h4cLHytWHlQi7am/NqEsX5Dsd70eHZlZGUJl2Yd5RPdzmOGVPrui9pUtgxZHmikPcNrEpLT13szm8jh4DvS7IAJj8L38MgO+qocZcBNdW/KP1q/OlwmLKWQGBdkDdQ==-----END PKCS7-----">
			<input type="image" src="imgs/donate_btn.png" border="0" name="submit" alt="PayPal - The safer, easier way to pay online!" height="50">
			<img alt="" border="0" src="https://www.paypalobjects.com/en_US/i/scr/pixel.gif" width="1" height="1">
		</form>
		This is a FREE tool, but if you feel like you want to donate something, just click the donate link for paypal and send me $1 USD.
		<br /> or send BTC to this address: <span style="color: #FF9800;">1N8y8xCAs6Pj149AwdCcT2ZZXW2rZA5k7b</span>
		<br /> or tip me on <a href="http://www.reddit.com/user/nickbfromct">reddit</a>
	</div>
	


</body>
</html>