<cfcomponent>

<!--- get all racers in this club --->
<cffunction output="no" name="get_admin_racers" access="remote" returntype="string">

	<cfif Not IsDefined("Session.club_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_admin_racers] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
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

<!--- save racer --->
<cffunction output="no" name="save_racer" access="remote" returntype="string">
	<cfargument name="racer_id" type="numeric" required="true" />
	<cfargument name="racer_name" type="string" required="true" />
	<cfargument name="active" type="string" required="true" />
	
	<cfif Not IsDefined("Session.club_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[save_racer] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
								, <cfqueryparam value="#racer_id#" cfsqltype="cf_sql_integer">
								, <cfqueryparam value="#racer_name#" cfsqltype="cf_sql_varchar">
								, <cfqueryparam value="#active#" cfsqltype="cf_sql_varchar">
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

<!--- delete racer --->
<cffunction output="no" name="delete_racer" access="remote" returntype="string">
	<cfargument name="racer_id" type="numeric" required="true" />
	
	<cfif Not IsDefined("Session.club_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[delete_racer] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
								, <cfqueryparam value="#racer_id#" cfsqltype="cf_sql_integer">
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