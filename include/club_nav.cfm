<cfset thisClubId = 0>
<cfset defaultClub = 0>

<cfif IsDefined("Cookie.defaultClub")>
	<cfset defaultClub = Cookie.defaultClub>
</cfif>

<cfif IsDefined("URL.club")>
	<cfif URL.club NEQ defaultClub>
		<cfset thisClubId = URL.club>
	</cfif>
<cfelseif IsDefined("Session.club_id")>
	<cfif Session.club_id NEQ defaultClub>
		<cfset thisClubId = Session.club_id>
	</cfif>
</cfif>

<cfif thisClubId GT 0>
	<cfquery name="clubNameQRY" datasource="ds_rdt3">
		EXEC [dbo].[get_club] #thisClubId#
	</cfquery>
	
	<cfset dots = "">
	<cfif Len(clubNameQRY.club_name) GT 10>
		<cfset dots = "...">
	</cfif>
	
	<cfoutput>
		<li><a href="club_home.cfm?club=#thisClubId#">#Left(clubNameQRY.club_name, 10)##dots# &##9662;</a>
			<ul class="last">
				<li><a href="club_home.cfm?club=#thisClubId#">Club Profile</a></li>
				<li><a href="races_tab.cfm?club=#thisClubId#">Races</a></li>
				<li><a href="leaders_tab.cfm?club=#thisClubId#">Leaderboard</a></li>
				<li><a href="series_tab.cfm?club=#thisClubId#">Series</a></li>
				<li><a href="racers_tab.cfm?club=#thisClubId#">Racers</a></li>
			 </ul>
		</li>
	</cfoutput>
</cfif>