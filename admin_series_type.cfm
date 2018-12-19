<cfajaxproxy cfc="admin_series_type_server" jsclassname="admin_proxy" />

<cfif IsDefined("URL.series")>
	<cfset g_seriesId = "#URL.series#">
<cfelse>
	<cfset g_seriesId = "-1">
</cfif>

<cfif Not IsDefined("Session.club_id")>
	<cfset session.goto = "admin_series_type.cfm?series=" & g_seriesId>
	<cflocation url="login.cfm?adminDlg=1" addtoken="no">
</cfif>

<html>
<head>
<title>Racing Club Manager - Edit Series Type</title>
<link href='http://fonts.googleapis.com/css?family=Monda:400' rel='stylesheet' type='text/css'>
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
	
	.btn_SeriesType {
		background-color: #263248;
		color: white;
		font-size: 20pt;
		padding: 10 20 10 20;
		cursor: pointer;
		border: none;
	}
	
	.spanEditBtn {
		background-color: #ccc;
		padding: 5 10 5 10;
		cursor: pointer;
		border: none;
		font-size: 14pt;
	}
</style>
<cfoutput>
<script type="text/javascript">
	var g_seriesId = parseInt("#g_seriesId#");
</script>
</cfoutput>
<script language='javascript' src='common.js' async></script>
<script type="text/javascript">
	if(!String.prototype.trim) {
		String.prototype.trim=function(){return this.replace(/(?:(?:^|\n)\s+|\s+(?:$|\n))/g,'').replace(/\s+/g,' ');};
	}
	
	function init() {
		showLoadingDiv(true, "Loading...");
		document.getElementById("divLoading").style.top = "50px";
		document.getElementById("overlay").style.backgroundColor = "white";
		
		// get current series type
		var instance = new admin_proxy();
		instance.setCallbackHandler(getSeriesType_callback);
		instance.get_series_type(g_seriesId);
	}
	
	function getSeriesType_callback(result) {
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E01" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			document.getElementById("divLoading").style.top = "50px";
			document.getElementById("overlay").style.backgroundColor = "white";
		} else {
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				var series_type = fields[0];
				highlightBtns(series_type);
			}
		}
		showLoadingDiv(false, "");
	}
	
	function highlightBtns(strType) {
		clearBtns();
		document.getElementById("btnType_" + strType).style.backgroundColor = "#FF9800";
		showLink(strType);
	}
	
	function clearBtns() {
		document.getElementById("btnType_Standard").style.backgroundColor = "#263248";
		document.getElementById("btnType_Multi-Class").style.backgroundColor = "#263248";
		document.getElementById("btnType_Teams").style.backgroundColor = "#263248";
	}
	
	function doClickSeriesTypeBtn(strType) {
		highlightBtns(strType);
		doSave(strType);
	}
	
	function showLink(strType) {
		// first hide all links
		document.getElementById("divEditTeams").style.display = "none";
		document.getElementById("divEditClasses").style.display = "none";
		
		var sel = document.getElementById("selSeriesType");
		
		if(strType == "Teams") {
			document.getElementById("divEditTeams").style.display = "";
		} else if(strType == "Multi-Class") {
			document.getElementById("divEditClasses").style.display = "";
		}
	}
	
	function doSave(strType) {
		showLoadingDiv(true, "Saving...");
		document.getElementById("divLoading").style.top = "50px";
		document.getElementById("overlay").style.backgroundColor = "white";
		
		
		var instance = new admin_proxy();
		instance.setCallbackHandler(doSave_callback);
		instance.save_series_type(g_seriesId, strType);
	}
	
	function doSave_callback(result) {
		showLoadingDiv(false, "");
		
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E02" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
			document.getElementById("divLoading").style.top = "50px";
			document.getElementById("overlay").style.backgroundColor = "white";
		} else if(rows[0] == "good") {
			//doCancel();
		}
	}
	
	function doCancel() {
		parent.closeSeriesTypeDlg();
	}
	
	function editTeams() {
		// redirect to the edit teams screen
		window.location.href = "admin_edit_teams.cfm?series=" + g_seriesId + "&type=t";
		// make the dlg taller
		var frame = parent.document.getElementById("frameDialog");
		frame.style.height = "400px";//ptsHeight+"px";
		// change the title of the dialog
		parent.document.getElementById("spanDialogName").innerHTML = "Edit Teams";
	}
	
	function editClasses() {
		// redirect to the edit teams screen
		window.location.href = "admin_edit_teams.cfm?series=" + g_seriesId + "&type=mc";
		// make the dlg taller
		var frame = parent.document.getElementById("frameDialog");
		frame.style.height = "400px";//ptsHeight+"px";
		// change the title of the dialog
		parent.document.getElementById("spanDialogName").innerHTML = "Edit Classes";
	}
	

</script>
</head>
<body onload="init()">
<cfinclude template="include/overlay-alert.cfm">

<br /><br />
<div style="width:100%;" align="center" id="pageContainer">
	
	<input type="button" class="btn_SeriesType" name="btnType_Standard" id="btnType_Standard" value="Standard" onclick="doClickSeriesTypeBtn(this.value);" />
	&nbsp;
	<input type="button" class="btn_SeriesType" name="btnType_Multi-Class" id="btnType_Multi-Class" value="Multi-Class" onclick="doClickSeriesTypeBtn(this.value);" />
	&nbsp;
	<input type="button" class="btn_SeriesType" name="btnType_Teams" id="btnType_Teams" value="Teams" onclick="doClickSeriesTypeBtn(this.value);" />
	
	
	
	
	<div style="font-size:15px;">&nbsp;</div>
	
	<span id="divEditTeams" style="display:none;" class="spanEditBtn">
		<a href="javascript:editTeams();">Edit Teams</a>
	</span>
	
	<span id="divEditClasses" style="display:none;" class="spanEditBtn">
		<a href="javascript:editClasses();">Edit Classes</a>
	</span>
</div>


	
</body>
</html>