<cfajaxproxy cfc="admin_races_results_server" jsclassname="admin_proxy" />
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
<title>Racing Club Manager | Admin Series Races Results</title>
<link href='http://fonts.googleapis.com/css?family=Monda:400' rel='stylesheet' type='text/css'>
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
	
	#txtClubName {
		width: 20em;
	}
	
	#selPersonality {
		width: 20em;
	}
	
	#divEditor {
		position: absolute;
		top: 200px;
	}
	
	#txtSeriesName {
		width: 15em;
	}
	
	#selPts {
		width: 15em;
	}
	
	#divSeriesData {
		background-color: #263248;
	}
	
	#divSeriesData td {
		color: #fff;
	}
	
	.adminSeriesRow {
		background-color: #263248;
	}

	.adminSeriesRow a {
		color: #fff;
		text-decoration: none;
	}
	
	.adminRacesRow {
		background-color: #7E8AA2;
		border-bottom: 2px solid white;
		margin-left: 10px;
	}

	.adminRacesRow a {
		color: #fff;
		text-decoration: none;
	}
	
	#divRaceData {
		background-color: #7E8AA2;
	}
	
	#divRaceData td {
		color: #fff;
	}
	
	#divResults {
		background-color: #7E8AA2;
	}
	
	#divResults td {
		color: #fff;
		/*font-size: 9pt;*/
	}
	
	#divResults select,input {
		/*font-size: 9pt;*/
	}
	
	.teamAbbr {
		color: #555;
		font-style:italic;
	}
	
	#linkQualifying {
		color: #fff;
		text-decoration: underline;
	}
	
	.infoBtn {
		cursor:pointer;
	}
	
	.resultsInput {
		width:100%;
	}
	
	#divRaceOptions {
	}
	
	#raceOptionsContainer {
		position:relative;
		top: -76px;
		height: 120px;
	}
	
	.raceOptions {
		padding:7px;
		background-color: #fff;
		border-bottom: 1px solid #ddd;
		color: #000;
		cursor:pointer;
	}
	
	.raceOptions:hover {
		background-color: #FF9800;
	}
	
	.raceRow {
		height: 50px;
		color:white;
		cursor:pointer;
		font-size: 12pt;
	}
	
	.seriesRow {
		height: 50px;
		color:white;
		cursor:pointer;
		font-size: 12pt;
	}
	
	#divExcludeMsg {
		color: white;
		padding-left: 5px;
	}
	
	#linkAddNewSeries {
		background-color:#263248;
		padding:5px;
		color:#FF9800;
		text-decoration:underline;
		font-size: 12pt;
	}
	
	<cfinclude template="include/nav_list.cfm" />
