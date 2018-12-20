<cfif IsDefined("Session.club_id") And IsDefined("Session.admin_id") And IsDefined("Session.permission")>

<li><a href="login.cfm">Admins &#9662;</a>
<ul class="last">
	<!--- only permission 0 can access the club profile --->
	<cfif session.permission EQ 0>
	<li><a href="club_profile.cfm">Club Profile</a></li>
	</cfif>
	
	<!--- permission 0,1 get this --->
	<cfif session.permission LTE 1>
	<li><a href="admin_races_results.cfm">Races</a></li>
	<li><a href="admin_club_members.cfm">Members</a></li>
	</cfif>

	
	<!--- everyone gets this --->
	<li><a href="requests_home.cfm">Join Requests</a></li>
	<li><a href="logout.cfm">Logout</a></li>
</ul>
</li>
</cfif>