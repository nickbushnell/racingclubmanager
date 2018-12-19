<cfif IsDefined("session.club_id")>
	<cfset structDelete(SESSION, "club_id")>
</cfif>

<cfif IsDefined("session.admin_id")>
	<cfset structDelete(SESSION, "admin_id")>
</cfif>

<cfif IsDefined("session.goto")>
	<cfset structDelete(SESSION, "goto")>
</cfif>

<cfif IsDefined("session.permission")>
	<cfset structDelete(SESSION, "permission")>
</cfif>

<cfif IsDefined("session.changePass_admin_id")>
	<cfset structDelete(SESSION, "changePass_admin_id")>
</cfif>

<cfif IsDefined("session.changePass_club_id")>
	<cfset structDelete(SESSION, "changePass_club_id")>
</cfif>


<cfif IsDefined("URL.message")>
	<cfset message = "?message=#URL.message#">
<cfelse>
	<cfset message = "?message=loggedOut">
</cfif>
<cflocation url="login.cfm#message#" addtoken="no">