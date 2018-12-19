<cfcomponent>

<!--- get series details --->
<cffunction output="no" name="get_series_details" access="remote" returntype="string">
	<cfargument name="club_id" type="numeric" required="true" />
	<cfargument name="series_id" type="numeric" required="true" />
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_main_series_details] <cfqueryparam value="#club_id#" cfsqltype="cf_sql_integer">
											, <cfqueryparam value="#series_id#" cfsqltype="cf_sql_integer">
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

<cffunction output="no" name="getSeriesLeaderboard" returntype="string">
	<cfargument name="club_id" type="numeric" required="true" />
	<cfargument name="series_id" type="numeric" required="true" />
	
	<cfset retVal = "">
	<cfquery name="getRaceResults" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_series_leaderboard] <cfqueryparam value="#club_id#" cfsqltype="cf_sql_integer">
											, <cfqueryparam value="#series_id#" cfsqltype="cf_sql_integer">
		</cfoutput>
	</cfquery>
	
	<cfoutput query="getRaceResults">
		
		<cfset idx = 0>
		
		<cfloop list="#ArrayToList(getRaceResults.getColumnNames())#" index="col">
			<cfset idx = idx + 1>
			<cfset retVal = retVal & "#getRaceResults[col][currentrow]#">
			
			<cfif idx LT ListLen(ArrayToList(getRaceResults.getColumnNames()))>
				<cfset retVal = retVal & "|">
			</cfif>
		</cfloop>
		
		<cfif getRaceResults.CurrentRow LT getRaceResults.RecordCount>
			<cfset retVal = retVal & "<row>">
		</cfif>
	</cfoutput>

	<cfreturn retVal>
</cffunction>

<cffunction output="no" name="getSeriesTeamLeaderboard" returntype="string">
	<cfargument name="club_id" type="numeric" required="true" />
	<cfargument name="series_id" type="numeric" required="true" />
	
	<cfset retVal = "">
	<cfquery name="getRaceResults" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_series_team_leaderboard] <cfqueryparam value="#club_id#" cfsqltype="cf_sql_integer">
												, <cfqueryparam value="#series_id#" cfsqltype="cf_sql_integer">
		</cfoutput>
	</cfquery>
	
	<cfoutput query="getRaceResults">
		
		<cfset idx = 0>
		
		<cfloop list="#ArrayToList(getRaceResults.getColumnNames())#" index="col">
			<cfset idx = idx + 1>
			<cfset retVal = retVal & "#getRaceResults[col][currentrow]#">
			
			<cfif idx LT ListLen(ArrayToList(getRaceResults.getColumnNames()))>
				<cfset retVal = retVal & "|">
			</cfif>
		</cfloop>
		
		<cfif getRaceResults.CurrentRow LT getRaceResults.RecordCount>
			<cfset retVal = retVal & "<row>">
		</cfif>
	</cfoutput>

	<cfreturn retVal>
</cffunction>

<cffunction output="no" name="getSeriesTeamStandings" returntype="string">
	<cfargument name="club_id" type="numeric" required="true" />
	<cfargument name="series_id" type="numeric" required="true" />
	
	<cfset retVal = "">
	<cfquery name="getRaceResults" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_series_team_standings] <cfqueryparam value="#club_id#" cfsqltype="cf_sql_integer">
												, <cfqueryparam value="#series_id#" cfsqltype="cf_sql_integer">
		</cfoutput>
	</cfquery>
	
	<cfoutput query="getRaceResults">
		
		<cfset idx = 0>
		
		<cfloop list="#ArrayToList(getRaceResults.getColumnNames())#" index="col">
			<cfset idx = idx + 1>
			<cfset retVal = retVal & "#getRaceResults[col][currentrow]#">
			
			<cfif idx LT ListLen(ArrayToList(getRaceResults.getColumnNames()))>
				<cfset retVal = retVal & "|">
			</cfif>
		</cfloop>
		
		<cfif getRaceResults.CurrentRow LT getRaceResults.RecordCount>
			<cfset retVal = retVal & "<row>">
		</cfif>
	</cfoutput>

	<cfreturn retVal>
</cffunction>

<cffunction output="no" name="getSeriesTeamNames" returntype="string">
	<cfargument name="club_id" type="numeric" required="true" />
	<cfargument name="series_id" type="numeric" required="true" />
	
	<cfset retVal = "">
	<cfquery name="getRaceResults" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_series_team_members_teamName] <cfqueryparam value="#club_id#" cfsqltype="cf_sql_integer">
													, <cfqueryparam value="#series_id#" cfsqltype="cf_sql_integer">
		</cfoutput>
	</cfquery>
	
	<cfoutput query="getRaceResults">
		
		<cfset idx = 0>
		
		<cfloop list="#ArrayToList(getRaceResults.getColumnNames())#" index="col">
			<cfset idx = idx + 1>
			<cfset retVal = retVal & "#getRaceResults[col][currentrow]#">
			
			<cfif idx LT ListLen(ArrayToList(getRaceResults.getColumnNames()))>
				<cfset retVal = retVal & "|">
			</cfif>
		</cfloop>
		
		<cfif getRaceResults.CurrentRow LT getRaceResults.RecordCount>
			<cfset retVal = retVal & "<row>">
		</cfif>
	</cfoutput>

	<cfreturn retVal>
