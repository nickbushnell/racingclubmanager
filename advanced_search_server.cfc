<cfcomponent>

<!--- get games --->
<cffunction output="no" name="get_games" access="remote" returntype="string">
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_all_games]
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

<!--- search for clubs --->
<cffunction output="no" name="get_search_results" access="remote" returntype="string">
	<cfargument name="game_id" type="numeric" required="true" />
	<cfargument name="time1" type="numeric" required="true" />
	<cfargument name="time2" type="numeric" required="true" />
	<cfargument name="offsetMins" type="numeric" required="true" />
	<cfargument name="days" type="numeric" required="true" />
	
	<!---
	<cfoutput>
	<cfreturn "EXEC [dbo].[get_search_results] #game_id#, #time1#, #time2#, #offsetMins#, #days#">
	</cfoutput>
	--->
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_search_results] <cfqueryparam value="#game_id#" cfsqltype="cf_sql_integer">
										, <cfqueryparam value="#time1#" cfsqltype="cf_sql_integer">
										, <cfqueryparam value="#time2#" cfsqltype="cf_sql_integer">
										, <cfqueryparam value="#offsetMins#" cfsqltype="cf_sql_integer">
										, <cfqueryparam value="#days#" cfsqltype="cf_sql_integer">
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
	
<!--- string encode function --->
<cffunction output="no" name="doEncode" returntype="string">
	<cfargument name="strVal" type="string" />
	
	<cfset strVal = Replace(strVal, Chr(34), "~chr34~", "All")>
	<cfset strVal = Replace(strVal, Chr(39), "~chr39~", "All")>
	<cfset strVal = Replace(strVal, Chr(35), "~chr35~", "All")>
	<cfset strVal = Replace(strVal, Chr(60), "~chr60~", "All")>
	<cfset strVal = Replace(strVal, Chr(62), "~chr62~", "All")>
	<cfset strVal = Replace(strVal, Chr(124), "~chr124~", "All")>
	
	<cfreturn strVal>
</cffunction>

</cfcomponent>