<cfajaxproxy cfc="ask_to_join_server" jsclassname="ask_proxy" />
<cfif IsDefined("URL.club")>
	<cfset g_clubId = "#URL.club#">
<cfelse>
	<cfif IsDefined("Cookie.defaultClub") is "True">
		<cfset g_clubId = "#Cookie.defaultClub#">
	<cfelse>
		<cfset g_clubId = "1">
	</cfif>
</cfif>


<cfif IsDefined("URL.from")>
	<cfset g_comingFrom = "#URL.from#">
<cfelse>
	<cfset g_comingFrom = "N">
</cfif>

<cfset g_showNav = "True">
<cfif IsDefined("URL.nav")>
	<cfif "#URL.nav#" EQ "no">
		<cfset g_showNav = "False">
	</cfif>
<cfelse>
	<!--- nothing --->
</cfif>

<html>
<head>
<link href='http://fonts.googleapis.com/css?family=Monda:400' rel='stylesheet' type='text/css'>
<link href='nav_list.css' rel='stylesheet' type='text/css'>
<style type="text/css">
	body {
		margin: 0px;
		background-color: white;
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
	
	#viewAllClubsLink {
		color: #fff;
	}
	
	#viewAllClubsLink a {
		color: #FF9800;
		padding: 5px;
	}
</style>
<cfoutput>
<script type="text/javascript">
	if(!String.prototype.trim) {
		String.prototype.trim=function(){return this.replace(/(?:(?:^|\n)\s+|\s+(?:$|\n))/g,'').replace(/\s+/g,' ');};
	}
	
	var g_clubId = parseInt("#g_clubId#");
	var g_comingFrom = "#g_comingFrom#";
</script>
</cfoutput>