</style>
<link rel="stylesheet" href="include/datepicker/style.css">
<script src="include/datepicker/jquery_1_10_2.js"></script>
<script src="include/datepicker/jquery_ui.js"></script>
<script src="include/ckeditor_basic/ckeditor.js"></script>
<script language='javascript' src='common.js'></script>
<script type="text/javascript">
	if(!String.prototype.trim) {
		String.prototype.trim=function(){return this.replace(/(?:(?:^|\n)\s+|\s+(?:$|\n))/g,'').replace(/\s+/g,' ');};
	}
	
	$(window).resize(function () { doResize() });
	
	var g_arrTracks = [];
	var g_arrRacers = [];
	var g_arrPtsTemplates = [];
	var g_arrRaces = [];
	var g_arrSeries = [];
	var blnDoingInit = true;
	var g_descType = "";
	var g_descId = -1;
	var g_CKloaded = false;
	var g_seriesId = -1;
	var g_raceId = -1;
	var g_showRaceData = 0;
	var g_arrResults = [];
	var g_racerListRefresh = false;
	var g_arrMCResults = [];
	var g_arrSelectedAvail = [];
	var g_usingTemplateIdFromDlg = 0;
	var g_raceExcluded = false;
	var showingRaceData = false;
	
	var g_raceLenType = "Distance";
	var g_distUnitType = "laps";
	
	var startColumnIdx = 4;
	var fastestColumnIdx = 5;
	var overallColumnIdx = 6;
	var distanceColumnIdx = 7;

	var g_chunkSize = 750;
	var g_chunkIdx = -1;
	var g_chunks = [];
	
	function init() {
		
		
		showLoadingDiv(true, "Loading...");
		loadCK();
		loadDatepicker();
		doResize();
		
		
		  
		getTracks();
	}
	
	function doResize() {
		resizeContainer();
		resizeSeriesData();
		resizeOverlay();
	}
	
	function resizeContainer() {
		var docWidth = parseInt(document.body.clientWidth);
		if(docWidth <= 750) {
			document.getElementById("divContainer").style.width = (750*.9)+"px";
			document.getElementById("divAddNew").style.width = (750*.9)+"px";
		} else if(docWidth >= 1000) {
			document.getElementById("divContainer").style.width = (1000*.9)+"px";
			document.getElementById("divAddNew").style.width = (1000*.9)+"px";
		} else {
			document.getElementById("divContainer").style.width = "90%";
			document.getElementById("divAddNew").style.width = "90%";
		}
	}
	
	function resizeSeriesData() {
		// nothing
	}
	
	function getTracks() {
		g_arrTracks = []; // reset tracks array
		var instance = new admin_proxy();
		instance.setCallbackHandler(getTracks_callback);
		instance.get_tracks();
	}
	
	function getTracks_callback(result) {
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E01" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		} else {
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				g_arrTracks.push(fields); // store tracks in a global array so we can get them whenever we want without making another ajax call
			}
			
			fillTracks();
			//getRacers();
			getRacers_callback("");
		}
	}
	
	function fillTracks() {
		var sel = document.getElementById("selTracks");
		
		for(var i=0; i<g_arrTracks.length; i++) {
			var opt = document.createElement("option");
			opt.value = g_arrTracks[i][0];
			sel.appendChild(opt);
			sel.options[sel.options.length-1].innerHTML = g_arrTracks[i][1];
		}
	}
	
	function getRacers() {
		//console.log("get racers");
		g_arrRacers = [];
		var instance = new admin_proxy();
		instance.setCallbackHandler(getRacers_callback);
		instance.get_admin_racers(g_raceId);
	}
	
	function getRacers_callback(result) {
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E02" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		} else {
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				g_arrRacers.push(fields);
			}
			
			//we would want to call getRacers in places other than just init
			// so if we are still doing our init sequence, don't refresh racers
			if(blnDoingInit) { 
				fillAvailRacers();
				getPtsTemplates();
			} else {
				fillAvailRacers();
			}
		}
	}
	
	function getPtsTemplates() {
		g_arrPtsTemplates = [];
		var instance = new admin_proxy();
		instance.setCallbackHandler(getPtsTemplates_callback);
		instance.get_points_templates();
	}
	
	function getPtsTemplates_callback(result) {
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E03" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		} else {
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				g_arrPtsTemplates.push(fields);
			}
			
			fillPtsTemplates();
			
			if(blnDoingInit) { 
				blnDoingInit = false;
				getSeries();
			}
		}
	}
	
	function fillPtsTemplates() {
		var sel = document.getElementById("selPts");
		sel.options.length = 1; // clear the options except the 1 default
		
		for(var i=0; i<g_arrPtsTemplates.length; i++) {
			var opt = document.createElement("option");
			opt.value = g_arrPtsTemplates[i][0];
			sel.appendChild(opt);
			sel.options[sel.options.length-1].innerHTML = decodeString(g_arrPtsTemplates[i][1].trim());
			
			// select the template if we are using it
			if(parseInt(g_usingTemplateIdFromDlg) > 0 && parseInt(g_arrPtsTemplates[i][0]) == parseInt(g_usingTemplateIdFromDlg)) {
				sel.selectedIndex = i+1; // plus 1 because the sel has an extra option for "--select template--"
				
				// need to set the template id into the g_arrSeries array because we don't refresh that data.
				var arrIdx = getSeriesArrIdx(g_seriesId);
				if(arrIdx > -1) {
					g_arrSeries[arrIdx][2] = parseInt(g_usingTemplateIdFromDlg);
				}
				
				g_usingTemplateIdFromDlg = 0;
			}
		}
	}
	
	function getSeries() {
		g_arrSeries = [];
		cleanupDivContainer();
		var instance = new admin_proxy();
		instance.setCallbackHandler(getSeries_callback);
		instance.get_admin_series();
	}
	
	function getSeries_callback(result) {
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E04" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		} else {
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				g_arrSeries.push(fields);
			}
		}
		
		showSeriesRows();
	}
	
	function showSeriesRows() {
		var arr = g_arrSeries;
		var divContainer = document.getElementById("divContainer");
		
		for(var i=0; i<g_arrSeries.length; i++) {
			// for each series record
			var thisSeriesRecord = g_arrSeries[i];
			var div = document.createElement("div");
			//div.className = "dataHeaderBG";
			div.style.borderBottom = "2px solid white";
			div.id = "divSeries_" + thisSeriesRecord[0];
			var tbl = createSeriesTable(thisSeriesRecord);
			div.appendChild(tbl);
			divContainer.appendChild(div);
		}
		
		showLoadingDiv(false, "");
		g_getSeriesDone = true; // only used to expand nodes after save
		
		if(g_showRaceData > 0 && !showingRaceData) {
			showingRaceData = true;
			doSelSeries(g_seriesId);
		}
		
	}
	
	function createSeriesTable(thisSeriesRecord) {
		var series_id = thisSeriesRecord[0];
		var series_name = decodeString(thisSeriesRecord[1].trim());
		
		var tbl = document.createElement("table");
		tbl.width = "100%";
		tbl.cellSpacing = "0";
		tbl.cellPadding = "3";
		tbl.border = "0";
		
		var row = document.createElement("tr");
		row.className = "adminSeriesRow";
		
		var cell = document.createElement("td");
		cell.align = "left";
		cell.className = "seriesRow";
		//cell.innerHTML = " <a href='javascript:doSelSeries(" + series_id + ");' style='text-decoration:none;'>&#9662; " + series_name + "</a>";
		cell.innerHTML = "&#9662; " + series_name;
		
		if (cell.addEventListener) {  // all browsers except IE before version 9
			cell.addEventListener("click", function() { doSelSeries(series_id); }, false);
		} else {
			if (cell.attachEvent) {   // IE before version 9
				cell.attachEvent("click", function() { doSelSeries(series_id); });
			}
		}
		
		row.appendChild(cell);
		
		cell = document.createElement("td");
		cell.align = "right";
		cell.valign = "middle";
		var strHTML = "<span id='spanIconsForSeries_" + series_id + "' style='display:none;'>";
		   strHTML += "<img src='imgs/delete-icon.png' onclick='deleteSeries();' style='cursor:pointer;' title='Click here to delete this series' />";
		   strHTML += " <img src='imgs/add_race.png' onclick='addRaceToSeries(" + series_id + ");' style='cursor:pointer;' title='Click here to add a new race to this series' />";
		   strHTML += " <img src='imgs/start-grid-ico.png' onclick='toggleQualifying();' id='imgStartGrid_" + series_id + "'  style='cursor:pointer;' height='20' title='Click here to toggle qualifying/starting position' />";
		   strHTML += " <img src='imgs/edit_desc2.png' onclick='editDesc(true, \"series\", " + series_id + ");' style='cursor:pointer;' title='Click here to edit the Series Description' />";
		   strHTML += " <img src='imgs/save_icon.png' onclick='saveSeries(" + series_id + ");' style='cursor:pointer;' title='Click here to save the Series data' height='20' />";
		   strHTML += "</span>";
		cell.innerHTML = strHTML;
		row.appendChild(cell);
		
		tbl.appendChild(row);
		
		return tbl;
	}
	
	function cleanupDivContainer() {
		removeDiv("divSeriesData");
		removeDiv("divRaceData");
		removeDiv("divResults");
		document.getElementById("divContainer").innerHTML = "";
	}
	
	function doSelSeries(series_id) {
		g_raceId = 0;
		g_usingTemplateIdFromDlg = 0;
		cleanupDivContainer() ;
		showSeriesRows();
		
		g_seriesId = series_id;
		
		var thisSeriesObj = document.getElementById("divSeries_"+series_id);
		var divSeriesData = document.getElementById("divSeriesData");
		var icon = document.getElementById("spanIconsForSeries_" + series_id);
		thisSeriesObj.appendChild(divSeriesData);
		divSeriesData.style.display = "";
		fillSeriesData(series_id);
		hideAllSeriesIcons();
		icon.style.display = "";
		getRacesInSeries(series_id);
	}
	
	function fillSeriesData(series_id) {
		clearSeriesData();
		var arrIdx = getSeriesArrIdx(series_id);
		if(arrIdx > -1) {
			setSeriesName(decodeString(g_arrSeries[arrIdx][1].trim()));
			setPtsTemplate(parseInt(g_arrSeries[arrIdx][2]));
			setSeriesType(series_id, g_arrSeries[arrIdx][3]);
			setQualifyingLink(g_arrSeries[arrIdx][4]);
		} else {
			var errMsg = "This page encountered an error: E05" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		}
	}
	
	function setSeriesName(str) {
		document.getElementById("txtSeriesName").value = str;
	}
	
	function setPtsTemplate(template_id) {
		var sel = document.getElementById("selPts");
		if(template_id == -1) {
			sel.selectedIndex = 0;
		} else {
			for(var i=0; i<sel.options.length; i++) {
				if(sel.options[i].value == template_id) {
					sel.selectedIndex = i;
					return;
				}
			}
		}
	}
	
	function setSeriesType(series_id, type) {
		var span = document.getElementById("spanSeriesType");
		
		var typeText = type;
		if(type == "Teams") {
			typeText = "Edit Type/Edit Teams";
		} else if(type == "Multi-Class") {
			typeText = "Edit Type/Edit Classes";
		}
		var linkType = "&nbsp;&nbsp;&nbsp;<a href='javascript:openSeriesTypeDlg(" + series_id + ");' style='color:#fff;text-decoration:underline;'>" + typeText + "</a>";
		
		span.innerHTML = linkType;
	}
	
	function openSeriesTypeDlg(series_id) {
		var frame = document.getElementById("frameDialog");
		var dlg = document.getElementById("divDialog");

		dlg.style.display = "";
		frame.src = "admin_series_type.cfm?series=" + series_id;
		frame.style.height = "250px";//ptsHeight+"px";
		dlg.style.top = parseInt(getDlgTop())/2+"px";
		
		document.getElementById("spanDialogName").innerHTML = "Edit Series Type";
		document.getElementById("linkDialogClose").setAttribute("onclick", "closeSeriesTypeDlg()");
		showOverlay(true);
	}
	
	function closeSeriesTypeDlg() {
		var frame = document.getElementById("frameDialog");
		frame.src = "";
		displayId('divDialog', 'none');
		showOverlay(false);
		getSeries();
	}
	
	function getSeriesArrIdx(series_id) {
		for(var i=0; i<g_arrSeries.length; i++) {
			if(g_arrSeries[i][0] == series_id) {
				return i;
			}
		}
		
		return -1;
	}
	
	function clearSeriesData() {
		setSeriesName("");
		setPtsTemplate(-1);
	}

	function removeDiv(objId) {
		var div = document.getElementById(objId);
		document.body.appendChild(div);
		div.style.display = "none";
	}
	
	function getRacesInSeries(series_id) {
		// get list of races for this series
		g_arrRaces = [];
		var instance = new admin_proxy();
		instance.setCallbackHandler(getRacesInSeries_callback);
		instance.get_admin_races(series_id);
	}
	
	function getRacesInSeries_callback(result) {
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E06" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		} else {
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				g_arrRaces.push(fields);
				
				var seriesDiv = document.getElementById("divSeries_"+g_seriesId);
				var div = document.createElement("div");
				div.className = "adminRacesRow";
				div.id = "divRace_" + fields[0];
				var tbl = createRaceTable(fields[0], decodeString(fields[1].trim()));
				div.appendChild(tbl);
				seriesDiv.appendChild(div);
			}
			
			if(g_showRaceData > 0) {
				showRaceData(g_showRaceData);
				g_showRaceData = 0; // reset the global var
				showingRaceData = false;
			}
		}
	}
	
	function createRaceTable(race_id, race_name) {
		var series_id = g_seriesId;
		
		var tbl = document.createElement("table");
		tbl.width = "100%";
		tbl.cellSpacing = "0";
		tbl.cellPadding = "3";
		tbl.border = "0";
		
		var row = document.createElement("tr");
		row.className = "adminRacesRow";
		
		var cell = document.createElement("td");
		cell.align = "left";
		cell.className = "raceRow";
		cell.innerHTML = "&#9662; " + race_name;
		
		if (cell.addEventListener) {  // all browsers except IE before version 9
			cell.addEventListener("click", function() { showRaceData(race_id); }, false);
		} else {
			if (cell.attachEvent) {   // IE before version 9
				cell.attachEvent("click", function() { showRaceData(race_id); });
			}
		}
		
		row.appendChild(cell);
		
		/*
		cell = document.createElement("td");
		cell.align = "left";
		cell.valign = "middle";
		cell.width = "100";
		
		var strHTML = "<div id='spanIconsForRace_" + race_id + "'>&nbsp;</div>"
		cell.innerHTML = strHTML;
		
		row.appendChild(cell);
		*/
		
		tbl.appendChild(row);
		
		return tbl;
	}
	
	function showRaceData(race_id) {
		g_raceId = race_id;
		var thisRaceObj = document.getElementById("divRace_"+race_id);
		var divRaceData = document.getElementById("divRaceData");
		var divResults = document.getElementById("divResults");
		thisRaceObj.appendChild(divRaceData);
		thisRaceObj.appendChild(divResults);
		divRaceData.style.display = "";
		divResults.style.display = "";
		resetSelectedAvail();
		fillRaceData(race_id); // fill the data for this race
		getResults(race_id, ''); // get the results for this race
	}
	
	function resetSelectedAvail() {
		g_arrSelectedAvail = [];
		var tbl = document.getElementById("tblAvailRacers");
		
		for(var i=0; i<tbl.rows; i++) {
			tbl.row[i].backgroundColor = "white";
		}
	}
	
	function hideAllSeriesIcons() {
		for(var i=0; i<g_arrSeries.length; i++) {
			var icon = document.getElementById("spanIconsForSeries_" + g_arrSeries[i][0]);
			icon.style.display = "none";
		}
	}
	
	function fillRaceData(race_id) {
		clearRaceData();
		var arrIdx = getRaceArrIdx(race_id);
		if(arrIdx > -1) {
			setRaceName(decodeString(g_arrRaces[arrIdx][1].trim()));
			setTrack(parseInt(g_arrRaces[arrIdx][2]));
			setLengthType(g_arrRaces[arrIdx][3]);
			setLengthValue(g_arrRaces[arrIdx][4]);
			setDistanceUnits(g_arrRaces[arrIdx][5]);
			setRaceDate(UTC2Local(g_arrRaces[arrIdx][6]));
			showExcludeMsg(parseInt(g_arrRaces[arrIdx][7]));
		} else {
			var errMsg = "This page encountered an error: E07" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		}
	}
	
	function showExcludeMsg(intIncluded) {
		if(!intIncluded) {
			var img = "<img src='imgs/warning_small.png' width='16' height='16' title='Attention!' />&nbsp;";
			document.getElementById("divExcludeMsg").innerHTML = img + "This race has been excluded when calculating final results for this series.";
			g_raceExcluded = true;
		} else {
			document.getElementById("divExcludeMsg").innerHTML = "&nbsp;";
			g_raceExcluded = false;
		}
		
		showCorrectExclude();
	}
	
	function showCorrectExclude() {
		var divRaceOptions = document.getElementById("divRaceOptions");
		var divExclude = document.getElementById("divExcludeLink");
		
		if(divRaceOptions.style.display == "") { // can only set html if outer div is showing
			if(g_raceExcluded) {
				divExclude.innerHTML = "Include...";
			} else {
				divExclude.innerHTML = "Exclude...";
			}
		}
	}
	
	function clearRaceData() {
		setRaceName("");
		setTrack(-1);
		//setLaps(0);
		setLengthType("");
		setLengthValue("");
		setDistanceUnits("");
		setRaceDate("");
	}
	
	function setRaceName(str) {
		document.getElementById("txtRaceName").value = str;
	}
	
	function setTrack(intTrackId) {
		var sel = document.getElementById("selTracks");
		if(intTrackId == -1) {
			sel.selectedIndex = -1;
		} else {
			for(var i=0; i<sel.options.length; i++) {
				if(parseInt(sel.options[i].value) == intTrackId) {
					sel.selectedIndex = i;
					return;
				}
			}
		}
	}
	
	function setLengthType(strType) {
		g_raceLenType = strType;
		
		var sel = document.getElementById("selRaceLen");
		
		if(strType.length <= 0) {
			sel.selectedIndex = 0;
		}
		
		for(var i=0; i<sel.options.length; i++) {
			if(sel.options[i].value == strType) {
				sel.selectedIndex = i;
				break;
			}
		}
		
		onChangeRaceLength();
	}
	
	function setLengthValue(strValue) {
		if(g_raceLenType == "Time") {
			// parse the time value and remove empty hours
			formatRaceTimes(strValue);
		} else {
			if(strValue.indexOf(".") > 0) {
				if(parseInt(strValue.split(".")[1]) == 0) {
					strValue = strValue.split(".")[0];
				}
			}
		}
		
		var txt = document.getElementById("txtDistVal").value = strValue;
	}
	
	function formatDistanceTraveled(strValue) {
		// distance is a decimal(9,3)
		var decimal = "000";
		var integer = "0";
		
		if(strValue.indexOf(",") >= 0) {
			var errMsg = "" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		}
		
		if(strValue.indexOf(".") >= 0) {
			integer = parseInt(strValue.split(".")[0]);
			if(isNaN(integer)) {
				integer = "0";
			}
			
			if(isNaN(strValue.split(".")[1])) {
				decimal = "000";
			} else {
				decimal = padEnd(strValue.split(".")[1], "000");
			}
		} else {
			integer = parseInt(strValue);
			if(isNaN(integer)) {
				integer = 0;
			} else if(integer > 999999) {
				var errMsg = "If your distance value is 1 million units or greater then I applaud you, but we don't support that.<br />If you're using ft or m, convert to miles or km and try this again." + dlgCloseBtn;
				showLoadingDiv(true, errMsg);
				integer = 0;
			}
		}

		return integer.toString() + "." + decimal.toString();
	}
	
	function formatRaceTimes(strValue) {
		var ms = "000";
		var valArr = [];
		if(strValue.split(".").length == 2) {
			ms = padFront(validateNum(strValue.split(".")[1]),"000");
			valArr = strValue.split(".")[0].split(":");
		} else {
			valArr = strValue.split(":");
		}
		
		var hours = "00";
		var minutes = "00";
		var seconds = "00";
		if(valArr.length == 3) {
			hours = padFront(validateNum(valArr[0]), "00");
			minutes = padFront(validateNum(valArr[1]), "00");
			seconds = padFront(validateNum(valArr[2]), "00");
		} else if(valArr.length == 2) {
			minutes = padFront(validateNum(valArr[0]), "00");
			seconds = padFront(validateNum(valArr[1]), "00");
		} else {
			var strArr = valArr[0].split("");
			
			switch(strArr.length) {
				case 6:
					hours   = padFront(validateNum(strArr[0].toString() + strArr[1].toString()), "00");
					minutes = padFront(validateNum(strArr[2].toString() + strArr[3].toString()), "00");
					seconds = padFront(validateNum(strArr[4].toString() + strArr[5].toString()), "00");
					break;
				case 5:
					hours   = padFront(validateNum(strArr[0]), "00");
					minutes = padFront(validateNum(strArr[1].toString() + strArr[2].toString()), "00");
					seconds = padFront(validateNum(strArr[3].toString() + strArr[4].toString()), "00");
					break;
				case 4:
					minutes = padFront(validateNum(strArr[0].toString() + strArr[1].toString()), "00");
					seconds = padFront(validateNum(strArr[2].toString() + strArr[3].toString()), "00");
					break;
				case 3:
					minutes = padFront(validateNum(strArr[0]), "00");
					seconds = padFront(validateNum(strArr[1].toString() + strArr[2].toString()), "00");
					break;
				case 2:
					seconds = padFront(validateNum(strArr[0].toString() + strArr[1].toString()), "00");
					break;
				case 1:
					seconds = padFront(validateNum(strArr[0]), "00");
					break;
				case 0:
					break;
				default:
					var errMsg = "Times must be entered in the following format: 00:00:00.000 or you can enter it without ':' and we'll try to format it correctly." + dlgCloseBtn;
					showLoadingDiv(true, errMsg);
			}
			
			
			
			
		}
		
		if(hours == "00") {
			strValue = minutes + ":" + seconds + "." + ms;
		} else {
			strValue = hours + ":" + minutes + ":" + seconds + "." + ms;
		}
		
		return strValue;
	}
	
	function formatTimeHourMin(strValue) {
		var hours = "00";
		var minutes = "00";
		var valArr = [];
		if(strValue.indexOf(":") >= 0) {
			valArr = strValue.split(":");
		} else {
			minutes = validateNum(strValue); // example1: 61
			if(minutes >= 60) {
				hours = parseInt(minutes/60); // example1: 61/60 = parseInt(1.nn)
				minutes = minutes-(hours*60); // example1: 61-1*60 = 1
				valArr = [hours,minutes];
			} else {
				valArr = [minutes];
			}
		}
		
		if(valArr.length == 2) {
			hours = padFront(validateNum(valArr[0]), "00");
			minutes = padFront(validateNum(valArr[1]), "00");
		} else if(valArr.length == 1) {
			minutes = padFront(validateNum(valArr[0]), "00");
		} else {
			var errMsg = "Times must be entered in the following format: hh:mm" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		}
		
		if(minutes > 60) {
			var errMsg = "There is an invalid number of hours and minutes." + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		}
		
		strValue = hours + ":" + minutes;
		
		return strValue;
	}
	
	function validateNum(intVal){ // if intVal is not a number, then return 0
		var strVal = 0;
		if(!isNaN(parseInt(intVal))) {
			strVal = parseInt(intVal)
		}
		
		return strVal;
	}
	
	function padEnd(strVal, strPad) {
		return (strVal + strPad).slice(0,strPad.length);
	}
	
	function padFront(strVal, strPad) {
		return (strPad + strVal).slice(strPad.length*-1);
	}
	
	function setDistanceUnits(strDistUnits) {
		g_distUnitType = strDistUnits;
		
		var sel = document.getElementById("selDistUnit");
		
		if(strDistUnits.length <= 0) {
			sel.selectedIndex = 0;
		}
		
		for(var i=0; i<sel.options.length; i++) {
			if(sel.options[i].value == strDistUnits) {
				sel.selectedIndex = i;
				break;
			}
		}
		
		onChangeDistUnit();
	}
	
	function setRaceDate(strRaceDate) {
		var objDate = document.getElementById("datepicker");
		var objHour = document.getElementById("selHour");
		var objMins = document.getElementById("selMins");
		var objAMPM = document.getElementById("selAMPM");

		if(strRaceDate == "") {
			objDate.value = "";
			objHour.selectedIndex = 0;
			objMins.selectedIndex = 0;
			objAMPM.selectedIndex = 0;
		} else {
			var dt = new Date(strRaceDate);
			var month = padZero(dt.getMonth()+1);
			var day = padZero(dt.getDate());
			var year = dt.getFullYear();
			objDate.value = month + "/" + day + "/" + year;
			var hours = dt.getHours();
			if(hours == 0) { hours = 12; }
			if(hours > 12) {
				hours = hours - 12;
			}
			setTimeSel(objHour, hours);
			setTimeSel(objMins, dt.getMinutes());
			
			if(strRaceDate.substr(strRaceDate.length-2,1) == "A") {
				objAMPM.selectedIndex = 0;
			} else {
				objAMPM.selectedIndex = 1;
			}
		}
	}
	
	function padZero(val) {
		if(parseInt(val) < 10 && val.toString().length < 2) {
			return "0" + val.toString();
		} else {
			return val;
		}
	}
	
	function setTimeSel(sel, strHour) {
		for(var i=0; i<sel.options.length; i++) {
			if(parseInt(sel.options[i].value) == parseInt(strHour)) {
				sel.selectedIndex = i;
				return;
			}
		}
	}

	function getRaceArrIdx(race_id) {
		for(var i=0; i<g_arrRaces.length; i++) {
			if(g_arrRaces[i][0] == race_id) {
				return i;
			}
		}
		
		return -1;
	}
	
	function addRaceToSeries(series_id) {
		var instance = new admin_proxy();
		instance.setCallbackHandler(addRaceToSeries_callback);
		instance.add_new_race(series_id);
	}

	function addRaceToSeries_callback(result) {
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E08" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		} else {
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				if(fields[0] == "good") {
					g_showRaceData = parseInt(fields[1]);
					getSeries();
				} else {
					var errMsg = "This page encountered an error: E09" + dlgCloseBtn;
					showLoadingDiv(true, errMsg);
				}
			}
		}
	}
	
	function addNewSeries() {
		g_raceId = 0;
		var frame = document.getElementById("frameDialog");
		var dlg = document.getElementById("divDialog");

		dlg.style.display = "";
		frame.src = "admin_add_series.cfm";
		frame.style.height = "300px";//ptsHeight+"px";
		dlg.style.top = getDlgTop();
		
		document.getElementById("spanDialogName").innerHTML = "Add New Series";
		document.getElementById("linkDialogClose").setAttribute("onclick", "closeAddNewSeries()");
		showOverlay(true);
	}
	
	function closeAddNewSeries() {
		var frame = document.getElementById("frameDialog");
		frame.src = "";
		document.getElementById("divDialog").style.display = "none";
		showOverlay(false);
		getSeries();
	}
	
	function addNewSeries_callback(result) {
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E10" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		} else {
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				if(fields[0] == "good") {
					// pull out new series id and store it globally
					g_showSeriesData = parseInt(fields[1]);
					// refresh all series
					getSeries();
				} else {
					var errMsg = "This page encountered an error: E11" + dlgCloseBtn;
					showLoadingDiv(true, errMsg);
				}
			}
		}
	}
	
	function manageTemplates(bln) {
		var frame = document.getElementById("frameDialog");
		if(bln) {
			var ptsHeight = parseInt(screen.availHeight)/1.5;
			var dlg = document.getElementById("divDialog");

			dlg.style.display = "";
			frame.src = "admin_templates.cfm?series=" + g_seriesId;
			frame.style.height = ptsHeight+"px";
			dlg.style.top = getDlgTop();
			
			document.getElementById("spanDialogName").innerHTML = "Points Templates";
			document.getElementById("linkDialogClose").setAttribute("onclick", "manageTemplates(false)");
			showOverlay(true);
		} else {

			for(var i=0; i<frames.length; i++) {
				if(frames[i].location.pathname.indexOf("admin_templates") > -1) {
					var selPts = document.getElementById("selPts");
					var currTemplateId = parseInt(selPts.options[selPts.selectedIndex].value);
					if(parseInt(frames[i].getTemplateId()) > 0 && parseInt(frames[i].getTemplateId()) != parseInt(currTemplateId) && frames[i].getTemplateName() != "") {
						if(confirm("Would you like to use the template '" + frames[i].getTemplateName() + "' in this series?")) {
							g_usingTemplateIdFromDlg = frames[i].getTemplateId();
							frames[i].saveTemplateToSeries();
						} else {
							g_usingTemplateIdFromDlg = currTemplateId;
						}
					} else {
						g_usingTemplateIdFromDlg = currTemplateId;
					}
				}
			}
			
			frame.src = "";
			displayId('divDialog', 'none');
			showOverlay(false);
			getPtsTemplates();
		}
	}
	
	function editDesc(bln, strType, id) {
		// we need a div dialog with a ckeditor in it and a save button
		g_descType = strType;
		g_descId = id;
		
		showEditorDlg(bln);
		
		if(strType == "series" || strType == "race") {
		
			if(strType == "race" && g_descId == 0) {
				g_descId = g_raceId;
			}
		
			var instance = new admin_proxy();
			instance.setCallbackHandler(getAdminDesc_callback);
			instance.get_admin_desc(strType, g_descId);
		}
	}
	
	function getAdminDesc_callback(result) {
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E12" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		} else {
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				var desc = decodeString(fields[0].trim());
				CKEDITOR.instances.textarea_1.setData(desc);
			}
		}
	}
	
	function showEditorDlg(bln) {
		if(bln) {
			displayId("divEditor", ""); // show editor dlg
		} else {
			CKEDITOR.instances.textarea_1.setData("");
			displayId("divEditor", "none"); // hide editor dlg
		}
		
		showOverlay(bln);
	}

	function loadCK() {
		if(!g_CKloaded) {
			CKEDITOR.replace( 'textarea_1', {
				width: 600,
				height: 500
			});
			g_CKloaded = true;
		}
	}
	
	function loadDatepicker() {
		$(function() {
			$( "#datepicker" ).datepicker();
		});
		
		document.getElementById("datepicker").readOnly = true;
	}
	
	
	function appendErrMsg(errMsg, str) {
		if(errMsg.length > 0) {
			errMsg += "<br />";
		}
		
		return(errMsg += str);
	}
	
	function saveDesc_setup() {
		//get club description
		CKEDITOR.instances.textarea_1.updateElement();
		var desc = document.getElementById("textarea_1").value;
		desc = encodeSpaces(desc);
		if(desc.length > 0) {
			chunkDesc(desc);
		}
		showEditorDlg(false);
		saveDesc_execute("good");
	}
	
	function chunkDesc(str) {
		g_chunks = [];
		if(str.length > 0) {

			var timesToLoop = Math.ceil(str.length/g_chunkSize);
			var start = 0;
			var go = 0;
			for(var i=0; i<timesToLoop; i++) {
				go = g_chunkSize; // the number of chars we want to push always starts with x chars
				var tempStringToPush = str.substr(start, go); // get the string we want to try to push
				while(tempStringToPush.charAt(tempStringToPush.length-1) == " ") { // if the last char is a space, get the next non space char
					go++;
					tempStringToPush = str.substr(start, go); // get new string to push after the space character
				}
				
				g_chunks.push(tempStringToPush); // push the string into array
				start = start + go; // set start to start + go so we start where we left off
			}
			
			g_totalChunks = g_chunks.length;
			
		} else {
			return;
		}
	}
	
	function saveDesc_execute(result) {
		if(result.length > 0) {
			if(result == "good") {
				if(g_chunks.length > 0) {
					// we know to keep going if there are still items left in the array
					g_chunkIdx++;
					var strToSave = g_chunks[0]; // extract the first item in array
					g_chunks.shift(); // now remove that first item from array
					showLoadingDiv(true, "Saving <br />" + getProgressBar(g_totalChunks, g_chunks.length)); // show the progress bar
					var instance = new admin_proxy();
					instance.setCallbackHandler(saveDesc_execute); // callback to itself
					instance.save_admin_desc(strToSave, g_chunkIdx, g_descType, g_descId);
				} else if(result == "sessionError") {
					var errMsg = "Your session has ended. Make sure to copy your changes before leaving or refreshing this page or they will be lost." + dlgCloseBtn;
					showLoadingDiv(true, errMsg);
				} else {
					// we are done
					g_chunkIdx = -1;
					showLoadingDiv(false, "");
				}
			} else {
				var errMsg = "This page encountered an error: E13" + dlgCloseBtn;
				showLoadingDiv(true, errMsg);
			}
		} else {
			var errMsg = "This page encountered an error: E14" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		}
	}
	
	function appendErrMsg(errMsg, str) {
		if(errMsg.length > 0) {
			errMsg += "<br />";
		}
		
		return(errMsg += str);
	}
	
	function saveSeries(series_id) {
		var errMsg = "";
		
		// series name
		var series_name = document.getElementById("txtSeriesName").value.trim();
		if(series_name.length <= 0) {
			errMsg = appendErrMsg(errMsg, "You need to enter a name for this series.");
		}
		
		// points template
		var sel = document.getElementById("selPts");
		var pts_id = 0;
		if(sel.selectedIndex <= 0) {
			errMsg = appendErrMsg(errMsg, "You need to select a points template.");
		} else {
			pts_id = sel.options[sel.selectedIndex].value;
		}
		
		if(errMsg.length > 0) {
			errMsg = "The following issues were encountered:<br />" + appendErrMsg(errMsg, "<br /><input type='button' onclick='showLoadingDiv(false, \"\")' value='Close' />");
			showLoadingDiv(true, errMsg);
		} else {
			var instance = new admin_proxy();
			instance.setCallbackHandler(saveSeries_callback);
			instance.save_admin_series_data(series_id, series_name, pts_id);
		}
	}
	
	function saveSeries_callback(result) {
		var rows = getRows(result);
			
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E15" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		} else {
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				if(fields[0] == "good") {
					errMsg = "Series Saved.<br />";
					if(g_raceId > 0) {
						errMsg += "Would you like to save the race data next?<br />";
						errMsg += "<input type='button' onclick='showLoadingDiv(false, \"\");saveRace(" + g_raceId + ");' value='Yes' />";
						errMsg += "&nbsp;<input type='button' onclick='showLoadingDiv(false, \"\");getSeries();' value='No' />";
						showLoadingDiv(true, errMsg);
					} else {
						getSeries();
						return;
					}
				} else {
					errMsg = "This page encountered an error: E16" + dlgCloseBtn;
					showLoadingDiv(true, errMsg);
				}
			}
		}
	}
	
	function validateDistVal(obj, distVal) {
		distVal = formatDistVal(distVal);
		
		if(distVal == "") {
			var errMsg = "This page encountered an error: E16.1" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		}
		
		if(distVal.indexOf(".") > 0) {
			if(parseInt(distVal.split(".")[1]) == 0) {
				distVal = distVal.split(".")[0];
			}
		}
		
		obj.value = distVal;
	}
	
	function formatDistVal(distVal) {
		var selRaceLen = document.getElementById("selRaceLen");
		var race_len_type = selRaceLen.options[selRaceLen.selectedIndex].value;
		if(race_len_type == "Distance") {
			// make sure distance only contains ints and at most 1 decimal. 000000.000
			return formatDistanceTraveled(distVal);
		} else if(race_len_type == "Time") {
			// time must be formatted as hh:mm
			return formatTimeHourMin(distVal);
		} else {
			return "";
		}
	}
	
	function saveRace(race_id) {
		var errMsg = "";
		// race name
		var race_name = document.getElementById("txtRaceName").value.trim();
		if(race_name.length <= 0) {
			errMsg = appendErrMsg(errMsg, "This race needs a name.");
		}
		
		// get length type - selRaceLen
		var selRaceLen = document.getElementById("selRaceLen");
		var race_len_type = selRaceLen.options[selRaceLen.selectedIndex].value;
		
		// based on length type, get okay value from length value - txtDistVal
		var distVal = document.getElementById("txtDistVal").value;
		distVal = formatDistVal(distVal);
		
		if(distVal == "") {
			errMsg = appendErrMsg(errMsg, "The race length type should be either distance or time.");
		}
		
		// get appropriate value for dist unit - selDistUnit
		var selDistUnit = document.getElementById("selDistUnit");
		var unitMeasureVal = selDistUnit.options[selDistUnit.selectedIndex].value;
		
		// track
		var sel = document.getElementById("selTracks");
		var track_id = 0;
		if(sel.selectedIndex <= -1) {
			errMsg = appendErrMsg(errMsg, "A track must be selected.");
		} else {
			track_id = sel.options[sel.selectedIndex].value;
		}
		
		//race_date
		var race_date;
		if(document.getElementById("datepicker")) {
			race_date = document.getElementById("datepicker").value.trim();
			if(race_date.length <= 0) {
				errMsg = appendErrMsg(errMsg, "A valid date must be entered. Month/Day/Year");
			} else {
				if(isValidDate(race_date)) {
					race_date = formatDateField(race_date);
				} else {
					errMsg = appendErrMsg(errMsg, "A valid date must be entered. Month/Day/Year");
				}
			}
		}
		
		// race time
		if(document.getElementById("selHour") && document.getElementById("selMins") && document.getElementById("selAMPM")) {
			race_date += " " + getSelValue(document.getElementById("selHour")) + ":" + getSelValue(document.getElementById("selMins")) + ":00 " + getSelValue(document.getElementById("selAMPM"));
			dtRace = new Date(race_date);
			
			var hour = dtRace.getUTCHours();
			var strAMPM = "AM";
			if(hour > 12) {
				hour = hour - 12;
				if(hour < 24) {
					strAMPM = "PM";
				}
			}
			race_date = (dtRace.getUTCMonth()+1) + "/" + dtRace.getUTCDate() + "/" + dtRace.getUTCFullYear() + " " + hour + ":" + dtRace.getUTCMinutes() + ":00 " + strAMPM;
			//alert(race_date);
		}
		
		// results
		var strResults = "";
		for(var i=0; i<g_arrResults.length; i++) {
			var racer = g_arrResults[i][0];
			var place = g_arrResults[i][1];
			//var name = g_arrResults[i][2];
			var bonus = g_arrResults[i][3];
			var startPos = g_arrResults[i][4];
			var bestLap = g_arrResults[i][5];
			var overall = g_arrResults[i][6];
			var distance = g_arrResults[i][7];
			var penalty = g_arrResults[i][8];
			if(strResults.length > 0) {
				strResults += ",";
			}
			
			strResults += place + "!" + racer + "!" + bonus + "!" + startPos + "!" + bestLap + "!" + overall + "!" + distance + "!" + penalty;
		}
		
		if(errMsg.length > 0) {
			//alert(errMsg);
			errMsg = "<b>Please review the following issues:</b><br />" + errMsg + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		} else {
			var strQual = g_arrSeries[getSeriesArrIdx(g_seriesId)][4];
			
			var instance = new admin_proxy();
			instance.setCallbackHandler(saveRace_callback);
			instance.save_admin_race_data(g_seriesId, g_raceId, race_name, race_len_type, distVal, unitMeasureVal, track_id, race_date, strResults, strQual);
		}
	}
	
	function saveRace_callback(result) {
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E17" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		} else {
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				if(fields[0] == "good") {
					g_showRaceData = g_raceId;
					getSeries();
				} else if(fields[0] == "templateError") {
					var errMsg = "<b>Warning!</b><br />We saved your data but you have recorded more finishers in the results than are defined in your points template for this series.";
					   errMsg += "<br />Make sure to define more finishers in your template or risk losing your data the next time you save.<br />" + dlgCloseBtn;
					showLoadingDiv(true, errMsg);
				} else {
					var errMsg = "This page encountered an error: E18<br />" + fields[0] + dlgCloseBtn;
					showLoadingDiv(true, errMsg);
				}
			}
		}
	}
	
	function validatePoints(sel) {
		if(sel.selectedIndex > 0) {
			// we need to check that the points template that was selected
			// has a point value entered for every position that has been recorded for each race in the series
			// should probably add a check each time someone is added to the results :)
			var pts_id = sel.options[sel.selectedIndex].value;
			
			var instance = new admin_proxy();
			instance.setCallbackHandler(validatePoints_callback);
			instance.check_admin_points_template(g_seriesId, pts_id);
		}
	}
	
	function validatePoints_callback(result) {
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E19" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		} else {
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				if(fields[0] == "good") {
					// template is okay to use
					return;
				} else if(fields[0] == "issue") {
					document.getElementById("selPts").selectedIndex = 0;
					errMsg = "The template you have selected does not have enough finish positions defined for one or more of the races in this series that had results recorded." + dlgCloseBtn;
					showLoadingDiv(true, errMsg);
				} else {
					var errMsg = "This page encountered an error: E20" + dlgCloseBtn;
					showLoadingDiv(true, errMsg);
				}
			}
		}	
	}
	
	function excludeRace() {
		if(g_raceId > 0) {
			var strExclude = "exclude";
			var strNot = "not";
			var strDoParam = "0"; // 0 = exclude, 1 = include
			
			// if this race is already excluded then show include msg
			if(g_raceExcluded) {
				strExclude = "include";
				strNot = "";
				strDoParam = "1";
			}
			
			var errMsg  = "Are you sure you want to " + strExclude + " this race?<br />This means that the results of this race will " + strNot + " be calculated into the leaderboard for this series.";
				errMsg += "<br /><br /><input type='button' value='Yes' onclick='doExcludeYes(" + strDoParam + ");' />&nbsp;&nbsp;";
				errMsg += "<input type='button' value='No' onclick='showLoadingDiv(false, \"\");' />";
			showLoadingDiv(true, errMsg);
		}
	}
	
	function doExcludeYes(strExclude) {
		showLoadingDiv(true, "Saving...");
		var instance = new admin_proxy();
		instance.setCallbackHandler(excludeRace_callback);
		instance.exclude_race(g_seriesId,g_raceId,parseInt(strExclude));
	}
	
	function excludeRace_callback(result) {
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E20.1" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		} else if(rows[0] == "excludeError") {
			var errMsg = "This page encountered an error: E20.2" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		} else {
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				if(fields[0] == "good") {
					// exclude was successful, show correct exclude/include
					var arrIdx = getRaceArrIdx(g_raceId);
					if(g_raceExcluded) {
						g_arrRaces[arrIdx][7] = 1;
						showExcludeMsg(1); // passes included, not excluded
					} else {
						g_arrRaces[arrIdx][7] = 0;
						showExcludeMsg(0); // passes included, not excluded
					}
					showLoadingDiv(false, "");
				} else {
					var errMsg = "This page encountered an error: E20.3" + dlgCloseBtn;
					showLoadingDiv(true, errMsg);
				}
			}
		}
	}
	
	function deleteRace() {
		if(g_raceId > 0) { // GT 0 because it has to be an existing race
			var errMsg  = "Are you sure you want to delete this race?<br />If you have results recorded for this race, deleting will affect your leaderboards.";
				errMsg += "<br /><br /><input type='button' value='Yes' onclick='doDeleteRaceYes();' />&nbsp;&nbsp;";
				errMsg += "<input type='button' value='No' onclick='showLoadingDiv(false, \"\");' />";
			showLoadingDiv(true, errMsg);
		}
	}
	
	function doDeleteRaceYes() {
		var instance = new admin_proxy();
		instance.setCallbackHandler(deleteRaceCallback);
		instance.delete_race(g_seriesId,g_raceId);
	}
	
	function deleteRaceCallback(result) {
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E21" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		} else {
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				if(fields[0] == "good") {
					// delete was successful, reload everything
					g_raceId = 0;
					doSelSeries(g_seriesId);
				} else {
					var errMsg = "This page encountered an error: E22" + dlgCloseBtn;
					showLoadingDiv(true, errMsg);
				}
			}
		}
	}
	
	function deleteSeries() {
		if(g_seriesId > 0) { // GT 0 because it has to be an existing series
			var errMsg  = "Are you sure you want to delete this series and all of it's races?<br />If you have results recorded for any races in this series, deleting them will affect your leaderboards.";
				errMsg += "<br /><br /><input type='button' value='Yes' onclick='doDeleteSeriesYes();' />&nbsp;&nbsp;";
				errMsg += "<input type='button' value='No' onclick='showLoadingDiv(false, \"\");' />";
			showLoadingDiv(true, errMsg);
		}
	}
	
	function doDeleteSeriesYes() {
		var instance = new admin_proxy();
		instance.setCallbackHandler(deleteSeriesCallback);
		instance.delete_series(g_seriesId);
	}
	
	function deleteSeriesCallback(result) {
		var rows = getRows(result);
		
		if(rows[0] == "error") {
			var errMsg = "This page encountered an error: E23" + dlgCloseBtn;
			showLoadingDiv(true, errMsg);
		} else {
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				if(fields[0] == "good") {
					// delete was successful, reload everything
					g_seriesId = -1;
					g_raceId = -1;
					getSeries();
				} else {
					var errMsg = "This page encountered an error: E24" + dlgCloseBtn;
					showLoadingDiv(true, errMsg);
				}
			}
		}
	}
	
