<cfcomponent>

<!--- get club name --->
<cffunction output="no" name="get_race_details" access="remote" returntype="string">
	<cfargument name="club_id" type="numeric" required="true" />
	<cfargument name="race_id" type="numeric" required="true" />
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_main_race_details] <cfqueryparam value="#club_id#" cfsqltype="cf_sql_integer">
										 , <cfqueryparam value="#race_id#" cfsqltype="cf_sql_integer">
		</cfoutput>
	</cfquery>
	
	<cfoutput query="myQRY">
		
		<cfset idx = 0>
		
		<cfloop list="#ArrayToList(myQRY.getColumnNames())#" index="col">
			<cfset idx = idx + 1>
			<cfset retVal = retVal & "#myQRY[col][currentrow]#">
			
			<cfif idx LT ListLen(ArrayToList(myQRY.getColumnNames()))>
				<cfset retVal = retVal & "|">
			</cfif>
		</cfloop>
		
		<cfif myQRY.CurrentRow LT myQRY.RecordCount>
			<cfset retVal = retVal & "<row>">
		</cfif>
	</cfoutput>

	<cfreturn retVal>
</cffunction>

<!--- get series standings including this race --->
<cffunction output="no" name="getSeriesStandingsIncludingRace" returntype="string">
	<cfargument name="club_id" type="numeric" required="true" />
	<cfargument name="race_id" type="numeric" required="true" />
	
	<cfset retVal = "">
	
	
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_standings_includingRace] <cfqueryparam value="#club_id#" cfsqltype="cf_sql_integer">
											   , <cfqueryparam value="#race_id#" cfsqltype="cf_sql_integer">
		</cfoutput>
	</cfquery>
	
	<cfoutput query="myQRY">
		<cfset idx = 0>
		<cfloop list="#ArrayToList(myQRY.getColumnNames())#" index="col">
			<cfset idx = idx + 1>
			<cfset retVal = retVal & "#myQRY[col][currentrow]#">
			
			<cfif idx LT ListLen(ArrayToList(myQRY.getColumnNames()))>
				<cfset retVal = retVal & "|">
			</cfif>
		</cfloop>
		
		<cfif myQRY.CurrentRow LT myQRY.RecordCount>
			<cfset retVal = retVal & "<row>">
		</cfif>
	</cfoutput>
	
	<cfreturn retVal>
</cffunction>

<!--- get series standings including this race --->
<cffunction output="no" name="getSeriesStandingsNotIncludingRace" returntype="string">
	<cfargument name="club_id" type="numeric" required="true" />
	<cfargument name="race_id" type="numeric" required="true" />
	
	<cfset retVal = "">
	
	
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_standings_notIncludingRace] <cfqueryparam value="#club_id#" cfsqltype="cf_sql_integer">
													, <cfqueryparam value="#race_id#" cfsqltype="cf_sql_integer">
		</cfoutput>
	</cfquery>
	
	<cfoutput query="myQRY">
		<cfset idx = 0>
		<cfloop list="#ArrayToList(myQRY.getColumnNames())#" index="col">
			<cfset idx = idx + 1>
			<cfset retVal = retVal & "#myQRY[col][currentrow]#">
			
			<cfif idx LT ListLen(ArrayToList(myQRY.getColumnNames()))>
				<cfset retVal = retVal & "|">
			</cfif>
		</cfloop>
		
		<cfif myQRY.CurrentRow LT myQRY.RecordCount>
			<cfset retVal = retVal & "<row>">
		</cfif>
	</cfoutput>
	
	<cfreturn retVal>
</cffunction>

<!--- get team abbreviations and members --->
<!--- changed SP to get team names instead of abbr --->
<cffunction output="no" name="getTeamMembersAbbr" returntype="string">
	<cfargument name="club_id" type="numeric" required="true" />
	<cfargument name="race_id" type="numeric" required="true" />
	
	<cfset retVal = "">
	
	
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_team_members_teamName] <cfqueryparam value="#club_id#" cfsqltype="cf_sql_integer">
											, <cfqueryparam value="#race_id#" cfsqltype="cf_sql_integer">
		</cfoutput>
	</cfquery>
	
	<cfoutput query="myQRY">
		<cfset idx = 0>
		<cfloop list="#ArrayToList(myQRY.getColumnNames())#" index="col">
			<cfset idx = idx + 1>
			<cfset retVal = retVal & "#myQRY[col][currentrow]#">
			
			<cfif idx LT ListLen(ArrayToList(myQRY.getColumnNames()))>
				<cfset retVal = retVal & "|">
			</cfif>
		</cfloop>
		
		<cfif myQRY.CurrentRow LT myQRY.RecordCount>
			<cfset retVal = retVal & "<row>">
		</cfif>
	</cfoutput>
	
	<cfreturn retVal>
</cffunction>

