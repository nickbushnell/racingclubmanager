<cfajaxproxy cfc="search_proxy" jsclassname="search_proxy" />

<html>
<head>
<link href='http://fonts.googleapis.com/css?family=Monda:400' rel='stylesheet' type='text/css'>
<style type="text/css">
	body {
		background-color: #263248;
		font-family: 'Monda', sans-serif;
		color: #F8F8FF;
		font-size: 14pt;
	}
	
	a {
		font-size: 10pt;
		color:#fff;
	}
	
	.title {
		color: #FF9800;
	}
</style>
<script type="text/javascript">
if(!String.prototype.trim) {
	String.prototype.trim=function(){return this.replace(/(?:(?:^|\n)\s+|\s+(?:$|\n))/g,'').replace(/\s+/g,' ');};
}

function getTypedClubs() {
	var elemSearch = document.getElementById("txtClubSearch");
	var searchVal = elemSearch.value.trim();
	
	if(searchVal.length > 0) {
		var instance = new search_proxy();
		instance.setCallbackHandler(fillTypedClubs);
		instance.get_typed_clubs(searchVal);
	} else {
		showResults(false)
	}
}

function fillTypedClubs(result) {
	var divResults = document.getElementById("divClubResults");
	divResults.innerHTML = ""; // clear the previous results
	
	var strHTML = "";
	
	// parse ajax result
	if(result.length > 0) {
		result = result + "<row>";
		var rows = result.split("<row>");
		rows.pop();
		for(var i=0; i<rows.length; i++) {
			var fields = rows[i].split("|");
			
			
			var platImg = "";
			var strPlatform = fields[3];
			if(strPlatform == "XBOX One" || strPlatform == "XBOX 360") {
				platImg = "xbox.png";
			} else if(strPlatform == "Playstation 3" || strPlatform == "Playstation 4") {
				platImg = "ps.png";
			} else if(strPlatform == "PC") {
				platImg = "PC.png";
			}
			platImg = "&nbsp;&nbsp;&nbsp;<img src='imgs/" + platImg + "' height='20' width='20' title='" + strPlatform + "' />"
			
			
			var strClub = fields[1].substring(0,16) + ' - ' + fields[2];
			strHTML += '<div title="'+ strClub +'" onclick="pickClub('+ fields[0] +')" onmouseover="hoverClub(this, true);" onmouseout="hoverClub(this,false)" style="cursor:pointer;padding:2px;">';
			strHTML += strClub;//.substring(0,25);
			
			if(strPlatform.length > 0) {
				strHTML += platImg;
			}
			
			strHTML += "</div>";
		}
		divResults.innerHTML = strHTML;
		showResults(true);
	} else {
		showResults(false);
	}
}

function showResults(blnShow) {
	var elemSearch = document.getElementById("txtClubSearch");
	var resultsDiv = document.getElementById("divClubResults");
	var myRect = elemSearch.getBoundingClientRect();
	var resultsTop = myRect.top + elemSearch.offsetHeight;
	var resultsLeft = myRect.left;
	
	if(blnShow) {
		// show results
		resultsDiv.style.display = "";
		resultsDiv.style.top = resultsTop;
		resultsDiv.style.left = resultsLeft;
	} else {
		// hide results
		resultsDiv.style.display = "none";
	}
}

function hoverClub(elem, blnShow) {
	if(blnShow) {
		elem.style.backgroundColor = "#7E8AA2";
		elem.style.color = "black";
	} else {
		elem.style.backgroundColor = "white";
		elem.style.color = "#ccc";
	}
}

function pickClub(clubId) {
	// redirect to page with the data tables on it.
	parent.window.location = "club_home.cfm?club=" + clubId;
}



</script>


</head>
<body>


<div id="divClubResults" style="display:none;position:absolute;width:22em;height:5em;font-size:15pt;color:#ccc;background-color:white;border: 1px solid #aaa;overflow:auto;" align="left">

</div>


<div align="center" style="width:100%;font-size:22px;">
	
	<div style="width:23em;padding:10px;" align="left">
	
	<table border="0" cellspacing="0" cellpadding="0" style="background-color: #263248;">
		<tr>
			<td height="15" width="15"></td>
			<td height="15" width="15"></td>
			<td height="15" width="15"></td>
		</tr>
		<tr>
			<td></td>
			<td>
				<table width="100%" cellspacing="0" cellpadding="0">
					<tr>
						<td align="left" style="font-size:20px;" class="title">
							Search Clubs:
						</td>
						<td align="right">
							<a href="advanced_search.cfm" target="_parent">Advanced Search</a>&nbsp;
							<a href="view_all_clubs.cfm" style="font-size: 10pt;" onclick="parent.makeDlgBigger();">View All Clubs</a>
						</td>
					</tr>
				</table>

				<input type="text" onkeyup="getTypedClubs();" name="txtClubSearch" id="txtClubSearch" value="" style="width:20em;font-size:16pt;border: 1px solid #ccc;" maxlength="20" />
			</td>
			<td></td>
		</tr>
		<tr>
			<td height="15" width="15"></td>
			<td height="15" width="15"></td>
			<td height="15" width="15"></td>
		</tr>
	</table>
	</div>
</div>


</body>
</html>