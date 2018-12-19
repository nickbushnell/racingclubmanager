<cfcomponent>


<!--- get pending requests --->
	<cffunction output="no" name="get_pending_requests" access="remote" returntype="string">
		
		<cfif Not IsDefined("Session.club_id")>
			<cfreturn "sessionError">
		</cfif>
		
		<cfset retVal = "">
		<cfquery name="myQRY" datasource="ds_rdt3">
			<cfoutput>
			EXEC [dbo].[get_admin_requests_pending] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
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
	
	<!--- get reviewed requests --->
	<cffunction output="no" name="get_reviewed_requests" access="remote" returntype="string">
		<cfargument name="strStatus" type="string" required="true" />
		
		<cfif Not IsDefined("Session.club_id")>
			<cfreturn "sessionError">
		</cfif>
		
		<cfset retVal = "">
		<cfquery name="myQRY" datasource="ds_rdt3">
			<cfoutput>
			EXEC [dbo].[get_admin_requests_reviewed] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
													, <cfqueryparam value="#Trim(strStatus)#" cfsqltype="cf_sql_varchar">
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


</cfcomponent>