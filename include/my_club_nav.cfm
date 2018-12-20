<li><a href="club_home.cfm">My Club &#9662;</a>
	<ul class="last">
		<cfoutput>
		<li><a href="club_home.cfm?club=#Cookie.defaultClub#">Club Profile</a></li>
		<li><a href="races_tab.cfm?club=#Cookie.defaultClub#">Races</a></li>
		<li><a href="leaders_tab.cfm?club=#Cookie.defaultClub#">Leaderboard</a></li>
		<li><a href="series_tab.cfm?club=#Cookie.defaultClub#">Series</a></li>
		<li><a href="racers_tab.cfm?club=#Cookie.defaultClub#">Racers</a></li>
		</cfoutput>
	 </ul>
</li>