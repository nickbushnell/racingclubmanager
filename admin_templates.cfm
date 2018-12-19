<cfajaxproxy cfc="admin_templates_server" jsclassname="admin_proxy" />
<cfif Not IsDefined("Session.club_id")>
	<cfset session.goto = "admin_templates.cfm">
	<cflocation url="login.cfm" addtoken="no">
</cfif>

<cfif IsDefined("URL.series")>
	<cfset g_seriesId = Int(URL.series)>
<cfelse>
	<cfset g_seriesId = 0>
</cfif>

<html>
<head>
<title>Racing Club Manager - Points Templates</title>
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
<cfoutput>
<script type="text/javascript">
	var g_seriesId = parseInt("#g_seriesId#");
</script>
</cfoutput>
<script type="text/javascript">
	if(!String.prototype.trim) {
		String.prototype.trim=function(){return this.replace(/(?:(?:^|\n)\s+|\s+(?:$|\n))/g,'').replace(/\s+/g,' ');};
	}
	
	var g_templateArr = [];
	var g_templateId = 0;
	var g_pointsArr = [];
	var g_ptsTemplateArr = [];
	var g_savedTemplate = false;
	
	function init() {
		showLoadingDiv(true, "Loading...");
		document.getElementById("divLoading").style.top = "50px";
		document.getElementById("overlay").style.backgroundColor = "white";
		
		
		g_templateArr = [];
		//g_templateId = 0;
		g_pointsArr = [];
		g_ptsTemplateArr = [];
		document.getElementById("selTempNames").selectedIndex = 0;
		resetForm();
		getTemplates();
	}
	
	function getTemplates() {
		var instance = new admin_proxy();
		instance.setCallbackHandler(fillTemplates);
		instance.get_points_templates();
	}
	
	function fillTemplates(result) {
		var sel = document.getElementById("selTempNames");
		sel.options.length = 2; // clear the options except the 2 defaults
		g_templateArr = []; // reset template array
		
		if(result.length > 0) { 
			var rows = getRows(result);
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				g_templateArr.push(fields);
				var opt = document.createElement("option");
				opt.value = fields[0];
				sel.appendChild(opt);
				sel.options[sel.options.length-1].innerHTML = fields[1];
			}
			
			if(g_savedTemplate) {
				g_savedTemplate = false;
				setParentTemplateId();
			}
		} else {
			// do nothing
		}
		
		showLoadingDiv(false, "");
		document.getElementById("pageContainer").style.visibility = "visible";
	}
	
	function resetForm() {
		// teplate does not belong to you
		displayId("row_templateName", "none"); // hide template name
		document.getElementById("txtTemplateName").value = ""; // reset template name
		displayId("row_saveDelete", "none"); // hide save and delete buttons
		displayId("row_addRemove","none"); // hide add and remove buttons
		
		// clear any rows that exist
		var tbl = document.getElementById("tblPoints");
		for(var i = tbl.rows.length - 1; i > 0; i--) {
			tbl.deleteRow(i);
		}
		
		document.getElementById("tblPoints").style.visibility = "hidden"; // hide the table
		
		g_ptsTemplateArr = [];
		
		//g_templateId = 0;
	}
	
	function doSelTemplate(sel) {
		resetForm();
		
		var selIdx = sel.selectedIndex;
		if(selIdx > 1) {
			g_templateId = parseInt(sel.options[selIdx].value); // set global template Id

			if(g_templateId > 0) {
				var thisTemplateClubId = parseInt(g_templateArr[selIdx-2][2]);
				
				if(thisTemplateClubId > 0) { // if this template belongs to you
					// allow name edit
					displayId("row_templateName", "");
					document.getElementById("txtTemplateName").value = decodeString(g_templateArr[selIdx-2][1]);
					
					// show the table
					document.getElementById("tblPoints").style.visibility = "visible";
					
					// allow save/delete
					displayId("row_saveDelete", "");
					document.getElementById("btnDelete").disabled = false;
					
					// allow add/remove rows
					displayId("row_addRemove",""); // show add new points record
				}
				
				getTemplatePoints(g_templateId);
			}
		} else if(selIdx == 1) {
			g_templateId = 0;
			// adding new template
			displayId("row_templateName",""); // show template name div
			document.getElementById("txtTemplateName").value = ""; // set template name to blank
			displayId("row_addRemove",""); // show add new points record
			document.getElementById("btnRemove").disabled = true; // disable the remove row button
			document.getElementById("btnDelete").disabled = true; // disable the delete template button
			
			// show the table
			document.getElementById("tblPoints").style.visibility = "visible";
			
			// allow save/delete
			displayId("row_saveDelete", "");
		} else {
			var strHTML = "Please select a valid template.";
			showLoadingDiv(true, strHTML + dlgCloseBtn);
			document.getElementById("divLoading").style.top = "50px";
			document.getElementById("overlay").style.backgroundColor = "white";
		}
	}
	
	function getTemplatePoints(template_id) {
		var instance = new admin_proxy();
		instance.setCallbackHandler(getTemplatePoints_callback);
		instance.get_points_by_template(template_id);
	}
	
	function getTemplatePoints_callback(result) {
		g_ptsTemplateArr = [];
		if(result.length > 0) {
			var rows = getRows(result);
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				g_ptsTemplateArr.push(fields);
			}
			
			fillTemplatePoints(g_ptsTemplateArr);
		} else {
			var tbl = document.getElementById("tblPoints");
			// remove rows from table before filling
			for(var i = tbl.rows.length - 1; i > 0; i--) {
				tbl.deleteRow(i);
			}
		}
		
		if(g_ptsTemplateArr.length <= 0) {
			document.getElementById("btnRemove").disabled = true;
		} else {
			document.getElementById("btnRemove").disabled = false;
		}
		
		// show the table
		document.getElementById("tblPoints").style.visibility = "visible";
	}
	
	function fillTemplatePoints(arr) {
		var tbl = document.getElementById("tblPoints");
		// remove rows from table before filling
		for(var i = tbl.rows.length - 1; i > 0; i--) {
			tbl.deleteRow(i);
		}
		
		for(var i=0; i<arr.length; i++) {
			var thisRow = arr[i];
			var pos = thisRow[0];
			var pts = thisRow[1];
			
			var row = tbl.insertRow(-1);
			row.style.backgroundColor = getRowColor(i);
			
			var cell = row.insertCell(-1);
			cell.align = "right";
			cell.innerHTML = pos;
			cell.setAttribute("class","cellData");
			
			cell = row.insertCell(-1);
			cell.align = "right";
			cell.innerHTML = "<input type='text' value='" + pts + "' id='pos_" + pos + "' style='width:3em;text-align:right;' onchange='validatePts(this)' />";
			cell.setAttribute("class","cellData");
		}
	}
	
	function validatePts(obj) {
		var points = obj.value;
		if(points.length <= 0) {
			obj.value = "0";
			return;
		} else {
			if(isNaN(parseInt(points))) {
				var strHTML = "The points given to this position must be a whole number. It can be negative or positive." + dlgCloseBtn;
				showLoadingDiv(true, strHTML);
				document.getElementById("divLoading").style.top = "50px";
				document.getElementById("overlay").style.backgroundColor = "white";
				obj.value = "0";
				return;
			} else { // everything is good
				obj.value = parseInt(points); // set the field to whatever they requested
				refreshPtsArray(); // refresh the points array
				return;
			}
		}
	}
	
	function refreshPtsArray() {
		// loop through fields on screen and make array match
		for(var i=0; i<g_ptsTemplateArr.length; i++) {
			var pos = g_ptsTemplateArr[i][0];
			var input = document.getElementById("pos_"+pos);
			g_ptsTemplateArr[i][1] = parseInt(input.value);
		}
	}
	
	function checkRemove() {
		var pos = -1;
		if(g_templateId > 0) {
			if(g_ptsTemplateArr.length > 0) {
				pos = parseInt(g_ptsTemplateArr[g_ptsTemplateArr.length-1][0]);
			}
			if(pos > -1) {
				var instance = new admin_proxy();
				instance.setCallbackHandler(checkRemove_callback);
				instance.check_remove_pts_row(g_templateId,pos);
			}
		} else {
			// adding new template, no template id, just remove
			addRow(-1);
		}
	}
	
	function checkRemove_callback(result) {
		if(result.length > 0) {
			var rows = getRows(result);
			for(var i=0; i<rows.length; i++) {
				var fields = rows[i].split("|");
				
				if(fields[0] == "error") {
					var strHTML = "";
					strHTML += "There was an error: E02." + dlgCloseBtn;
					showLoadingDiv(true, strHTML);
					document.getElementById("divLoading").style.top = "50px";
					document.getElementById("overlay").style.backgroundColor = "white";
				} else {
					// result set is good
					var timesPosUsed = parseInt(fields[0]);
					if(timesPosUsed > 0) {
						var strHTML = "You cannot remove position <b>" + fields[1] + "</b> from this template because it has been used in results for a race." + dlgCloseBtn;
						showLoadingDiv(true, strHTML);
						document.getElementById("divLoading").style.top = "50px";
						document.getElementById("overlay").style.backgroundColor = "white";
					} else {
						// go ahead with removal
						addRow(-1);
					}
				}
			}
		} else {
			var strHTML = "There was an error: E01." + dlgCloseBtn;
			showLoadingDiv(true, strHTML);
			document.getElementById("divLoading").style.top = "50px";
			document.getElementById("overlay").style.backgroundColor = "white";
		}
	}
	
	function addRow(numRows) {
		if(numRows < 0) {
			// removing last row
			g_ptsTemplateArr.pop();
		} else {
			// adding row to end
			var pos = 0;
			if(g_ptsTemplateArr.length > 0) {
				pos = parseInt(g_ptsTemplateArr[g_ptsTemplateArr.length-1][0]) + 1;
			}
			var arr = [];
			arr.push(pos);
			arr.push(0);
			g_ptsTemplateArr.push(arr);
		}
		
		if(g_ptsTemplateArr.length > 0) {
			document.getElementById("btnRemove").disabled = false;
		} else {
			document.getElementById("btnRemove").disabled = true;
		}
		fillTemplatePoints(g_ptsTemplateArr);
	}
	
	function doSave() {
		if(g_ptsTemplateArr.length > 0) {
			
			// convert g_ptsTemplateArr to comma delimited list. 0=0,1=40,2=39,etc.
			var strPts = "";
			for(var i=0; i<g_ptsTemplateArr.length; i++) {
				if(strPts.length > 0) {
					strPts += ",";
				}
				strPts += g_ptsTemplateArr[i][0] + "=" + g_ptsTemplateArr[i][1];
			}
			
			var template_name = document.getElementById("txtTemplateName").value;
			if(template_name.trim().length <= 0) {
				var strHTML = "You need to give this template a name." + dlgCloseBtn;
				showLoadingDiv(true, strHTML);
				document.getElementById("divLoading").style.top = "50px";
				document.getElementById("overlay").style.backgroundColor = "white";
				return;
			}
			
			var num_pos = parseInt(g_ptsTemplateArr[g_ptsTemplateArr.length-1][0]);

			var instance = new admin_proxy();
			instance.setCallbackHandler(doSave_callback);
			instance.save_pts_template(g_templateId,template_name,strPts,g_seriesId,num_pos);
		} else {
			var strHTML = "You need to have at least 1 position defined before you can save." + dlgCloseBtn;
			showLoadingDiv(true, strHTML);
			document.getElementById("divLoading").style.top = "50px";
			document.getElementById("overlay").style.backgroundColor = "white";
		}
	}
	
	function doSave_callback(result) {
		if(result.length > 0) {
			if(result != "good") {
				var strHTML = "";
				if(result == "errorPos") {
					strHTML += "One of the races in this series has more finishers than this points template. Add more finish positions to this template and attempt to save again." + dlgCloseBtn;
				} else {
					strHTML += result + dlgCloseBtn;
				}
				showLoadingDiv(true, strHTML);
				document.getElementById("divLoading").style.top = "50px";
				document.getElementById("overlay").style.backgroundColor = "white";
			} else {
				var strHTML = "Template Saved." + dlgCloseBtn;
				showLoadingDiv(true, strHTML);
				document.getElementById("divLoading").style.top = "50px";
				document.getElementById("overlay").style.backgroundColor = "white";
				
				g_savedTemplate = true;

				init();
			}
		} else {
			// no result?
		}
	}
	
	function doDelete() {
		var instance = new admin_proxy();
		instance.setCallbackHandler(doDelete_callback);
		instance.delete_pts_template(g_templateId);
	}
	
	function doDelete_callback(result) {
		if(result.length > 0) {
			if(result == "error") {
				var strHTML = "There was an error deleting this template." + dlgCloseBtn;
				showLoadingDiv(true, strHTML);
				document.getElementById("divLoading").style.top = "50px";
				document.getElementById("overlay").style.backgroundColor = "white";
			} else if(result == "good") {
				init();
			} else {
				var strHTML = result + dlgCloseBtn;
				showLoadingDiv(true, strHTML);
				document.getElementById("divLoading").style.top = "50px";
				document.getElementById("overlay").style.backgroundColor = "white";
			}
		}
	}
	
	function showLoadingDiv(bln, txt) {
		var div = document.getElementById("divLoading");
		var strDisplay = "";
		
		if(!bln) {
			strDisplay = "none";
		}
		
		document.getElementById("loadingTxt").innerHTML = txt;
		
		showOverlay(bln);
		div.style.display = strDisplay;
	}
	
	function setParentTemplateId() { // only called if we save a template, helps us figure out which one was just saved
		if(parseInt(g_templateId) == 0) {
			// if we didn't just edit an existing template the g_templateId would be 0
			// if g_templateId is 0 then get template with highest Id value
			var sel = document.getElementById("selTempNames");
			var highestTemplateId = 0;
			for(var i=0; i<sel.options.length; i++) {
				var templateId = parseInt(sel.options[i].value);
				if(templateId > highestTemplateId) {
					highestTemplateId = templateId;
					//sel.options.selectedIndex = i;
				}
			}
			
			g_templateId = highestTemplateId;
		}
	}
	
	function getTemplateId() {
		return parseInt(g_templateId);
	}
	
	function getTemplateName() {
		var sel = document.getElementById("selTempNames");
		var templateName = "";
		
		for(var i=0; i<sel.options.length; i++) {
			if(sel.options[i].value == g_templateId) {
				templateName = sel.options[i].innerHTML;
				break;
			}
		}
		
		return templateName;
	}
	
	function saveTemplateToSeries() {
		//alert("basically just saved template to series.... g_templateId = " + g_templateId);
		var instance = new admin_proxy();
		instance.setCallbackHandler(saveTemplateToSeries_callback);
		instance.save_template_to_series(g_seriesId, g_templateId);
	}
	
	function saveTemplateToSeries_callback(result) {
		if(result.length > 0) {
			if(result == "error") {
				var strHTML = "There was an error saving the template to the series." + dlgCloseBtn;
				showLoadingDiv(true, strHTML);
				document.getElementById("divLoading").style.top = "50px";
				document.getElementById("overlay").style.backgroundColor = "white";
			}
		}
	}

