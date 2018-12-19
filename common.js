var dlgCloseBtn = "<br /><input type='button' onclick='showLoadingDiv(false, \"\")' value='Close' />";

function decodeString(strVal) {
	strVal = strVal.replace(/~chr34~/g,'"');
	strVal = strVal.replace(/~chr35~/g,"#");
	strVal = strVal.replace(/~chr39~/g,"'");
	strVal = strVal.replace(/~chr60~/g,"<");
	strVal = strVal.replace(/~chr62~/g,">");
	strVal = strVal.replace(/~chr124~/g,"|");
	strVal = strVal.replace(/_RCMspace_/g," ");
	return(strVal);
}

function encodeSpaces(str) {
	return str.replace(/ /g,"_RCMspace_");
}

function getRowColor(i) {
	if((i+1)%2 == 0) {
		return("#7E8AA2"); // highlight color
	} else {
		return("#fff"); // background color
	}
}

function displayId(id, display) {
	var div = document.getElementById(id);
	div.style.display = display;
}

function resizeOverlay() {
	if(document.getElementById("overlay").style.display == "") {
		showOverlay(true);
	}
}

function showOverlay(blnShow) {
	var strDisplay = ""
	if(!blnShow) {
		strDisplay = "none";
	}
	document.getElementById("overlay").style.display = strDisplay;
	document.getElementById("overlay").style.width = document.body.clientWidth;
	document.getElementById("overlay").style.height = document.body.clientHeight;
	
	if(parseInt(document.body.scrollHeight) > parseInt(document.getElementById("overlay").style.height)) {
		document.getElementById("overlay").style.height = document.body.scrollHeight;
	}
}

function displayDate(strDate) {
	return(UTC2Local(strDate));
}

function local2UTC(dateString) {
	dtRace = new Date(dateString);
	
	var hour = dtRace.getUTCHours();
	var strAMPM = "AM";
	if(hour > 12) {
		hour = hour - 12;
		if(hour < 24) {
			strAMPM = "PM";
		}
	}
	return((dtRace.getUTCMonth()+1) + "/" + dtRace.getUTCDate() + "/" + dtRace.getUTCFullYear() + " " + hour + ":" + dtRace.getUTCMinutes() + " " + strAMPM);
}

function UTC2Local(dateString) {
	// format dateString
	//alert(dateString);
	dateString = dateString.replace(/-/g, "/");
	//dateString = dateString.replace(".0", "");
	dateString = dateString.split(".")[0];
	//alert(dateString);
	
	var dtRace = new Date(dateString + " UTC");
	//alert(dtRace.toString());
	if(dtRace.getFullYear().toString() > "1900") {
		var strDate = (dtRace.getMonth()+1) + "/" + dtRace.getDate() + "/" + dtRace.getFullYear();
		var hour = dtRace.getHours();
		var strAMPM = "AM";
		if(hour > 12) {
			hour = hour - 12;
			if(hour < 24) {
				strAMPM = "PM";
			}
		} else if(hour == 12) { // hour = 12 noon
			strAMPM = "PM";
		}
		var minute = dtRace.getMinutes();
		if(parseInt(minute) == 0) {
			minute = "00";
		} else {
			minute = "00" + minute;
			minute = minute.substr(minute.length-2, 2);
		}
		
		return(strDate += " " + hour + ":" + minute + " " + strAMPM);
	} else {
		return "";
	}
}

function makeDlgBigger() {
	var dlg = document.getElementById("iframe_clubSearch");
	dlg.style.height = parseInt(screen.availHeight)/2;
}

function makeDlgSmaller() {
	var dlg = document.getElementById("iframe_clubSearch");
	dlg.style.height = "250px";
}

