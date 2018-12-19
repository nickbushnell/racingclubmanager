<cfajaxproxy cfc="admin_add_series_server" jsclassname="admin_proxy" />
<cfif Not IsDefined("Session.club_id")>
	<cfset session.goto = "admin_races_results.cfm">
	<cflocation url="login.cfm" addtoken="no">
</cfif>

<cfif Not IsDefined("Session.permission")>
	<cflocation url="logout.cfm" addtoken="no">
<cfelseif Session.permission GT 1>
	<cflocation url="logout.cfm?message=permission" addtoken="no">
</cfif>
<html>
<head>
<title>Racing Club Manager - Add New Series</title>
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
		font-size: 10pt;
	}
	
	input {
		font-family: 'Monda', sans-serif;
		font-size: 10pt;
	}
	
	td {
		font-size: 10pt;
	}
	
	a {
		text-decoration: none;
	}

	
	#divLoading {
		position: absolute;
		top: 200px;
	}
</style>
<script language='javascript' src='common.js'></script>
<script type="text/javascript">
	if(!String.prototype.trim) {
		String.prototype.trim=function(){return this.replace(/(?:(?:^|\n)\s+|\s+(?:$|\n))/g,'').replace(/\s+/g,' ');};
	}
	
	function init() {
		//showLoadingDiv(true, "Loading...");
		//document.getElementById("divLoading").style.top = "50px";
		//document.getElementById("overlay").style.backgroundColor = "white";

	}
	
	function confirmCancel() {
		var errMsg  = "Are you sure you want to cancel adding this series?";
			errMsg += "<br /><br /><input type='button' value='Yes' onclick='doCancel();' />&nbsp;&nbsp;";
			errMsg += "<input type='button' value='No' onclick='showLoadingDiv(false, \"\");' />";
		showLoadingDiv(true, errMsg);
		document.getElementById("divLoading").style.top = "50px";
		document.getElementById("overlay").style.backgroundColor = "white";
	}
	
	function doCancel() {
		parent.closeAddNewSeries();
	}
	
	function doAddNew() {
		// get series name
		var name = document.getElementById("txtSeriesName").value.trim();
		
		// get series type
		var sel = document.getElementById("selSeriesType");
		var type = sel.options[sel.selectedIndex].value;
		
		// do AJAX
		var instance = new admin_proxy();
		instance.setCallbackHandler(doAddNew_callback);
		instance.add_new_series(name, type);
	}
	
	function doAddNew_callback(result) {
		var rows = getRows(result);
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E01" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			document.getElementById("divLoading").style.top = "50px";
			document.getElementById("overlay").style.backgroundColor = "white";
		} else {
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				parent.closeAddNewSeries();
			}
		}
	}

</script>
</head>
<body onload="init()">
<cfinclude template="include/dialogs.cfm">

<br /><br />
<div style="width:100%;" align="center" id="pageContainer">
	
	<table>
		<tr>
			<td>
				Name:
			</td>
			<td>
				<input type="text" name="txtSeriesName" id="txtSeriesName" maxlength="100" />
			</td>
		</tr>
		<tr>
			<td>
				Type:
			</td>
			<td>
				<select name="selSeriesType" id="selSeriesType">
					<option value="Standard">Standard</option>
					<option value="Multi-Class">Multi-Class</option>
					<option value="Teams">Teams</option>
				</select>
			</td>
		</tr>
		<tr>
			<td align="center" colspan="2">
				<br />&nbsp;
				<input type="button" value="Add Series" onclick="doAddNew();" />
				<input type="button" value="Cancel" onclick="confirmCancel();" />
			</td>
		</tr>
	</table>
	
	
	
	
	
	
</div>


	
</body>
</html>