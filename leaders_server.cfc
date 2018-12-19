<cfcomponent>

<!--- get leaderboard date filters --->
<cffunction output="no" name="get_leaderboard_date_filters" access="remote" returntype="string">
	<cfargument name="club_id" type="numeric" required="true" />
	<cfargument name="utc_offset_mins" type="numeric" required="true" />
	
	<cfset retVal = "">
	<cfquery name="getQryResults" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_leaderboard_date_filters] <cfqueryparam value="#club_id#" cfsqltype="cf_sql_integer">
												, <cfqueryparam value="#utc_offset_mins#" cfsqltype="cf_sql_integer">
		</cfoutput>
	</cfquery>
	
	<cfoutput query="getQryResults">
		
		<cfset idx = 0>
		
		<cfloop list="#ArrayToList(getQryResults.getColumnNames())#" index="col">
			<cfset idx = idx + 1>
			<cfset retVal = retVal & "#getQryResults[col][currentrow]#">
			
			<cfif idx LT ListLen(ArrayToList(getQryResults.getColumnNames()))>
				<cfset retVal = retVal & "|">
			</cfif>
		</cfloop>
		
		<cfif getQryResults.CurrentRow LT getQryResults.RecordCount>
			<cfset retVal = retVal & "<row>">
		</cfif>
	</cfoutput>

	<cfreturn retVal>
</cffunction>

<!--- leaderboard --->
<cffunction output="no" name="get_leaderboard" access="remote" returntype="string">
	<cfargument name="club_id" type="numeric" required="true" />
	<cfargument name="theYear" type="numeric" required="true" />
	<cfargument name="theMonth" type="numeric" required="true" />
	<cfargument name="UTCoffsetMins" type="numeric" required="true" />
	
	<cfset retVal = "">
	<cfquery name="getLeaderboard" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_leaderboard] <cfqueryparam value="#club_id#" cfsqltype="cf_sql_integer">
									, <cfqueryparam value="#theYear#" cfsqltype="cf_sql_integer">
									, <cfqueryparam value="#theMonth#" cfsqltype="cf_sql_integer">
									, <cfqueryparam value="#UTCoffsetMins#" cfsqltype="cf_sql_integer">
		</cfoutput>
	</cfquery>
	
	<cfoutput query="getLeaderboard">
		
		<cfset idx = 0>
		
		<cfloop list="#ArrayToList(getLeaderboard.getColumnNames())#" index="col">
			<cfset idx = idx + 1>
			<cfset retVal = retVal & "#getLeaderboard[col][currentrow]#">
			
			<cfif idx LT ListLen(ArrayToList(getLeaderboard.getColumnNames()))>
				<cfset retVal = retVal & "|">
			</cfif>
		</cfloop>
		
		<cfif getLeaderboard.CurrentRow LT getLeaderboard.RecordCount>
			<cfset retVal = retVal & "<row>">
		</cfif>
	</cfoutput>

	<cfreturn retVal>
</cffunction>



</cfcomponent>