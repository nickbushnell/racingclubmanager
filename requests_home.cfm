<cfajaxproxy cfc="requests_home_server" jsclassname="admin_proxy" />

<cfif IsDefined("URL.id")>
	<cfset strUUID = "#URL.id#">
<cfelse>
	<cfset strUUID = "">
</cfif>

<cfif Not IsDefined("Session.club_id")>
	<cfif IsDefined("URL.id")> 
		<cfset session.goto = "requests_home.cfm?id=#strUUID#">
	<cfelse>
		<cfset session.goto = "requests_home.cfm">
	</cfif>
	<cflocation url="login.cfm" addtoken="no">
</cfif>

<html>
<head>
<title>Racing Club Manager | Requests Home</title>
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
<script type="text/javascript" src="include/jquery-1.11.1.min.js"></script>
<script language='javascript' src='common.js'></script>
<script type="text/javascript">
	if(!String.prototype.trim) {
		String.prototype.trim=function(){return this.replace(/(?:(?:^|\n)\s+|\s+(?:$|\n))/g,'').replace(/\s+/g,' ');};
	}
	
	$(window).resize(function () { resizeOverlay() });
	
	function init() {
		<cfif Len(strUUID) GT 0>
			<cfoutput>
			reviewRequest("#strUUID#");
			</cfoutput>
		<cfelse>
			getPendingRequests();
		</cfif>
	}
	
	function getPendingRequests() {
		document.getElementById("pageTitle").innerHTML = "Pending Requests";
		document.getElementById("tblPending").style.display = ""; // show pending table
		document.getElementById("tblApprovedDenied").style.display = "none"; // hide approved/denied table
		
		var instance = new admin_proxy();
		instance.setCallbackHandler(fillPendingRequests);
		instance.get_pending_requests();
	}
	
	function fillPendingRequests(result) {
		var tbl = document.getElementById("tblPending");
		clearTableRows(tbl, 1);
		
		if(result.length > 0) {
			result = result + "<row>";
			var rows = result.split("<row>");
			rows.pop();
			for(var i=0; i<rows.length; i++) {
				
				var fields = rows[i].split("|");
				var gamertag = decodeString(fields[0]);
				var request_date = displayDate(fields[1]);
				var uuid = fields[2];

				var row = tbl.insertRow(-1);
				
				row.style.backgroundColor = getRowColor(i);
				
				var cell = row.insertCell(-1);
				cell.innerHTML = gamertag;
				
				cell = row.insertCell(-1);
				cell.innerHTML = request_date;
				
				cell = row.insertCell(-1);
				cell.innerHTML = "<a href='javascript:reviewRequest(\"" + uuid + "\")'>Approve/Deny</a>";
				
			}
		} else {
			var row = tbl.insertRow(-1);
			var cell = row.insertCell(-1);
			cell.align = "center";
			cell.colSpan = "3";
			cell.innerHTML = "No pending requests.";
		}
	}
	
	function reviewRequest(strUUID) {
		showOverlay(true);
		document.getElementById("divReview").style.display = "";
		document.getElementById("ifReview").src = "approve_join.cfm?id=" + strUUID;
	}
	
	function getReviewedRequests(strStatus) {
		document.getElementById("pageTitle").innerHTML = strStatus + " Requests";
		document.getElementById("tblPending").style.display = "none"; // hide pending table
		document.getElementById("tblApprovedDenied").style.display = ""; // show approved/denied table
		
		var instance = new admin_proxy();
		instance.setCallbackHandler(fillReviewedRequests);
		instance.get_reviewed_requests(strStatus);
	}
	
	function fillReviewedRequests(result) {
		var tbl = document.getElementById("tblApprovedDenied");
		clearTableRows(tbl, 1);
		
		//alert("result(" + result.length + ") = [" + result + "]");
		
		if(result.length > 0) {
			result = result + "<row>";
			var rows = result.split("<row>");
			rows.pop();
			for(var i=0; i<rows.length; i++) {
				
				var fields = rows[i].split("|");
				var uuid = decodeString(fields[0]);
				var gamertag = decodeString(fields[1]);
				var reviewer = decodeString(fields[2]);
				var status_date = displayDate(fields[3]);
				
				var row = tbl.insertRow(-1);
				
				row.style.backgroundColor = getRowColor(i);
				
				var cell = row.insertCell(-1);
				cell.innerHTML = gamertag;
				
				cell = row.insertCell(-1);
				cell.innerHTML = reviewer;
				
				cell = row.insertCell(-1);
				cell.innerHTML = status_date;
				
			}
		} else {
			var row = tbl.insertRow(-1);
			var cell = row.insertCell(-1);
			cell.align = "center";
			cell.colSpan = "3";
			cell.innerHTML = "No requests.";
		}
	}
	
	function clearTableRows(tbl, numKeepFromTop) {
		// this should delete all rows but the first one(our column headers)
		for(var i = tbl.rows.length - numKeepFromTop; i > 0; i--) {
			tbl.deleteRow(i);
		}
	}
	
	function closeReview() {
		displayId('divReview', 'none');
		showOverlay(false);
		getPendingRequests();
	}
	
	
</script>
</head>
<body onload="init();">
<cfinclude template="include/navigation.cfm">
<cfinclude template="include/dialogs.cfm">

<div id="divReview" align="center" style="display:none; z-index:3000; width:100%; top:50px; position:absolute;">
	<table border="0" style="background-color: white;border: 2px solid #CCC;width: 600px;">
		<tr>
			<td width="10%">&nbsp;</td>
			<td align="center" width="80%">
				Review Request
			</td>
			<td align="right" width="10%">
				<a href="javascript:closeReview();">Close</a>
			</td>
		</tr>
		<tr>
			<td colspan="3">
				<iframe id="ifReview" name="ifReview" src="" style="width: 100%; height: 400px;" frameborder="0"></iframe>
			</td>
		</tr>
	</table>
</div>


<div style="width:100%;" align="center">
<h3 id="pageTitle">Join Requests</h3>
<a href="javascript:getPendingRequests();" title="View all requests that are waiting for approval or denial.">Pending</a> - 
<a href="javascript:getReviewedRequests('Approved');" title="View all requests that were approved.">Approved</a> - 
<a href="javascript:getReviewedRequests('Denied');" title="View all requests that were denied.">Denied</a>
<br />
<table id="tblPending" border="0" cellspacing="2" cellpadding="3" width="40%">
	<tr class="dataHeaderBG">
		<td align="center" class="dataHeaderTxt">
			<b>Gamertag</b>
		</td>
		<td align="center" class="dataHeaderTxt">
			<b>Requested on</b>
		</td>
		<td align="center" class="dataHeaderTxt">
			&nbsp;<!-- link to approve -->
		</td>
	</tr>
</table>

<table id="tblApprovedDenied" border="0" cellspacing="2" cellpadding="3" width="40%" style="display: none;">
	<tr class="dataHeaderBG">
		<td align="center" class="dataHeaderTxt">
			<b>Gamertag</b>
		</td>
		<td align="center" class="dataHeaderTxt">
			<b>Reviewed By</b>
		</td>
		<td align="center" class="dataHeaderTxt">
			<b>Reviewed on</b>
		</td>
	</tr>
</table>




</body>
</html>