<!--- get team series standings including this race --->
<cffunction output="no" name="getTeamStandingsIncludingRace" returntype="string">
	<cfargument name="club_id" type="numeric" required="true" />
	<cfargument name="race_id" type="numeric" required="true" />
	
	<cfset retVal = "">
	
	
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_team_standings_includingRace] <cfqueryparam value="#club_id#" cfsqltype="cf_sql_integer">
													, <cfqueryparam value="#race_id#" cfsqltype="cf_sql_integer">
		</cfoutput>
	</cfquery>
	
	<cfoutput query="myQRY">
		<cfset idx = 0>
		<cfloop list="#ArrayToList(myQRY.getColumnNames())#" index="col">
			<cfset idx = idx + 1>
			<cfset retVal = retVal & "#myQRY[col][currentrow]#">
			
			<cfif idx LT ListLen(ArrayToList(myQRY.getColumnNames()))>
				<cfset retVal = retVal & "|">
			</cfif>
		</cfloop>
		
		<cfif myQRY.CurrentRow LT myQRY.RecordCount>
			<cfset retVal = retVal & "<row>">
		</cfif>
	</cfoutput>
	
	<cfreturn retVal>
</cffunction>

<!--- get series standings not including this race --->
<cffunction output="no" name="getTeamStandingsNotIncludingRace" returntype="string">
	<cfargument name="club_id" type="numeric" required="true" />
	<cfargument name="race_id" type="numeric" required="true" />
	
	<cfset retVal = "">
	
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_team_standings_notIncludingRace] <cfqueryparam value="#club_id#" cfsqltype="cf_sql_integer">
														, <cfqueryparam value="#race_id#" cfsqltype="cf_sql_integer">
		</cfoutput>
	</cfquery>
	
	<cfoutput query="myQRY">
		<cfset idx = 0>
		<cfloop list="#ArrayToList(myQRY.getColumnNames())#" index="col">
			<cfset idx = idx + 1>
			<cfset retVal = retVal & "#myQRY[col][currentrow]#">
			
			<cfif idx LT ListLen(ArrayToList(myQRY.getColumnNames()))>
				<cfset retVal = retVal & "|">
			</cfif>
		</cfloop>
		
		<cfif myQRY.CurrentRow LT myQRY.RecordCount>
			<cfset retVal = retVal & "<row>">
		</cfif>
	</cfoutput>
	
	<cfreturn retVal>
</cffunction>

<cffunction output="no" name="getPrivateersRaceResults" returntype="string">
	<cfargument name="club_id" type="numeric" required="true" />
	<cfargument name="race_id" type="numeric" required="true" />
	
	<cfset retVal = "">
	
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_privateer_results] <cfqueryparam value="#club_id#" cfsqltype="cf_sql_integer">
											, <cfqueryparam value="#race_id#" cfsqltype="cf_sql_integer">
		</cfoutput>
	</cfquery>
	
	<cfoutput query="myQRY">
		<cfset idx = 0>
		<cfloop list="#ArrayToList(myQRY.getColumnNames())#" index="col">
			<cfset idx = idx + 1>
			<cfset retVal = retVal & "#myQRY[col][currentrow]#">
			
			<cfif idx LT ListLen(ArrayToList(myQRY.getColumnNames()))>
				<cfset retVal = retVal & "|">
			</cfif>
		</cfloop>
		
		<cfif myQRY.CurrentRow LT myQRY.RecordCount>
			<cfset retVal = retVal & "<row>">
		</cfif>
	</cfoutput>
	
	<cfreturn retVal>
</cffunction>

<!--- get Privateer series standings including this race --->
<cffunction output="no" name="getPrivateersStandingsIncludingRace" returntype="string">
	<cfargument name="club_id" type="numeric" required="true" />
	<cfargument name="race_id" type="numeric" required="true" />
	
	<cfset retVal = "">
	
	
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_privateer_standings_includingRace] <cfqueryparam value="#club_id#" cfsqltype="cf_sql_integer">
															, <cfqueryparam value="#race_id#" cfsqltype="cf_sql_integer">
		</cfoutput>
	</cfquery>
	
	<cfoutput query="myQRY">
		<cfset idx = 0>
		<cfloop list="#ArrayToList(myQRY.getColumnNames())#" index="col">
			<cfset idx = idx + 1>
			<cfset retVal = retVal & "#myQRY[col][currentrow]#">
			
			<cfif idx LT ListLen(ArrayToList(myQRY.getColumnNames()))>
				<cfset retVal = retVal & "|">
			</cfif>
		</cfloop>
		
		<cfif myQRY.CurrentRow LT myQRY.RecordCount>
			<cfset retVal = retVal & "<row>">
		</cfif>
	</cfoutput>
	
	<cfreturn retVal>
</cffunction>

