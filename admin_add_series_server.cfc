<cfcomponent>




<!--- add new series --->
<cffunction output="no" name="add_new_series" access="remote" returntype="string">
	<cfargument name="name" type="string" required="true" />
	<cfargument name="type" type="string" required="true" />
	
	<cfif Not IsDefined("Session.club_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<cfif type EQ "Standard" Or type EQ "Multi-Class" Or type EQ "Teams">
		<!--- mint --->
	<cfelse>
		<cfreturn "error">
	</cfif>
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[add_new_series] 
			<cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
			, <cfqueryparam value="#doEncode(name)#" cfsqltype="cf_sql_varchar">
			, <cfqueryparam value="#type#" cfsqltype="cf_sql_varchar">
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