function fillAvailRacers() {
	var tbl = document.getElementById("tblAvailRacers");
	clearTable("tblAvailRacers", 0);
	
	for(var i=0; i<g_arrRacers.length; i++) {
		var fields = g_arrRacers[i];
		var racer_id = parseInt(fields[0]);
		var racer_name = decodeString(fields[1]);
		var team_abbr = fields[2];
		
		var team_name_output = "";
		if(team_abbr.length > 0) {
			team_name_output = "<span class='teamAbbr'> - " + team_abbr + "</span>"
		}

		var row = tbl.insertRow(-1);
		row.style.cursor = "pointer";
		row.id = "availRacerRow_" + racer_id.toString();

		var cell = row.insertCell(-1);
		cell.style.color = "black";
		cell.innerHTML = racer_name + team_name_output;
		cell.id = "availRacerCell_" + racer_id.toString();
		
		if (cell.addEventListener) {  // all browsers except IE before version 9
			cell.addEventListener("click", function() { doAvailRacerClick(this); }, false);
		} else {
			if (cell.attachEvent) {   // IE before version 9
				cell.attachEvent("click", function() { doAvailRacerClick(this); });
			}
		}

	}
	
	if(g_racerListRefresh) { // when do we set this?
		removeResultsRacersFromAvailable();
		g_racerListRefresh = false;
	}
}