function getRows(result) {
	var arr = [];
	
	if(result.length > 0) {
		if(result == "sessionError") {
			var errMsg = "<b>Your session has expired.</b>";
			   errMsg += "<br />We are going to open a new window so you can log back in, so that you don't lose your changes.";
			   errMsg += "<br />If you aren't allowing pop-ups for this site, allow it, then attempt to save again and we will attempt to re-open the login screen for you.<br />";
			   errMsg += "<br /><input type='button' onclick='showLoadingDiv(false, \"\")' value='Continue Working' />";
			showLoadingDiv(true, errMsg);
			
			window.open("login.cfm?close=yes", "_blank");
		} else {
			result = result + "<row>";
			var rows = result.split("<row>");
			rows.pop();
			arr = rows;
		}
	}

	return arr;
}

function getURL() {
	return(document.URL.split("/")[document.URL.split("/").length-1]);
}

function getProgressBar(totalChunks, chunksLeft) {
	var perc = parseInt(chunksLeft) / parseInt(totalChunks);
	perc = perc * 100;
	
	return("<div width='100%' align='left'><div style='background-color: red; font-size: 3px; width: " + perc.toString() + "%;'>&nbsp;</div></div>");
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

function showClubSearch(blnShow) {
	var strDisplay = "";
	if(!blnShow) {
		strDisplay = "none";
		document.body.style.overflow = "auto";
	} else {
		document.body.style.overflow = "hidden";
	}
	
	document.getElementById("overlay").style.display = strDisplay;
	document.getElementById("overlay").style.width = document.body.clientWidth + "px";
	document.getElementById("overlay").style.height = document.body.clientHeight + "px";
	document.getElementById("clubSearchDiv").style.display = strDisplay;
}

function goHome() {
	window.location = "index.html?stay=yes";
}

function isValidDate(dateString)
{
	// First check for the pattern
	if(!/^\d{1,2}\/\d{1,2}\/\d{4}$/.test(dateString))
		return false;

	// Parse the date parts to integers
	var parts = dateString.split("/");
	var day = parseInt(parts[1], 10);
	var month = parseInt(parts[0], 10);
	var year = parseInt(parts[2], 10);

	// Check the ranges of month and year
	if(year < 1000 || year > 3000 || month == 0 || month > 12)
		return false;

	var monthLength = [ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ];

	// Adjust for leap years
	if(year % 400 == 0 || (year % 100 != 0 && year % 4 == 0))
		monthLength[1] = 29;

	// Check the range of the day
	return day > 0 && day <= monthLength[month - 1];
}

function getSelValue(objSel) {
	var strValue = "";
	if(objSel.selectedIndex > -1) {
		strValue = objSel.options[objSel.selectedIndex].value;
	}
	return strValue;
}

function formatDateField(dateString) {
	var MyDate = new Date(dateString);
	var MyDateString = ('0' + (MyDate.getMonth()+1)).slice(-2) + '/'
		 + ('0' + MyDate.getDate()).slice(-2) + '/'
		 + MyDate.getFullYear();
	return(MyDateString);
}

function getDlgTop() {
	var dlg = document.getElementById("divDialog");
	var dlgHeight = parseInt(dlg.clientHeight);
	var bodyHeight = parseInt(document.body.clientHeight);
	
	return (bodyHeight/2)-(dlgHeight/2)+"px";
	
}

function onlyNormalChars(str) {
	for(var i=0; i<str.length; i++) { // loop thru chars
		var thisChar = str.charCodeAt(i);
		var spaceChar = 32;
		var periodChar = 46;
		var underscoreChar = 95;
		var zeroChar = 48;
		var nineChar = 57;
		var upperAchar = 65;
		var upperZchar = 90;
		var lowerAchar = 97;
		var lowerZchar = 122;
		if(thisChar == spaceChar || thisChar == periodChar || thisChar == underscoreChar || (thisChar >= zeroChar && thisChar <= nineChar) || (thisChar >= upperAchar && thisChar <= upperZchar) || (thisChar >= lowerAchar && thisChar <= lowerZchar)) {
			// good!
		} else {
			// this character is bad, exit function
			return false;
		}
	}
	
	return true;
}