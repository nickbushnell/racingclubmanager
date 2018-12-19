<cfajaxproxy cfc="approve_join_server" jsclassname="admin_proxy" />

<cfif IsDefined("URL.id")>
	<cfset strUUID = "#URL.id#">
<cfelse>
	<cfset strUUID = "">
</cfif>

<cfif Not IsDefined("Session.club_id")>
	<cfset session.goto = "approve_join.cfm?id=#strUUID#">
	<cflocation url="login.cfm" addtoken="no">
</cfif>

<html>
<head>
<link href='http://fonts.googleapis.com/css?family=Monda:400' rel='stylesheet' type='text/css'>
<link href='nav_list.css' rel='stylesheet' type='text/css'>
<style type="text/css">
	body {
		margin: 0px;
		/*font-family: Verdana;*/
		font-family: 'Monda', sans-serif;
		font-size: 10pt;
	}
	
	td {
		font-size: 10pt;
	}
	
	a {
		text-decoration: none;
	}
	
	#spanGamertag {
		font-weight: bold;
	}
</style>
<cfoutput>
<script type="text/javascript">
	var strUUID = "#strUUID#";
</script>
</cfoutput>
<script language='javascript' src='common.js'></script>
<script type="text/javascript">
	
	var strEmail = "";
	
	function init() {
		if(strUUID.length > 0) {
			getAskToJoin();
		} else {
			document.getElementById("divContainer").innerHTML = "Invalid Request ID";
		}
	}
	
	function getAskToJoin() {
		var instance = new admin_proxy();
		instance.setCallbackHandler(fillAskToJoin);
		instance.get_ask_to_join(strUUID);
	}
	
	function fillAskToJoin(result) {
		var rows = getRows(result);
		if(rows[0] == "error") {
			var errMsg = "This request to join may have already been processed.<br />OR<br />You logged in as the wrong club." + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			document.getElementById("divLoading").style.top = "50px";
			document.getElementById("overlay").style.backgroundColor = "white";
		} else {
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				var strClubName = fields[0];
				var strGamertag = fields[1];
				strEmail = fields[2];
				var strJoinStatus = fields[3];
				var strEmailMsg = fields[4];
				
				if(strJoinStatus == "REQUEST SENT") {
					document.getElementById("spanGamertag").innerHTML = strGamertag;
					document.getElementById("spanClub").innerHTML = strClubName;
				} else {
					document.getElementById("divContainer").innerHTML = "This request has been <b>" + strJoinStatus + "</b>";
				}
			}
		}
	}
	
	function completeRequest(blnApproved, blnUseEmail) {
		var instance = new admin_proxy();
		instance.setCallbackHandler(completeRequest_callback);
		instance.complete_request(strUUID, blnApproved.toString(), document.getElementById("txtNotes").value.trim(), blnUseEmail.toString());
	}
	
	function completeRequest_callback(result) {
		if(result.length > 0) {
			if(result == "success") {
				window.location = window.location;
			} else {
				var errMsg = "This page encountered an error: E02" + dlgCloseBtn;
				showLoadingDiv(true, errMsg);
				document.getElementById("divLoading").style.top = "50px";
				document.getElementById("overlay").style.backgroundColor = "white";
			}
		} else {
			var errMsg = "This page encountered an error: E03" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			document.getElementById("divLoading").style.top = "50px";
			document.getElementById("overlay").style.backgroundColor = "white";
		}
	}
	
	function updateChars(obj) {
		var maxLength = 500;
		var currLength = obj.value.trim().length;
		
		if(currLength > maxLength) {
			obj.value = obj.value.substring(0,maxLength);
		} else {
			document.getElementById("descChars").value = maxLength-currLength;
		}
	}
	
	function askToUseEmail(blnApproved) {
		var errMsg = "Would you like the requestor to be able to respond to this decision?<br />Saying YES means that the requestor will be able to see your e-mail address.";
		   errMsg += "<br /><br /><input type='button' onclick='completeRequest(" + blnApproved + ", true);' value='Yes' />&nbsp;&nbsp;<input type='button' onclick='completeRequest(" + blnApproved + ", false);' value='No' />";
		showLoadingDiv(true, errMsg);
		document.getElementById("divLoading").style.top = "50px";
		document.getElementById("overlay").style.backgroundColor = "white";
	}
	
	function confirmDismissRequest() {
		var errMsg = "Are you sure you want to dismiss this request?<br />Dismissal means removing the request from your queues and the sender will NOT be notified.";
		   errMsg += "<br /><br /><input type='button' onclick='dismissRequest();' value='Yes' />&nbsp;&nbsp;<input type='button' onclick='showLoadingDiv(false,null);' value='No' />";
		showLoadingDiv(true, errMsg);
		document.getElementById("divLoading").style.top = "50px";
		document.getElementById("overlay").style.backgroundColor = "white";
	}
	
	function dismissRequest() {
		var instance = new admin_proxy();
		instance.setCallbackHandler(dismissRequest_callback);
		instance.dismiss_request(strUUID);
	}
	
	function dismissRequest_callback(result) {
		var rows = getRows(result);
		if(rows[0] == "error") {
			var errMsg = "This request to join may have already been processed.<br />OR<br />You logged in as the wrong club." + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			document.getElementById("divLoading").style.top = "50px";
			document.getElementById("overlay").style.backgroundColor = "white";
		} else if(rows[0] == "good") {
			window.location = window.location;
		}
	}
	
	
</script>
<title>Racing Club Manager - Approve Join Requests</title>
</head>
<body onload="init();">
<cfinclude template="include/dialogs.cfm">

<div style="width:100%;" align="center" id="divContainer">
	<table border="0" cellpadding="10" style="border: 1px solid black;">
		<tr>
			<td align="center">
				Do you approve or deny <span id="spanGamertag"></span>'s request to join <span id="spanClub"></span>?
			</td>
		</tr>
		<tr>
			<td align="center">
				<div style="width:100%" align="left">Notes:<div>
				<input type="text" id="descChars" size="3" readonly value="500" />
				<br />
				<textarea style="width: 100%; height: 150px;" id="txtNotes" onkeyup="updateChars(this);"></textarea>
			</td>
		</tr>
		<tr>
			<td align="center">
				<input type="button" value="Approve" onclick="askToUseEmail(true);" />
				&nbsp;&nbsp;
				<input type="button" value="Deny" onclick="askToUseEmail(false);" />
				&nbsp;&nbsp;
				<input type="button" value="Dismiss" onclick="confirmDismissRequest();" />
			</td>
		</tr>
	</table>
</div>


</body>
</html>