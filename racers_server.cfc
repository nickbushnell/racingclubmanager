<cfcomponent>
	
	<!--- get racers --->
	<cffunction output="no" name="get_racers" access="remote" returntype="string">
		<cfargument name="club_id" type="numeric" required="true" />
		
		<cfset retVal = "">
		<cfquery name="getRacers" datasource="ds_rdt3">
			<cfoutput>
			EXEC [dbo].[get_racers] <cfqueryparam value="#club_id#" cfsqltype="cf_sql_integer">
			</cfoutput>
		</cfquery>
		
		<cfoutput query="getRacers">
			
			<cfset idx = 0>
			
			<cfloop list="#ArrayToList(getRacers.getColumnNames())#" index="col">
				<cfset idx = idx + 1>
				<cfset retVal = retVal & "#getRacers[col][currentrow]#">
				
				<cfif idx LT ListLen(ArrayToList(getRacers.getColumnNames()))>
					<cfset retVal = retVal & "|">
				</cfif>
			</cfloop>
			
			<cfif getRacers.CurrentRow LT getRacers.RecordCount>
				<cfset retVal = retVal & "<row>">
			</cfif>
		</cfoutput>

		<cfreturn retVal>
	</cffunction>
	
	
	
	
	
</cfcomponent>