<cfcomponent>


<cffunction output="no" name="get_recent_results" access="remote" returntype="string">
	<cfargument name="club_id" type="numeric" required="true" />
	
	<cfset retVal = "">
	<cfquery name="getRecentResults" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_recent_results] <cfqueryparam value="#club_id#" cfsqltype="cf_sql_integer">
		</cfoutput>
	</cfquery>
	
	<cfoutput query="getRecentResults">
		
		<cfset idx = 0>
		
		<cfloop list="#ArrayToList(getRecentResults.getColumnNames())#" index="col">
			<cfset idx = idx + 1>
			<cfset retVal = retVal & "#getRecentResults[col][currentrow]#">
			
			<cfif idx LT ListLen(ArrayToList(getRecentResults.getColumnNames()))>
				<cfset retVal = retVal & "|">
			</cfif>
		</cfloop>
		
		<cfif getRecentResults.CurrentRow LT getRecentResults.RecordCount>
			<cfset retVal = retVal & "<row>">
		</cfif>
	</cfoutput>

	<cfreturn retVal>
</cffunction>

<cffunction output="no" name="get_upcoming_races" access="remote" returntype="string">
	<cfargument name="club_id" type="numeric" required="true" />
	
	<cfset retVal = "">
	<cfquery name="getUpcomingRaces" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_upcoming_races] <cfqueryparam value="#club_id#" cfsqltype="cf_sql_integer">
		</cfoutput>
	</cfquery>
	
	<cfoutput query="getUpcomingRaces">
		
		<cfset idx = 0>
		
		<cfloop list="#ArrayToList(getUpcomingRaces.getColumnNames())#" index="col">
			<cfset idx = idx + 1>
			<cfset retVal = retVal & "#getUpcomingRaces[col][currentrow]#">
			
			<cfif idx LT ListLen(ArrayToList(getUpcomingRaces.getColumnNames()))>
				<cfset retVal = retVal & "|">
			</cfif>
		</cfloop>
		
		<cfif getUpcomingRaces.CurrentRow LT getUpcomingRaces.RecordCount>
			<cfset retVal = retVal & "<row>">
		</cfif>
	</cfoutput>

	<cfreturn retVal>
</cffunction>

<!--- get race details --->
<cffunction output="no" name="get_race_details" access="remote" returntype="string">
	<cfargument name="race_id" type="numeric" required="true" />
	
	<cfset retVal = "">
	<cfquery name="getRaceDetails" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_race_details] <cfqueryparam value="#race_id#" cfsqltype="cf_sql_integer">
		</cfoutput>
	</cfquery>
	
	<cfoutput query="getRaceDetails">
		
		<cfset idx = 0>
		
		<cfloop list="#ArrayToList(getRaceDetails.getColumnNames())#" index="col">
			<cfset idx = idx + 1>
			<cfset retVal = retVal & "#getRaceDetails[col][currentrow]#">
			
			<cfif idx LT ListLen(ArrayToList(getRaceDetails.getColumnNames()))>
				<cfset retVal = retVal & "|">
			</cfif>
		</cfloop>
		
		<cfif getRaceDetails.CurrentRow LT getRaceDetails.RecordCount>
			<cfset retVal = retVal & "<row>">
		</cfif>
	</cfoutput>

	<cfreturn retVal>
</cffunction>

<!--- get ALL results --->
<cffunction output="no" name="get_all_results" access="remote" returntype="string">
	<cfargument name="club_id" type="numeric" required="true" />
	
	<cfset retVal = "">
	<cfquery name="getAllResults" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_all_results] <cfqueryparam value="#club_id#" cfsqltype="cf_sql_integer">
		</cfoutput>
	</cfquery>
	
	<cfoutput query="getAllResults">
		
		<cfset idx = 0>
		
		<cfloop list="#ArrayToList(getAllResults.getColumnNames())#" index="col">
			<cfset idx = idx + 1>
			<cfset retVal = retVal & "#getAllResults[col][currentrow]#">
			
			<cfif idx LT ListLen(ArrayToList(getAllResults.getColumnNames()))>
				<cfset retVal = retVal & "|">
			</cfif>
		</cfloop>
		
		<cfif getAllResults.CurrentRow LT getAllResults.RecordCount>
			<cfset retVal = retVal & "<row>">
		</cfif>
	</cfoutput>

	<cfreturn retVal>
</cffunction>

<!--- get race results --->
<cffunction output="no" name="get_race_results" access="remote" returntype="string">
	<cfargument name="race_id" type="numeric" required="true" />
	
	<cfset retVal = "">
	<cfquery name="getRaceResults" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_race_results] <cfqueryparam value="#race_id#" cfsqltype="cf_sql_integer">
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

<!--- get ALL upcoming --->
<cffunction output="no" name="get_all_upcoming_races" access="remote" returntype="string">
	<cfargument name="club_id" type="numeric" required="true" />
	
	<cfset retVal = "">
	<cfquery name="getAllResults" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_all_upcoming_races] <cfqueryparam value="#club_id#" cfsqltype="cf_sql_integer">
		</cfoutput>
	</cfquery>
	
	<cfoutput query="getAllResults">
		
		<cfset idx = 0>
		
		<cfloop list="#ArrayToList(getAllResults.getColumnNames())#" index="col">
			<cfset idx = idx + 1>
			<cfset retVal = retVal & "#getAllResults[col][currentrow]#">
			
			<cfif idx LT ListLen(ArrayToList(getAllResults.getColumnNames()))>
				<cfset retVal = retVal & "|">
			</cfif>
		</cfloop>
		
		<cfif getAllResults.CurrentRow LT getAllResults.RecordCount>
			<cfset retVal = retVal & "<row>">
		</cfif>
	</cfoutput>

	<cfreturn retVal>
</cffunction>

<!--- get series details --->
<cffunction output="no" name="get_series_details" access="remote" returntype="string">
	<cfargument name="series_id" type="numeric" required="true" />
	
	<cfset retVal = "">
	<cfquery name="getSeriesDetails" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_series_details] <cfqueryparam value="#series_id#" cfsqltype="cf_sql_integer">
		</cfoutput>
	</cfquery>
	
	<cfoutput query="getSeriesDetails">
		
		<cfset idx = 0>
		
		<cfloop list="#ArrayToList(getSeriesDetails.getColumnNames())#" index="col">
			<cfset idx = idx + 1>
			<cfset retVal = retVal & "#getSeriesDetails[col][currentrow]#">
			
			<cfif idx LT ListLen(ArrayToList(getSeriesDetails.getColumnNames()))>
				<cfset retVal = retVal & "|">
			</cfif>
		</cfloop>
		
		<cfif getSeriesDetails.CurrentRow LT getSeriesDetails.RecordCount>
			<cfset retVal = retVal & "<row>">
		</cfif>
	</cfoutput>

	<cfreturn retVal>
</cffunction>


</cfcomponent>