</cffunction>

<cffunction output="no" name="getPrivateerStandings" returntype="string">
	<cfargument name="club_id" type="numeric" required="true" />
	<cfargument name="series_id" type="numeric" required="true" />
	
	<cfset retVal = "">
	<cfquery name="getRaceResults" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_privateer_seriesStandings] <cfqueryparam value="#club_id#" cfsqltype="cf_sql_integer">
												, <cfqueryparam value="#series_id#" cfsqltype="cf_sql_integer">
		</cfoutput>
	</cfquery>
	
	<cfoutput query="getRaceResults">
		
		<cfset idx = 0>
		
		<cfloop list="#ArrayToList(getRaceResults.getColumnNames())#" index="col">
			<cfset idx = idx + 1>
			<cfset retVal = retVal & "#getRaceResults[col][currentrow]#">
			
			<cfif idx LT ListLen(ArrayToList(getRaceResults.getColumnNames()))>
				<cfset retVal = retVal & "|">
			</cfif>
		</cfloop>
		
		<cfif getRaceResults.CurrentRow LT getRaceResults.RecordCount>
			<cfset retVal = retVal & "<row>">
		</cfif>
	</cfoutput>

	<cfreturn retVal>
</cffunction>


<cffunction output="no" name="getSeriesMulticlassLeaderboard" returntype="string">
	<cfargument name="club_id" type="numeric" required="true" />
	<cfargument name="series_id" type="numeric" required="true" />
	
	<cfset retVal = "">
	<cfquery name="getRaceResults" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_series_multiclass_leaderboard] <cfqueryparam value="#club_id#" cfsqltype="cf_sql_integer">
													, <cfqueryparam value="#series_id#" cfsqltype="cf_sql_integer">
		</cfoutput>
	</cfquery>
	
	<cfoutput query="getRaceResults">
		
		<cfset idx = 0>
		
		<cfloop list="#ArrayToList(getRaceResults.getColumnNames())#" index="col">
			<cfset idx = idx + 1>
			<cfset retVal = retVal & "#getRaceResults[col][currentrow]#">
			
			<cfif idx LT ListLen(ArrayToList(getRaceResults.getColumnNames()))>
				<cfset retVal = retVal & "|">
			</cfif>
		</cfloop>
		
		<cfif getRaceResults.CurrentRow LT getRaceResults.RecordCount>
			<cfset retVal = retVal & "<row>">
		</cfif>
	</cfoutput>

	<cfreturn retVal>
</cffunction>



<!--- get leader board --->
<cffunction output="no" name="get_series_leaderboard" access="remote" returntype="string">
	<cfargument name="club_id" type="numeric" required="true" />
	<cfargument name="series_id" type="numeric" required="true" />
	<cfargument name="series_type" type="string" required="true" />
	
	<cfif series_type EQ "Multi-Class">
		<cfset tempResult1 = getSeriesMulticlassLeaderboard(club_id, series_id)>
		
		<cfreturn tempResult1>
	<cfelseif series_type EQ "Teams">
		<cfset tempResult1 = getSeriesTeamLeaderboard(club_id, series_id)>
		<cfset tempResult2 = getSeriesTeamStandings(club_id, series_id)>
		<cfset tempResult3 = getSeriesTeamNames(club_id, series_id)>
		<cfset tempResult4 = getPrivateerStandings(club_id, series_id)>
		
		<cfreturn tempResult1 & "<resultSet>" & tempResult2 & "<resultSet>" & tempResult3 & "<resultSet>" & tempResult4>
	<cfelseif series_type EQ "Standard">
		<cfset tempResult1 = getSeriesLeaderboard(club_id, series_id)>
		<cfreturn tempResult1>
	<cfelse>
		<cfreturn "typeError">
	</cfif>
	
</cffunction>

<!--- get list of races --->
<cffunction output="no" name="get_series_details_races" access="remote" returntype="string">
	<cfargument name="club_id" type="numeric" required="true" />
	<cfargument name="series_id" type="numeric" required="true" />
	
	<cfset retVal = "">
	<cfquery name="getRaceResults" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_series_details_races] <cfqueryparam value="#club_id#" cfsqltype="cf_sql_integer">
											, <cfqueryparam value="#series_id#" cfsqltype="cf_sql_integer">
		</cfoutput>
	</cfquery>
	
	<cfoutput query="getRaceResults">
		
		<cfset idx = 0>
		
		<cfloop list="#ArrayToList(getRaceResults.getColumnNames())#" index="col">
			<cfset idx = idx + 1>
			<cfset retVal = retVal & "#getRaceResults[col][currentrow]#">
			
			<cfif idx LT ListLen(ArrayToList(getRaceResults.getColumnNames()))>
				<cfset retVal = retVal & "|">
			</cfif>
		</cfloop>
		
		<cfif getRaceResults.CurrentRow LT getRaceResults.RecordCount>
			<cfset retVal = retVal & "<row>">
		</cfif>
	</cfoutput>

	<cfreturn retVal>
</cffunction>



</cfcomponent>