function doAvailRacerClick(obj) {
	var tbl = document.getElementById("tblAvailRacers");
	var racer_id = obj.id.split("_")[1];
	
	var alreadySelected = false;
	// look for this racer_id in array of selected available racers
	for(var i=0; i<g_arrSelectedAvail.length; i++) {
		if(g_arrSelectedAvail[i] == racer_id) {
			alreadySelected = true;
			break;
		}
	}
	
	if(alreadySelected) {
		// if exists remove it and de-select row in table
		obj.style.backgroundColor = "white";
		g_arrSelectedAvail.splice(i, 1);
	} else {
		// if not exists, add to array and select row in table
		obj.style.backgroundColor = "#FF9800";
		g_arrSelectedAvail.push(racer_id);
	}
	// if MC series
		// get racers team
		// 
}

function getResults(race_id, seriesType) {
	var instance = new admin_proxy();
	instance.setCallbackHandler(fillResults);
	instance.get_race_results(race_id, seriesType);
}

function fillResults(result) {
	clearResultsTable();
	
	var rows = getRows(result);
	
	if(rows[0] == "error") {
		var errMsg = "This page encountered an error: E25" + dlgCloseBtn;
		showLoadingDiv(true, errMsg);
	} else {
		for(var i=0; i<rows.length; i++) {
			var fields = rows[i].split("|");
			var pos = fields[0];
			var name = fields[1];
			var racer_id = fields[2];
			// var pts = fields[3]; // yeeeaaahhh we don't do this
			var bonus_pts = fields[4];
			var start_pos = fields[5];
			var best_lap = fields[6]; //fields[6];
			var overall = fields[7]; //fields[7];
			var distance = fields[8]; //fields[8];
			var penalty_pts = fields[9];
			
			// results come back	pos		name	id		bonus
			// function expects		id		pos		name	bonus
			var arr = new Array();
			arr.push(racer_id);   // 0
			arr.push(pos);        // 1
			arr.push(name);       // 2
			arr.push(bonus_pts);  // 3
			arr.push(start_pos);  // 4
			arr.push(best_lap);   // 5
			arr.push(overall);    // 6
			arr.push(distance);   // 7
			arr.push(penalty_pts);// 8
			g_arrResults.push(arr);
		}
		
		// now that the array is loaded we can call the function that writes the array to the results table
		writeResultsTable();
		refreshAvailRacers(); // refresh list of available racers
	}
}