<!--- get Privateer series standings including this race --->
<cffunction output="no" name="getPrivateersStandingsNotIncludingRace" returntype="string">
	<cfargument name="club_id" type="numeric" required="true" />
	<cfargument name="race_id" type="numeric" required="true" />
	
	<cfset retVal = "">
	
	
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_privateer_standings_notIncludingRace] <cfqueryparam value="#club_id#" cfsqltype="cf_sql_integer">
															, <cfqueryparam value="#race_id#" cfsqltype="cf_sql_integer">
		</cfoutput>
	</cfquery>
	
	<cfoutput query="myQRY">
		<cfset idx = 0>
		<cfloop list="#ArrayToList(myQRY.getColumnNames())#" index="col">
			<cfset idx = idx + 1>
			<cfset retVal = retVal & "#myQRY[col][currentrow]#">
			
			<cfif idx LT ListLen(ArrayToList(myQRY.getColumnNames()))>
				<cfset retVal = retVal & "|">
			</cfif>
		</cfloop>
		
		<cfif myQRY.CurrentRow LT myQRY.RecordCount>
			<cfset retVal = retVal & "<row>">
		</cfif>
	</cfoutput>
	
	<cfreturn retVal>
</cffunction>

<!--- get the actual results --->
<cffunction output="no" name="getRaceResults" returntype="string">
	<cfargument name="club_id" type="numeric" required="true" />
	<cfargument name="race_id" type="numeric" required="true" />
	<cfargument name="series_type" type="string" required="true" />
	
	<cfset retVal = "">
	
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_race_results] <cfqueryparam value="#club_id#" cfsqltype="cf_sql_integer">
									, <cfqueryparam value="#race_id#" cfsqltype="cf_sql_integer">
									, <cfqueryparam value="#series_type#" cfsqltype="cf_sql_varchar">
		</cfoutput>
	</cfquery>
	
	<cfoutput query="myQRY">
		<cfset idx = 0>
		<cfloop list="#ArrayToList(myQRY.getColumnNames())#" index="col">
			<cfset idx = idx + 1>
			<cfset retVal = retVal & "#myQRY[col][currentrow]#">
			
			<cfif idx LT ListLen(ArrayToList(myQRY.getColumnNames()))>
				<cfset retVal = retVal & "|">
			</cfif>
		</cfloop>
		
		<cfif myQRY.CurrentRow LT myQRY.RecordCount>
			<cfset retVal = retVal & "<row>">
		</cfif>
	</cfoutput>
	
	<cfreturn retVal>
</cffunction>

<!--- get race results --->
<cffunction output="no" name="get_race_results" access="remote" returntype="string">
	<cfargument name="race_id" type="numeric" required="true" />
	<cfargument name="series_type" type="string" required="true" />
	<cfargument name="club_id" type="numeric" required="true" />

	
	<cfif series_type EQ "Multi-Class">
		<cfset tempResult1 = getRaceResults(club_id, race_id, series_type)>
		<cfset tempResult2 = getSeriesStandingsIncludingRace(club_id, race_id)>
		<cfset tempResult3 = getSeriesStandingsNotIncludingRace(club_id, race_id)>

		<cfreturn tempResult1 & "<resultSet>" & tempResult2 & "<resultSet>" & tempResult3>
	<cfelseif series_type EQ "Teams">
		<cfset tempResult1 = getRaceResults(club_id, race_id, "")>
		<cfset tempResult2 = getSeriesStandingsIncludingRace(club_id, race_id)>
		<cfset tempResult3 = getSeriesStandingsNotIncludingRace(club_id, race_id)>
		<cfset tempResult4 = getRaceResults(club_id, race_id, series_type)>
		<cfset tempResult5 = getTeamMembersAbbr(club_id, race_id)>
		<cfset tempResult6 = getTeamStandingsIncludingRace(club_id, race_id)>
		<cfset tempResult7 = getTeamStandingsNotIncludingRace(club_id, race_id)>
		<cfset tempResult8 = getPrivateersRaceResults(club_id, race_id)>
		<cfset tempResult9 = getPrivateersStandingsIncludingRace(club_id, race_id)>
		<cfset tempResult10 = getPrivateersStandingsNotIncludingRace(club_id, race_id)>
		
		<cfreturn tempResult1 & "<resultSet>" 
				& tempResult2 & "<resultSet>" 
				& tempResult3 & "<resultSet>" 
				& tempResult4 & "<resultSet>" 
				& tempResult5 & "<resultSet>" 
				& tempResult6 & "<resultSet>" 
				& tempResult7 & "<resultSet>" 
				& tempResult8 & "<resultSet>" 
				& tempResult9 & "<resultSet>" 
				& tempResult10>
	<cfelseif series_type EQ "Standard">
		<cfset tempResult1 = getRaceResults(club_id, race_id, "")>
		<cfset tempResult2 = getSeriesStandingsIncludingRace(club_id, race_id)>
		<cfset tempResult3 = getSeriesStandingsNotIncludingRace(club_id, race_id)>
		
		<cfreturn tempResult1 & "<resultSet>" & tempResult2 & "<resultSet>" & tempResult3>
	<cfelse>
		<cfreturn "typeError">
	</cfif>
	
</cffunction>



</cfcomponent>