<cfcomponent>

<!--- get series --->
<cffunction output="no" name="get_series" access="remote" returntype="string">
	<cfargument name="club_id" type="numeric" required="true" />
	
	<cfset retVal = "">
	<cfquery name="getSeries" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_series] <cfqueryparam value="#club_id#" cfsqltype="cf_sql_integer">
		</cfoutput>
	</cfquery>
	
	<cfoutput query="getSeries">
		
		<cfset idx = 0>
		
		<cfloop list="#ArrayToList(getSeries.getColumnNames())#" index="col">
			<cfset idx = idx + 1>
			<cfset retVal = retVal & "#getSeries[col][currentrow]#">
			
			<cfif idx LT ListLen(ArrayToList(getSeries.getColumnNames()))>
				<cfset retVal = retVal & "|">
			</cfif>
		</cfloop>
		
		<cfif getSeries.CurrentRow LT getSeries.RecordCount>
			<cfset retVal = retVal & "<row>">
		</cfif>
	</cfoutput>

	<cfreturn retVal>
</cffunction>

<!--- get series inactive --->
<cffunction output="no" name="get_series_inactive" access="remote" returntype="string">
	<cfargument name="club_id" type="numeric" required="true" />
	
	<cfset retVal = "">
	<cfquery name="getSeries" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_series_inactive] <cfqueryparam value="#club_id#" cfsqltype="cf_sql_integer">
		</cfoutput>
	</cfquery>
	
	<cfoutput query="getSeries">
		
		<cfset idx = 0>
		
		<cfloop list="#ArrayToList(getSeries.getColumnNames())#" index="col">
			<cfset idx = idx + 1>
			<cfset retVal = retVal & "#getSeries[col][currentrow]#">
			
			<cfif idx LT ListLen(ArrayToList(getSeries.getColumnNames()))>
				<cfset retVal = retVal & "|">
			</cfif>
		</cfloop>
		
		<cfif getSeries.CurrentRow LT getSeries.RecordCount>
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

<!--- get race summary --->
<cffunction output="no" name="get_race_summary" access="remote" returntype="string">
	<cfargument name="race_id" type="numeric" required="true" />
	
	<cfset retVal = "">
	<cfquery name="getAllResults" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_race_summary] <cfqueryparam value="#race_id#" cfsqltype="cf_sql_integer">
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

</cfcomponent>