function clearResultsTable() {
	clearTable("tblResults", 1);
	g_arrResults = new Array();
}

function clearTable(tblId, keep) {
	var tbl = document.getElementById(tblId);
	keep = keep - 1;
	
	// this should delete all rows but the first one(our column headers)
	for(var i = tbl.rows.length - 1; i > keep; i--) {
		tbl.deleteRow(i);
	}
}

function writeResultsTable() {
	var arr = g_arrResults;
	var tbl = document.getElementById("tblResults");
	var arrSeriesIdx = getSeriesArrIdx(g_seriesId);
	
	// this should delete all rows but the first one(our column headers)
	for(var i = tbl.rows.length - 1; i > 0; i--) {
		tbl.deleteRow(i);
	}
	
	// if qual = ON, show header cell for qual pos
	var strDisplayQual = "";
	if(g_arrSeries[arrSeriesIdx][4] == "OFF") {
		strDisplayQual = "none";
	}
	tbl.rows[0].cells[startColumnIdx].style.display = strDisplayQual;
	
	var strDisplayDist = "none";
	if(g_raceLenType == "Time") {
		strDisplayDist = "";
	}
	
	var strDisplayOverall = "none";
	if(g_raceLenType == "Distance") {
		strDisplayOverall = "";
	}
	
	
	// sort array by position
	arr.sort(function(a,b) {
		return a[1] - b[1];
	});
	
	// loop through the array and append to the table
	for(var i=0; i<arr.length; i++) {
		var row = tbl.insertRow(-1);
		row.style.backgroundColor = getRowColor(i);
		
		// position column
		var cell = row.insertCell(-1);
		cell.align = "center";
		cell.innerHTML = "<input type='text' name='resultPosition' value='" + arr[i][1] + "' onchange='updateResultsWholeInt(1," + i + ",this);' style='width:2em;' />";
		
		var team_abbr = "";
		if(g_arrSeries[arrSeriesIdx][3] == "Multi-Class" || g_arrSeries[arrSeriesIdx][3] == "Teams") {
			if(arr[i][2].indexOf("<span") < 0) {
				for(var k=0; k<g_arrRacers.length; k++) {
					if(g_arrRacers[k][0] == arr[i][0]) {
						team_abbr = "<span class='teamAbbr'> - " + g_arrRacers[k][2] + "</span>";
					}
				}
			}
		}
		
		// racer column
		cell = row.insertCell(-1);
		cell.innerHTML = "<div style='width:100%;overflow:hidden;color:#000;'>" + arr[i][2] + team_abbr + "</div>";
		
		// bonus points
		var cell = row.insertCell(-1);
		cell.align = "center";
		cell.innerHTML = "<input type='text' id='bonusPoints_" + i + "' name='bonusPoints_" + i + "' value='" + arr[i][3] + "' onchange='updateResultsWholeInt(3," + i + ",this);' style='width:3em;' onclick='highlightField(this);' />";
		
		// penalty points
		var cell = row.insertCell(-1);
		cell.align = "center";
		cell.innerHTML = "<input type='text' id='penaltyPoints_" + i + "' name='penaltyPoints_" + i + "' value='" + arr[i][8] + "' onchange='updateResultsWholeInt(8," + i + ",this);' style='width:3em;' onclick='highlightField(this);' />";
		
		// start position
		var cell = row.insertCell(-1);
		cell.align = "center";
		cell.innerHTML = "<input type='text' id='startPosition_" + i + "' name='startPosition_" + i + "' value='" + arr[i][4] + "' onchange='updateResultsWholeInt(4," + i + ",this);' style='width:3em;' onclick='highlightField(this);' />"; 
		cell.style.display = strDisplayQual;
		
		// best lap
		var cell = row.insertCell(-1);
		cell.align = "center";
		cell.innerHTML = "<input type='text id='bestLap_" + i + "'' name='bestLap_" + i + "' value='" + arr[i][5] + "' onchange='updateResultsTime(5," + i + ",this);' style='width:5em;' onclick='highlightField(this);' />"; 
		
		// overall
		var cell = row.insertCell(-1);
		cell.align = "center";
		cell.innerHTML = "<input type='text' id='overall_" + i + "' name='overall_" + i + "' value='" + arr[i][6] + "' onchange='updateResultsTime(6," + i + ",this);' style='width:7em;' onclick='highlightField(this);' />"; 
		cell.style.display = strDisplayOverall;
		
		// distance
		var cell = row.insertCell(-1);
		cell.align = "center";
		cell.innerHTML = "<input type='text' id='distance_" + i + "' name='distance_" + i + "' value='" + arr[i][7] + "' onchange='updateResultsFraction(7," + i + ",this);' style='width:5em;' onclick='highlightField(this);' maxlength='10' />"; 
		cell.style.display = strDisplayDist;
		
		// remove racer from results table column
		cell = row.insertCell(-1);
		cell.align = "center";
		cell.innerHTML = "<img src='imgs/delete-icon.png' onclick='removeRacer(" + arr[i][0] + ");' style='cursor:pointer;' title='Click here to remove this racer from the race results and add them back to the available racers list.' />";

	}
}

