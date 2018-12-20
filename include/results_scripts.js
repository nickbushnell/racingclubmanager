var g_arrResults = [];
var g_racerListRefresh = false;
var g_arrMCResults = [];

function fillAvailRacers() {
	var sel = document.getElementById("selAvailRacers");
	sel.options.length = 0;
	
	for(var i=0; i<g_arrRacers.length; i++) {
		var fields = g_arrRacers[i];
		var racer_id = parseInt(fields[0]);
		var racer_name = decodeString(fields[1]);
		var team_abbr = fields[2];
		
		var team_name_output = "";
		if(team_abbr.length > 0) {
			team_name_output = "<span class='teamAbbr'> - " + team_abbr + "</span>"
		}
		
		var opt = document.createElement("option");
		opt.value = racer_id;
		sel.appendChild(opt);
		sel.options[sel.options.length-1].innerHTML = racer_name + team_name_output;
	}
	
	if(g_racerListRefresh) { // when do we set this?
		removeResultsRacersFromAvailable();
		g_racerListRefresh = false;
	}
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
		var errMsg = "This page encountered an error: E09" + dlgCloseBtn;
		showLoadingDiv(true, errMsg);
	} else {
		for(var i=0; i<rows.length; i++) {
			var fields = rows[i].split("|");
			var pos = fields[0];
			var name = fields[1];
			var racer_id = fields[2];
			// var pts = fields[3]; // yeeeaaahhh we don't do this
			var bonus_pts = fields[4];
			
			// results come back	pos		name	id		bonus
			// function expects		id		pos		name	bonus
			var arr = new Array();
			arr.push(racer_id);
			arr.push(pos);
			arr.push(name);
			arr.push(bonus_pts);
			g_arrResults.push(arr);
		}
		
		// now that the array is loaded we can call the function that writes the array to the results table
		writeResultsTable();
		refreshAvailRacers(); // refresh list of available racers
	}
}

function clearResultsTable() {
	var tbl = document.getElementById("tblResults");
	
	// this should delete all rows but the first one(our column headers)
	for(var i = tbl.rows.length - 1; i > 0; i--) {
		tbl.deleteRow(i);
	}
	
	g_arrResults = new Array();
}

function writeResultsTable() {
	var arr = g_arrResults;
	var tbl = document.getElementById("tblResults");
	
	// this should delete all rows but the first one(our column headers)
	for(var i = tbl.rows.length - 1; i > 0; i--) {
		tbl.deleteRow(i);
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
		cell.innerHTML = "<input type='text' name='resultPosition' value='" + arr[i][1] + "' onchange='updateResults(1," + i + ",this);' style='width:3em;' />";
		
		var team_abbr = "";
		if(g_arrSeries[getSeriesArrIdx(g_seriesId)][3] == "Multi-Class" || g_arrSeries[getSeriesArrIdx(g_seriesId)][3] == "Teams") {
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
		cell.innerHTML = "<input type='text' name='bonusPoints' value='" + arr[i][3] + "' onchange='updateResults(3," + i + ",this);' style='width:3em;' />";
		
		// remove racer from results table column
		cell = row.insertCell(-1);
		cell.align = "center";
		cell.innerHTML = "<img src='imgs/delete-icon.png' onclick='removeRacer(" + arr[i][0] + ");' style='cursor:pointer;' title='Click here to remove this racer from the race results and add them back to the available racers list.' />";

	}
}

function removeResultsRacersFromAvailable() {
	var sel = document.getElementById("selAvailRacers");

	// loop thru arr of results
	// check to see if this result racer = this select racer
	// if so remove racer from select
	
	for(var i=0; i<g_arrResults.length; i++) {
		var thisResultRacer = g_arrResults[i][0];
		
		for(var k=0; k<sel.options.length; k++) {
			if(thisResultRacer == sel.options[k].value) {
				var thisResultRowInTable = document.getElementById("tblResults").rows[i+1].cells[1].childNodes[0]
				thisResultRowInTable.innerHTML = sel.options[k].innerHTML;
				sel.remove(k);
				break;
			}
		}
	}
	
}

function addNewRacers() {
	displayId('divDialog', '');
	document.getElementById("spanDialogName").innerHTML = "Edit Racers";
	document.getElementById("frameDialog").src = "admin_racers.cfm";
	document.getElementById("frameDialog").style.height = "250px";
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

function updateResults(arrPos,idx,obj) {
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

function removeRacer(racer_id) {
	var sel = document.getElementById("selAvailRacers");
	
	for(var i=0; i<g_arrResults.length; i++) {
		if(g_arrResults[i][0] == racer_id) {
			// add back to available racers list
			var opt = document.createElement("option");
			opt.value = g_arrResults[i][0];
			sel.appendChild(opt);
			sel.options[sel.options.length-1].innerHTML = document.getElementById("tblResults").rows[i+1].cells[1].childNodes[0].innerHTML;
			
			// remove from official results array
			g_arrResults.splice(i,1);
			
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
	var sel = document.getElementById("selAvailRacers");
	// loop through list of available racers and add selected racers to the array
	var removeArray = new Array();
	for(var i=0; i<sel.options.length; i++) {
		if(sel.options[i]) {
			var thisOpt = sel.options[i];
			if(thisOpt.selected) {
				var tempArr = new Array();
				tempArr.push(thisOpt.value); // racers id
				
				
				/* need to declare: var g_arrMCResults = [];
				*/
				if(g_arrSeries[getSeriesArrIdx(g_seriesId)][3] == "Multi-Class") {
					// get this selected racer's team
					var team = "";
					for(var k=0; k<g_arrRacers.length; k++) {
						if(parseInt(g_arrRacers[k][0]) == parseInt(thisOpt.value)) {
							// we found the racer
							// get this racer's team
							team = g_arrRacers[k][2];
							break;
						}
					}
					
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
				/*
				*/
				
				
				
				/*
				if(g_arrResults.length > 0) {
					tempArr.push(parseInt(g_arrResults[g_arrResults.length-1][1])+1); // add a default finish position
				} else {
					tempArr.push(1);
				}
				*/
				
				
				
				
				
				
				
				tempArr.push(thisOpt.innerHTML); // racers name
				tempArr.push(0); // Bonus Points
				g_arrResults.push(tempArr);
			}
		}
	}
	
	// now loop through the list of avaialable racers backwards
	// and remove any selected options
	for(var i=sel.options.length-1; i>-1; i--) {
		if(sel.options[i].selected) {
			sel.remove(i); 
		}
	}
}