<cfcomponent>
	
	<!--- GET ALL CLUBS --->
	<cffunction output="no" name="get_all_clubs" access="remote" returntype="string">
		<cfset retVal = "">
		<cfquery name="getAllClubs" datasource="ds_rdt3">
			EXEC [dbo].[get_all_clubs]
		</cfquery>
		
		<cfoutput query="getAllClubs">
			
			<cfset idx = 0>
			
			<cfloop list="#ArrayToList(getAllClubs.getColumnNames())#" index="col">
				<cfset idx = idx + 1>
				<cfset retVal = retVal & "#getAllClubs[col][currentrow]#">
				
				<cfif idx LT ListLen(ArrayToList(getAllClubs.getColumnNames()))>
					<cfset retVal = retVal & "|">
				</cfif>
			</cfloop>
			
			<cfif getAllClubs.CurrentRow LT getAllClubs.RecordCount>
				<cfset retVal = retVal & "<row>">
			</cfif>
		</cfoutput>

		<cfreturn retVal>
	</cffunction>
	 
	 
	 <!--- get typed club results --->
	<cffunction output="no" name="get_typed_clubs" access="remote" returntype="string">
		<cfargument name="search_value" type="string" required="true" />
		
		<cfset retVal = "">
		<cfquery name="theQuery" datasource="ds_rdt3">
			<cfoutput>
			EXEC [dbo].[get_typed_clubs] <cfqueryparam value="#search_value#" cfsqltype="cf_sql_varchar">
			</cfoutput>
		</cfquery>
		
		<cfoutput query="theQuery">
			
			<cfset idx = 0>
			
			<cfloop list="#ArrayToList(theQuery.getColumnNames())#" index="col">
				<cfset idx = idx + 1>
				<cfset retVal = retVal & "#theQuery[col][currentrow]#">
				
				<cfif idx LT ListLen(ArrayToList(theQuery.getColumnNames()))>
					<cfset retVal = retVal & "|">
				</cfif>
			</cfloop>
			
			<cfif theQuery.CurrentRow LT theQuery.RecordCount>
				<cfset retVal = retVal & "<row>">
			</cfif>
		</cfoutput>

		<cfreturn retVal>
	</cffunction>
</cfcomponent>