function highlightField(obj) {
	obj.setSelectionRange(0, obj.value.length);
}

function removeResultsRacersFromAvailable() {
	for(var i=0; i<g_arrResults.length; i++) {
		var thisResultRacer = g_arrResults[i][0];
		
		if(g_arrSeries[getSeriesArrIdx(g_seriesId)][3] == "Teams" || g_arrSeries[getSeriesArrIdx(g_seriesId)][3] == "Multi-Class" ) {
			var thisResultRacer_name = g_arrResults[i][2];
			if(document.getElementById("availRacerCell_" + thisResultRacer.toString())) {
				var racerWithTeam = document.getElementById("availRacerCell_" + thisResultRacer.toString()).innerHTML;
				
				var tblResults = document.getElementById("tblResults");
				for(var k=1; k<tblResults.rows.length; k++) {
					var racerName = tblResults.rows[k].cells[1].childNodes[0].innerHTML.split("<span")[0];
					if(racerName == thisResultRacer_name) {
						tblResults.rows[k].cells[1].childNodes[0].innerHTML = racerWithTeam;
						break;
					}
				}
			}
		}
		
		
		removeAvail(thisResultRacer);
	}
}

function getRacerName(racer_id) {
	var racer_name = "";
	for(var i=0; i<g_arrRacers.length; i++) {
		if(g_arrRacers[i][0] == racer_id) {
			racer_name = g_arrRacers[i][1];
			break;
		}
	}
	
	return racer_name;
}

function removeAvail(racer_id) {
	var tbl = document.getElementById("tblAvailRacers");
	for(var k=0; k<tbl.rows.length; k++) {
		if(tbl.rows[k].id == "availRacerRow_" + racer_id.toString()) {
			tbl.deleteRow(k);
			break;
		}
	}
}

function addNewRacers() {
	displayId('divDialog', '');
	document.getElementById("spanDialogName").innerHTML = "Manage Members";
	document.getElementById("frameDialog").src = "admin_club_members.cfm?dlg=1";
	document.getElementById("frameDialog").style.height = "580px";
	document.getElementById("linkDialogClose").setAttribute("onclick", "closeEditRacers()");
	showOverlay(true);
}

function closeEditRacers() {
	displayId('divDialog', 'none');
	showOverlay(false);
	// need to refresh the available racers
	refreshAvailRacers();
}

function refreshAvailRacers() {
	g_racerListRefresh = true;
	getRacers();
}

function updateResultsWholeInt(arrPos,idx,obj) {
	// we need to make sure that the values entered are INTEGERS
	var value = obj.value;
	var errMsg = "";
	
	if(value.length <= 0) {
		// error
		errMsg = "You need to have a value here." + dlgCloseBtn;
	} else if(isNaN(parseInt(value))) {
		// error
		errMsg = "This value must be a whole number." + dlgCloseBtn;
	} else if(parseInt(value) < 0) {
		// error
		errMsg = "This value must be a whole number of at least 0." + dlgCloseBtn;
	}
	
	if(errMsg.length > 0) {
		obj.value = "0";
		showLoadingDiv(true, errMsg);
		return;
	} else {
		g_arrResults[idx][arrPos] = parseInt(obj.value);
		writeResultsTable();
	}
}

function updateResultsFraction(arrPos,idx,obj) {
	var value = formatDistanceTraveled(obj.value);
	var errMsg = "";
	
	if(value.length <= 0) {
		errMsg = "You need to have a value here." + dlgCloseBtn;
	} else if(false) { // validate the fraction
		errMsg = "This value must be a fraction(9,3)." + dlgCloseBtn;
	} else {
		// is a fraction or whole number, update the array
	}
	
	if(errMsg.length > 0) {
		obj.value = "0";
		showLoadingDiv(true, errMsg);
		return;
	} else {
		g_arrResults[idx][arrPos] = value;
		writeResultsTable();
	}
}

function updateResultsTime(arrPos,idx,obj) {
	// we need to make sure that the values entered are INTEGERS
	var value = formatRaceTimes(obj.value);
	var errMsg = "";
	
	if(errMsg.length > 0) {
		obj.value = "00:00:00.000";
		showLoadingDiv(true, errMsg);
		return;
	} else {
		g_arrResults[idx][arrPos] = value;
		writeResultsTable();
	}
}

