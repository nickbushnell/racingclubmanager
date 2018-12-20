<cfset complete_path = cgi.CF_TEMPLATE_PATH>
<cfset path_array = ListToArray(complete_path, "\")>
<cfset page = path_array[ArrayLen(path_array)]>

<div id="divAllClubs" style="width: 100%;" align="center" class="block">
<table id="tbl_clubs" border="0" cellspacing="0" cellpadding="5" width="90%">
	<tr>
		<td align="left">
			
			<div id="centeredmenu">
				<ul>
				  <li>
				  <!--<span style="font-size: 14pt;cursor:pointer;color: #000;" onclick="goHome();"><b><span style="font-style:italic;">racing</span><span style="color:#fff;">club</span><span>manager</span></b></span>&nbsp;&nbsp;&nbsp;-->
				  <img src="imgs/rcm-nav-50.jpg" height="36" onclick="goHome();" style="cursor:pointer;">
				  </li>
				  
				  <cfif IsDefined("Cookie.defaultClub")>
					<cfinclude template="my_club_nav.cfm">
				  </cfif>
				  
				  <cfif IsDefined("URL.club") OR IsDefined("Session.club_id")>
						<cfinclude template="club_nav.cfm">
				  <cfelse>
					<cfif Not IsDefined("Cookie.defaultClub")>
						<cfset currentURL = "#CGI.SERVER_NAME#" & "#CGI.PATH_INFO#">
						
						<cfif page EQ "club_home.cfm">
							<cflocation url="club_home.cfm?club=1" addtoken="no">
						</cfif>
					</cfif>
				  </cfif>
				  
				  <li><a href="contact.cfm">Contact &#9662;</a>
					  <ul class="last">
						<li><a href="contact.cfm">Contact Form</a></li>
						<li><a href="http://www.reddit.com/r/racingclubmanager">Forum</a></li>
						<li><a href="https://racingclubmanager.wordpress.com/">Blog</a></li>
						<li><a href="https://www.facebook.com/Racingclubmgr">Facebook</a></li>
						<li><a href="https://twitter.com/RacingClubMgr">Twitter</a></li>
						<li><a href="mailto:rcm@racingclubmanager.com">E-mail</a></li>
					  </ul>
				  </li>
				  </li>
				  <cfif Not IsDefined("Session.club_id")>
					<li><a href="login.cfm">Admins</a>
					</li>
				  <cfelse>
					<cfinclude template="admin_nav.cfm">
				  </cfif>
				</ul>
			</div>
			
		</td>
		<td align="right" style="font-size: 12pt;">
			<a href="create_club.cfm" style="color:black;text-decoration:none;font-weight:bold;">+Create a Club</a>&nbsp;&nbsp;
			<a href="javascript:showClubSearch(true);" style="color:black;text-decoration:none;">Search Clubs</a>
		</td>
	</tr>
</table>
</div>