</script>
</head>
<body onload="init()">
<cfinclude template="include/dialogs.cfm">

<br /><br />
<div style="width:100%;visibility:hidden;" align="center" id="pageContainer">
	<div>* Position 0 = DNF</div>
	
	<div id="row_selTempNames">
		<select name="selTempNames" id="selTempNames" onchange="doSelTemplate(this)" style="width: 200px;">
			<option value="-1">-- Select Template --</option>
			<option value="0">-- Add New Template --</option>
		</select>
	</div>
	
	<div id="row_templateName" style="display:none;">
		<input type="text" name="txtTemplateName" id="txtTemplateName" value="" style="width: 200px;" maxlength="50" />
	</div>
	
	<div style="font-size:5px;">
		&nbsp;
	</div>
	
	<div id="row_saveDelete" style="display:none;">
		<input type="button" value="Save" onclick="doSave()" />
		<input type="button" value="Delete" id="btnDelete" onclick="doDelete()" />
	</div>
	
	<br />
	
	<table id="tblPoints" border="0" cellspacing="2" cellpadding="3" style="visibility:hidden;">
		<tr class="dataHeaderBG">
			<td align="center" class="dataHeaderTxt">
				<b>Position</b>
			</td>
			<td align="center" class="dataHeaderTxt">
				<b>Points</b>
			</td>
		</tr>
	</table>
	
	<br />
	
	<div id="row_addRemove" style="display: none;" align="center">
		<input type="button" value="Add Row" onclick="addRow(1);" />
		<input type="button" value="Remove Row" onclick="checkRemove()" id="btnRemove" name="btnRemove" />
	</div>
</div>


	
</body>
</html>