function removeRacer(racer_id) {
	//var sel = document.getElementById("selAvailRacers");
	var tbl = document.getElementById("tblAvailRacers");
	
	for(var i=0; i<g_arrResults.length; i++) {
		if(g_arrResults[i][0] == racer_id) {
			// add back to available racers list
			//var opt = document.createElement("option");
			//opt.value = g_arrResults[i][0]
			//sel.appendChild(opt);
			//sel.options[sel.options.length-1].innerHTML = document.getElementById("tblResults").rows[i+1].cells[1].childNodes[0].innerHTML;
			
			var row = tbl.insertRow(-1);
			row.style.cursor = "pointer";
			row.id = "availRacerRow_" + racer_id.toString();

			var cell = row.insertCell(-1);
			cell.style.color = "black";
			cell.innerHTML = document.getElementById("tblResults").rows[i+1].cells[1].childNodes[0].innerHTML;
			cell.id = "availRacerCell_" + racer_id.toString();
			
			if (cell.addEventListener) {  // all browsers except IE before version 9
				cell.addEventListener("click", function() { doAvailRacerClick(this); }, false);
			} else {
				if (cell.attachEvent) {   // IE before version 9
					cell.attachEvent("click", function() { doAvailRacerClick(this); });
				}
			}
			
			// remove from MC results array
			if(g_arrSeries[getSeriesArrIdx(g_seriesId)][3] == "Multi-Class") { // if multi-class series
				// when we remove a racer from the global results array we need to decrease the currPos for that team by 1
				var team = "";
				for(var k=0; k<g_arrRacers.length; k++) {
					if(parseInt(g_arrRacers[k][0]) == parseInt(g_arrResults[i][0])) {
						// we found the racer
						// get this racer's team
						team = g_arrRacers[k][2];
						break;
					}
				}
				
				var currPos = 0;
				var newPos = 0;
				for(var j=0; j<g_arrMCResults.length; j++) {
					if(g_arrMCResults[j][0] == team) { // this team exists in g_arrMCResults
						currPos = parseInt(g_arrMCResults[j][1]); // what was the last recorded pos
						newPos = currPos-1; // what should the new pos be?
						g_arrMCResults[j][1] = newPos; // decrease currPos by 1
						break;
					}
				}
				
				if(parseInt(g_arrResults[i][1]) < parseInt(currPos)) {
					var errMsg = "<b>" + team + "</b> has <b>" + currPos + "</b> positions defined and you just removed position <b>#" + g_arrResults[i][1] + "</b>.";
					errMsg += "This will cause issues if you decide to add more results right now for this class.";
					errMsg += "<br /><br />Before you save, double check the finish positions for each class and verify that they are correct.";
					errMsg += "<br /><br />If this is a common occurrence for you, contact me and I will develop a better solution to this issue. Thanks!" + dlgCloseBtn;
					showLoadingDiv(true, errMsg);
				}
			}
			
			// remove from official results array
			g_arrResults.splice(i,1);

			break;
		}
	}
	
	// re-write the table
	writeResultsTable();
}

function addToResults() {
	buildResultsArray();
	writeResultsTable();
}

function buildResultsArray() {
	//var sel = document.getElementById("selAvailRacers");
	// loop through list of available racers and add selected racers to the array
	
	for(var i=0; i<g_arrSelectedAvail.length; i++) {
		var racer_id = g_arrSelectedAvail[i];
		var tempArr = new Array();
		tempArr.push(racer_id); // racers id
		
		var racerRecord;
		// get all info for this racer
		for(var k=0; k<g_arrRacers.length; k++) {
			if(parseInt(g_arrRacers[k][0]) == parseInt(racer_id)) {
				// we found the racer
				racerRecord = g_arrRacers[k];
				break;
			}
		}

		/* need to declare: var g_arrMCResults = [];
		*/
		if(g_arrSeries[getSeriesArrIdx(g_seriesId)][3] == "Multi-Class") {
			// get this selected racer's team
			var team = racerRecord[2];
			
			if(g_arrResults.length > 0) {
				// loop through g_arrMCResults to find curr pos for this team
				var currPos = 1;
				var newPos = 1;
				var idx = -1;
				for(var j=0; j<g_arrMCResults.length; j++) {
					if(g_arrMCResults[j][0] == team) { // this team exists in g_arrMCResults
						currPos = parseInt(g_arrMCResults[j][1]); // what was the last recorded pos
						newPos = currPos+1; // what should the new pos be?
						idx = j; // bookmark the array
						break;
					}
				}
				
				if(idx > -1) { // did we bookmark the array
					g_arrMCResults[idx][1] = newPos; // yes we did, store the new position
				} else {
					g_arrMCResults.push([team, 1]); // no we did not, add this team and 1 as current pos
				}
				
				// add newPos to tempArr
				tempArr.push(newPos);
			} else {
				g_arrMCResults = []; // if there are no results, there shoudln't be any MC results either
				tempArr.push(1);
				g_arrMCResults.push([team, 1]); // add this team
			}
		} else {
			if(g_arrResults.length > 0) {
				tempArr.push(parseInt(g_arrResults[g_arrResults.length-1][1])+1); // add a default finish position
			} else {
				tempArr.push(1);
			}
		}

		tempArr.push(racerRecord[1]); // racers name
		tempArr.push(0);  // Bonus Points
		tempArr.push(0);  // start position
		tempArr.push("00:00.000"); // best lap
		tempArr.push("00:00:00.000"); // overall
		tempArr.push(0.000); // distance
		tempArr.push(0); // penalty pts
		g_arrResults.push(tempArr);
		
		// now remove this racer from the available racers UI control
		removeAvail(racer_id);
	}
	
	// now loop through the list of avaialable racers backwards
	// and remove any selected options
	//for(var i=sel.options.length-1; i>-1; i--) {
	//	if(sel.options[i].selected) {
	//		sel.remove(i); 
	//	}
	//}

	// now we're done so we can clear the selectedAvail array
	g_arrSelectedAvail = [];
	
}

function toggleQualifying() {
	// get series record from array of series
	var arrIdx = getSeriesArrIdx(g_seriesId);
	if(arrIdx < 0) {
		errMsg += "This page encountered an error: E26" + dlgCloseBtn;
		showLoadingDiv(true, errMsg);
		return;
	}
	
	// check to see what state qualifying is in currently
	var qual_setting = g_arrSeries[arrIdx][4];
	
	if(qual_setting == "ON") {
		// if qual = on, confirm okay to turn off
		doQualConfirm("OFF");
	} else if(qual_setting == "OFF") {
		// if qual = off, confirm okay to turn on
		doQualConfirm("ON");
	} else {
		errMsg += "This page encountered an error: E27" + dlgCloseBtn;
		showLoadingDiv(true, errMsg);
		return;
	}
}

function doQualConfirm(desired_qual_setting) {
	var errMsg  = "Are you sure you want to turn " + desired_qual_setting + " being able to record the starting position for this series?";
		errMsg += "<br /><br />Turning this feature ON/OFF will affect the stats on other pages for your club and your racers."
				errMsg += "<br /><br /><input type='button' value='Yes' onclick='updateSeriesQualSetting(\"" + desired_qual_setting + "\");' />&nbsp;&nbsp;";
				errMsg += "<input type='button' value='No' onclick='showLoadingDiv(false, \"\");' />";
	showLoadingDiv(true, errMsg);
}

function updateSeriesQualSetting(desired_qual_setting) {
	// confirm was YES
	
	// update series array
	var arrIdx = getSeriesArrIdx(g_seriesId);
	if(arrIdx < 0) {
		errMsg += "This page encountered an error: E26" + dlgCloseBtn;
		showLoadingDiv(true, errMsg);
		return;
	} else {
		g_arrSeries[arrIdx][4] = desired_qual_setting;
	}
	// hide the confirm box
	showLoadingDiv(false, "");
	
	// update database
	var instance = new admin_proxy();
	instance.setCallbackHandler(updateSeriesQualSetting_callback);
	instance.update_series_qual_setting(g_seriesId, desired_qual_setting);
}

function updateSeriesQualSetting_callback(result) {
	var rows = getRows(result);
	
	if(rows[0] == "error") {
		var errMsg = "This page encountered an error: E25" + dlgCloseBtn;
		showLoadingDiv(true, errMsg);
	} else {
		var desired_qual_setting = rows[0];
		// update text of link
		setQualifyingLink(desired_qual_setting);
		
		// show/hide starting pos column
		toggleQualCol(desired_qual_setting);
	}
}

function setQualifyingLink(qual_setting) {
	//var link = document.getElementById("linkQualifying");
	//link.innerHTML = "Qualifying is " + qual_setting;
	var img = document.getElementById("imgStartGrid_" + g_seriesId);
	if(qual_setting == "ON") {
		img.src = "imgs/start-grid-ico-ON.png";
	} else {
		img.src = "imgs/start-grid-ico.png";
	}
}

function toggleQualCol(desired_qual_setting) {
	var strDisplay = "";
	
	if(desired_qual_setting == "OFF") {
		strDisplay = "none";
	}
	
	// hide/show the column
	var tbl = document.getElementById("tblResults");
	for(var i=0; i<tbl.rows.length; i++) {
		tbl.rows[i].cells[startColumnIdx].style.display = strDisplay;
	}
}

function showInfoButton(strHelp) {
	var strMsg = "";
	
	switch(strHelp) {
		case "results":
			strMsg = "<b>Results Help</b><br />";
			strMsg += "<br />DNF - Mark finish position as 0";
			strMsg += "<br />DNQ - Mark start position as 0";
			break;
		case "date":
			strMsg = "<b>Date/Time Help</b><br />";
			strMsg += "<br />When setting the race date and time, use YOUR local date and time. The site will automatically show the date and time correctly for your racers, no matter where they live.";
			break;
		case "time":
			strMsg = "<b>Time Help</b><br />";
			strMsg += "<br />When specifying a time for the race length you must use this format - hh:mm";
			break;
		case "timeResults":
			strMsg = "<b>Time Help</b><br />";
			strMsg += "<br />When recording a time you must use this format - hh:mm:ss.ms";
			break;
		case "distanceUnits":
			strMsg = "<b>Units Help</b><br />";
			if(g_raceLenType == "Time") {
				strMsg += "<br />Timed Races - You are choosing a unit of measurement for when you record your results.";
			} else if(g_raceLenType == "Distance") {
				strMsg += "<br />Distance Races - You are choosing a unit of measurement for determining the length of this race.";
			}
			break;
		case "flags":
			strMsg = "<b>Flags Help</b><br />";
			strMsg += "<br />This feature allows you and your racers to use flags during a race LIVE! Just select a flag on the manage flags screen and your racers will see the flag you picked within 1 second.";
			break;
	}
	
	showLoadingDiv(true, strMsg + "<br />" + dlgCloseBtn);
}

function onChangeRaceLength() {
	var selRaceLen = document.getElementById("selRaceLen");
	var raceLenType = selRaceLen.options[selRaceLen.selectedIndex].value;
	g_raceLenType = raceLenType;
	
	if(g_raceLenType == "Distance") {
		document.getElementById("divTimeResults").style.display = "none";
		document.getElementById("txtDistVal").value = "0";
		
		// don't need to show distance column in results table
		showDistanceResultsColumn(false);
		// need to show overall time column
		showOverallResultsColumn(true);
		
	} else if(g_raceLenType == "Time") {
		document.getElementById("divTimeResults").style.display = "";
		document.getElementById("txtDistVal").value = "00:00";
		
		 // don't need to show overall time in a timed race, it should be the same for everyone
		showOverallResultsColumn(false);
		// need to show distance column in timed race, everyone will finish with different distance traveled
		showDistanceResultsColumn(true);
	}
}