<script language='javascript' src='common.js'></script>
<script type="text/javascript">
	var dlgCloseBtn_local = "<br /><input type='button' onclick='showLoadingDiv(false, \"\");doRefreshIfSuccess();' value='Close' />";
	
	function init() {
		// show View All Clubs link if 
		if(g_comingFrom == "index" || g_comingFrom == "N") {
			document.getElementById("viewAllClubsLink").style.display = "";
		}
	}
	
	function doAskToJoin() {
		var strErr = "";
		var gamertag = document.getElementById("txtGamertag").value.trim();
		if(gamertag.length <= 0) {
			strErr += "You must enter a gamertag.<br />";
		}
		var email = document.getElementById("txtEmail").value.trim();
		if(email.length <= 0) {
			strErr += "You must enter an email address.<br />";
		}
		var tcs = (document.getElementById("chk_TCS").checked ? "yes" : "no");
		var abs = (document.getElementById("chk_ABS").checked ? "yes" : "no");
		var auto = (document.getElementById("chk_auto").checked ? "yes" : "no");
		var stability = (document.getElementById("chk_stability").checked ? "yes" : "no");
		var line = (document.getElementById("chk_line").checked ? "yes" : "no");
		var steering = (document.getElementById("chk_steering").checked ? "yes" : "no");
		var level = document.getElementById("selDriverLevel").options[document.getElementById("selDriverLevel").selectedIndex].value;
		var desc = document.getElementById("txtDesc").value.trim();
		
		if(strErr.length > 0) {
			showLoadingDiv(true,"The following errors have been encountered:<br />" + strErr + dlgCloseBtn_local);
			document.getElementById("divLoading").style.top = "75px";
			document.getElementById("overlay").style.backgroundColor = "white";
		} else {
			var instance = new ask_proxy();
			instance.setCallbackHandler(askToJoin_callback);
			instance.ask_to_join(g_clubId, gamertag, email, tcs, abs, auto, stability, line, steering, level, desc);
		}
	}
	
	function askToJoin_callback(result) {
		if(result.length > 0) {
			if(result.indexOf("error") > -1) {
				showLoadingDiv(true,result + "<br />There was a problem trying to send your request to an admin at this club." + dlgCloseBtn_local);
				document.getElementById("divLoading").style.top = "75px";
				document.getElementById("overlay").style.backgroundColor = "white";
			} else if(result.indexOf("racerExists") > -1) {
				showLoadingDiv(true,"<br />This racer already exists as part of this club. Sometimes admins enter known racers in advance." + dlgCloseBtn_local);
				document.getElementById("divLoading").style.top = "75px";
				document.getElementById("overlay").style.backgroundColor = "white";
			} else {
				parent.showClubSearch(false);
				parent.showLoadingDiv(true,"Your request to join this club has been successfully sent.<br />You will receive an email when an admin has decided on your request." + dlgCloseBtn);
			}
		} else {
			showLoadingDiv(true,"Error0<br />There was a problem trying to send your request to an admin at this club." + dlgCloseBtn_local);
			document.getElementById("divLoading").style.top = "75px";
			document.getElementById("overlay").style.backgroundColor = "white";
		}
		
		window.scrollTo(0,0);
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
	
</script>

<title>Racing Club Manager - Ask To Join</title>
</head>
<body onload="init();">
<cfinclude template="include/dialogs.cfm">


<cfif g_showNav EQ "True">
	<div style="width:100%;" align="center">
		<div id="viewAllClubsLink" align="left" style="font-size: 10pt; display: none; background-color: #263248;">
		<cfoutput>
		<cfif g_comingFrom NEQ "index">
			<a href="club_search_white.cfm?from=#g_comingFrom#" onclick="parent.makeDlgSmaller();">Club Search</a> &gt; 
		</cfif>
			<a href="view_all_clubs.cfm?from=#g_comingFrom#">View All Clubs</a> &gt; 
			Ask To Join
		</cfoutput>
		</div>
	</div>
</cfif>

<div align="center" style="width:100%;">

<div id="divMessages" style="position:absolute; z-index:3000; width:33%; top:200px; padding:10px; border:2px solid black; background-color:white; display:none;" align="center">
	<div id="divMsgText"></div>
	<br />
	<input type="button" value="OK" onclick="showMsgs(false,'');doRefreshIfSuccess();" />
</div>

<cfif g_showNav EQ "True">
	<br />
	<div style="font-size: 24px;">Ask To Join</div>

	<br /><br />
</cfif>

	<table width="75%" border="0">
		<tr>
			<td align="left" valign="top" width="10%">
				Gamertag:
			</td>
			<td align="left" valign="top">
				<input type="text" name="txtGamertag" id="txtGamertag" maxlength="18" />
			</td>
		</tr>
		<tr>
			<td align="left" valign="top" width="10%">
				E-mail:
			</td>
			<td align="left" valign="top">
				<input type="text" name="txtEmail" id="txtEmail" maxlength="100" />
				<img src="imgs/info_button.png" title="We will not send any emails to you except regarding this request to join this club. We do not willingly give out any information." />
			</td>
		</tr>
		<tr>
			<td align="left" valign="top">
				Assists:
			</td>
			<td align="left" valign="top">
				<table width="100%">
					<tr>
						<td align="left" valign="top" width="1%">
							<input type="checkbox" name="chk_TCS" id="chk_TCS" />
						</td>
						<td align="left" valign="top">
							Traction Control
						</td>
					</tr>
					<tr>
						<td align="left" valign="top">
							<input type="checkbox" name="chk_ABS" id="chk_ABS" />
						</td>
						<td align="left" valign="top">
							ABS
						</td>
					</tr>
					<tr>
						<td align="left" valign="top">
							<input type="checkbox" name="chk_auto" id="chk_auto" />
						</td>
						<td align="left" valign="top">
							Automatic Transmission
						</td>
					</tr>
					<tr>
						<td align="left" valign="top">
							<input type="checkbox" name="chk_stability" id="chk_stability" />
						</td>
						<td align="left" valign="top">
							Stability Control
						</td>
					</tr>
					<tr>
						<td align="left" valign="top">
							<input type="checkbox" name="chk_line" id="chk_line" />
						</td>
						<td align="left" valign="top">
							Suggested Line(Braking or Full)
						</td>
					</tr>
					<tr>
						<td align="left" valign="top">
							<input type="checkbox" name="chk_steering" id="chk_steering" />
						</td>
						<td align="left" valign="top">
							Normal Steering
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td align="left" valign="middle">
				Driver Level:
			</td>
			<td align="left" valign="middle">
				<select name="selDriverLevel" id="selDriverLevel">
					<option value="New Driver">New Driver</option>
					<option value="A Little Messy">A Little Messy</option>
					<option value="Clean">Clean</option>
					<option value="Fast & Clean">Fast & Clean</option>
				</select>
				<img src="imgs/info_button.png" title="When answering this question consider downgrading based on how many assists you checked off above. If you use more than half of the assists, consider yourself at least a little messy. If you don't use TCS and are using Simulation Steering and can hold your own in traffic without running people off the road, consider yourself clean." />
			</td>
		</tr>
		<tr>
			<td align="left" valign="top" colspan="2">
				<br />
				Tell us a little bit about yourself. What timezone are you in? What days and times are you available?<br />
				What cars and tracks do you like?
				<br />
				<input type="text" id="descChars" size="3" readonly value="500" />
				<br />
				<textarea style="width: 100%; height: 150px;" id="txtDesc" onkeyup="updateChars(this);"></textarea>
			</td>
		</tr>
		<tr>
			<td align="center" colspan="2">
				<input type="button" onclick="doAskToJoin();" value="Ask To Join" />
			</td>
		</tr>
	</table>
	<br /><br />

</div>






</body>
</html>