function showDistanceResultsColumn(bln) {
	var strDisplay = "";
	if(!bln) {
		strDisplay = "none";
	}
	
	// show results distance column
	var tbl = document.getElementById("tblResults");
	for(var i=0; i<tbl.rows.length; i++) {
		tbl.rows[i].cells[distanceColumnIdx].style.display = strDisplay;
		if(i == 0 && bln) {
			// if 1st row in results table and showing it, change the label
			onChangeDistUnit();
		}
	}
}

function showOverallResultsColumn(bln) {
	var strDisplay = "";
	if(!bln) {
		strDisplay = "none";
	}
	
	// show results overall column
	var tbl = document.getElementById("tblResults");
	for(var i=0; i<tbl.rows.length; i++) {
		tbl.rows[i].cells[overallColumnIdx].style.display = strDisplay;
	}
}

function onChangeDistUnit() {
	var selDistUnit = document.getElementById("selDistUnit");
	var distUnitType = selDistUnit.options[selDistUnit.selectedIndex].value;
	g_distUnitType = distUnitType;
	
	if(g_raceLenType == "Time") {
		var tbl = document.getElementById("tblResults");
		tbl.rows[0].cells[distanceColumnIdx].innerHTML = "Dist.(" + g_distUnitType + ")";
	}
}

var g_raceOptionsExpanded = false;
function showRaceOptions() {
	var divRaceOptions = document.getElementById("divRaceOptions");
	if(g_raceOptionsExpanded) {
		divRaceOptions.style.display = "none";
		g_raceOptionsExpanded = false;
	} else {
		divRaceOptions.style.display = "";
		showCorrectExclude(); // if we are now showing the options, then let's get the exclude text right
		g_raceOptionsExpanded = true;
	}
}

function manageFlags() {
	window.location.href = "admin_flags.cfm?race=" + g_raceId;
}

	
</script>
</head>
<body onload="init();">

<cfinclude template="include/navigation.cfm">

<div align="center" style="width:100%;font-size:16pt;">
	Manage Races
</div>
<br />

<div style="width:100%;" align="center">

<cfinclude template="include/dialogs.cfm">
<div id="divEditor" align="center" style="z-index:3000;width: 100%;display: none;">
	<table border="0" style="background-color: white;border: 2px solid #ccc;" cellspacing="0" cellpadding="0">
		<tr class="dataHeaderBG">
			<td width="10%">&nbsp;</td>
			<td align="center" width="80%" class="dataHeaderTxt">
				<b><span id="spanEditorDlgName">Edit Description</span></b>
			</td>
			<td align="right" width="10%">
				<a href="javascript:editDesc(false,'',-1);" style="color:white;">Close</a>
			</td>
		</tr>
		<tr>
			<td colspan="3" align="center">
				<textarea id="textarea_1" name="textarea_1"></textarea>
			</td>
		</tr>
		<tr>
			<td colspan="3" align="center">
				<input type="button" value="Save" onclick="saveDesc_setup();" />
			</td>
		</tr>
	</table>
</div>




<div id="divAddNew" style="width:90%;" align="center">
	<div style="width:100%;" align="right">
		<a href="javascript:addNewSeries();" id="linkAddNewSeries">Add New Series</a>
	</div>
</div>
<div id="divContainer" style="width:90%" align="center">
</div>
</div>


<div id="divSeriesData" align="left" style="display:none;">
	<table>
		<tr>
			<td align="left">
				&nbsp;&nbsp;&nbsp;Name:
				<input type="text" id="txtSeriesName" name="txtSeriesName" value="" maxlength="100" />
			</td>
			<td align="left">
				&nbsp;&nbsp;&nbsp;Points:
					<select id="selPts" name="selPts" onchange="validatePoints(this);">
						<option value="-1">-- Select Template --</option>
					</select>
					<img src="imgs/gear_edit.png" id="edit_pts" onclick="manageTemplates(true);" style="cursor:pointer;" title="Click here to manage your points templates" />
			</td>
			<td align="left">
				<span id="spanSeriesType"></span>
			</td>
		</tr>
	</table>
</div>

<div id="divRaceData" align="left" style="display:none;">

<div id="divExcludeMsg"></div>

<table width="100%" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td>

	<table>
		<tr>
			<td>
				Name:
			</td>
			<td>
				<input type="text" id="txtRaceName" name="txtRaceName" value="" style="width:100%;" />
			</td>
		</tr>
		<tr>
			<td>
				Length:
			</td>
			<td>
				<select name="selRaceLen" id="selRaceLen" onchange="onChangeRaceLength();">
					<option value="Distance">Distance</option>
					<option value="Time">Time</option>
				</select>
				
				<span id="divDistanceVal">
					<input type="text" id="txtDistVal" name="txtDistVal" value="0" style="width:5em;" onchange="validateDistVal(this, this.value);" onclick="highlightField(this);" />
				</span>
				
				<span id="divTimeResults" style="display:none;">
					&nbsp;<img src="imgs/info_button.png" onclick="showInfoButton('time');" id="info_time" class="infoBtn" />
					&nbsp;Results: 
				</span>
				
				<span id="divDistanceUnits">
					<select name="selDistUnit" id="selDistUnit" onchange="onChangeDistUnit();">
						<option value="laps">laps</option>
						<option value="km">km</option>
						<option value="m">m</option>
						<option value="mi">mi</option>
						<option value="ft">ft</option>
					</select>
					&nbsp;<img src="imgs/info_button.png" onclick="showInfoButton('distanceUnits');" id="info_dist" class="infoBtn" />
				</span>
			</td>
		</tr>
		<tr>
			<td>
				Track:
			</td>
			<td>
				<select name="selTracks" id="selTracks"></select>
			</td>
		</tr>
		<tr>
			<td>
				Date:
			</td>
			<td>
				<input type="text" id="datepicker" />
				<select id="selHour" name="selHour">
					<option value="1">1</option>
					<option value="2">2</option>
					<option value="3">3</option>
					<option value="4">4</option>
					<option value="5">5</option>
					<option value="6">6</option>
					<option value="7">7</option>
					<option value="8">8</option>
					<option value="9">9</option>
					<option value="10">10</option>
					<option value="11">11</option>
					<option value="12">12</option>
				</select>
				<select id="selMins" name="selMins">
					<option>00</option>
					<option>15</option>
					<option>30</option>
					<option>45</option>
				</select>
				<select id="selAMPM" name="selAMPM">
					<option>AM</option>
					<option>PM</option>
				</select>
				<img src="imgs/info_button.png" onclick="showInfoButton('date');" id="info_dateTime" class="infoBtn" />
			</td>
		</tr>
	</table>
	
		</td>
		<td width="106" align="left">
			<div id="raceOptionsContainer">
				<div align="right" style="height:32px;">
					<img src="imgs/save-image.png" height="32" style="cursor:pointer;" onclick="saveRace(0);" />
					<img src="imgs/menu-options.jpg" height="32" style="cursor:pointer;" onclick="showRaceOptions();" />
				</div>
				<div id="divRaceOptions" style="display:none;">
					<div class="raceOptions" onclick="excludeRace();" id="divExcludeLink">Exclude...</div>
					<div class="raceOptions" onclick="deleteRace();">Delete...</div>
					<div class="raceOptions" onclick="editDesc(true, 'race', 0);">Edit Write-Up</div>
					<div class="raceOptions"><span onclick="manageFlags();">Flags </span><img src="imgs/info_button.png" onclick="showInfoButton('flags');" class="infoBtn"></div>
					<!--<div class="raceOptions" onclick="saveRace(0);">Save</div>-->
				</div>
			</div>
		</td>
	</tr>
</table>
	
	
</div>

<div id="divResults" align="left" style="display:none;">
<table border="0" cellspacing="0" cellpadding="2" style="border: 1px solid #7E8AA2;" width="100%">
	<tr>
		<td width="30%">
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td align="left" id="cellAvailText">
						Available Racers:
					</td>
					<td align="right">
						<img src="imgs/edit_racers.png" onclick="addNewRacers();" style="cursor:pointer;" title="If you want to add new racers or edit a racer's name, click here." />
					</td>
				</tr>
			</table>
		</td>
		<td width="5%">&nbsp;<!-- spacer --></td>
		<td width="65%">
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td align="left" width="20%">
						Race Results:
					</td>
					<td align="center" width="70%" id="cellKey">
						&nbsp;
					</td>
					<td align="right" width="10%">
						<img src="imgs/info_button.png" onclick="showInfoButton('results');" class="infoBtn" />
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td valign="top">
			<div style="height:200px;overflow:auto;border: 1px solid #ccc;background-color:white;">
				<table id="tblAvailRacers" width="100%" cellspacing="0" cellpadding="0" border="0">
				</table>
			</div>
		</td>
		<td align="center">
			<input type="button" onclick="addToResults();" value=">" title="Select racers from the list on the left and click this button to add those racers to the results list on the right." />
		</td>
		<td valign="top">
			<div style="height:200px; overflow:auto;">
				<table id="tblResults" border="0" width="100%" cellspacing="2" cellpadding="3">
					<tr class="dataHeaderBG">
						<td style="font-weight:bold;width:2em;" align="center" class="dataHeaderTxt">
							Pos
						</td>
						<td style="font-weight:bold;" align="center" class="dataHeaderTxt">
							Racer
						</td>
						<td style="font-weight:bold;width:3em;" align="center" class="dataHeaderTxt">
							Bonus
						</td>
						<td style="font-weight:bold;width:3em;" align="center" class="dataHeaderTxt">
							Penalty
						</td>
						<td style="font-weight:bold;width:3em;display:none;" align="center" class="dataHeaderTxt">
							Start
						</td>
						<td style="font-weight:bold;width:6em;" align="center" class="dataHeaderTxt">
							Best Lap
						</td>
						<td style="font-weight:bold;width:7em;" align="center" class="dataHeaderTxt">
							Overall
						</td>
						<td style="font-weight:bold;width:6em;display:none;" align="center" class="dataHeaderTxt">
							Dist.(laps)
						</td>
						<td style="font-weight:bold;width:2em;" align="center" class="dataHeaderTxt">
							&nbsp;
						</td>
					</tr>
				</table>
			</div>
		</td>
	</tr>
</table>
</div>

<div id="bottomBorder" style="font-size: 1px;">
&nbsp;
</div>





</body>
</html>