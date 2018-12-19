<cfcomponent>

<!--- get club name --->
<cffunction output="no" name="change_password" access="remote" returntype="string">
	<cfargument name="oldPass" type="string" required="true" />
	<cfargument name="newPass" type="string" required="true" />
	<cfargument name="confirmPass" type="string" required="true" />
	
	<!--- make sure newPass matches confirmPass --->
	<cfif Compare(newPass, confirmPass) NEQ 0>
		<cfreturn "error1">
	</cfif>
	
	<!--- check that the new password uses only the allowed characters --->
	<cfloop index="i" from="1" to="#Len(newPass)#">
		<cfset thisChar = Asc(Mid(newPass,i,1))>
		<cfif thisChar EQ 32 
		   OR thisChar EQ 46
		   OR thisChar EQ 95
		   OR thisChar EQ 33
		   OR thisChar EQ 36
		   OR thisChar EQ 37
		   OR thisChar EQ 38
		   OR thisChar EQ 42
		   OR thisChar EQ 43
		   OR thisChar EQ 94
		   OR thisChar EQ 64
		   OR (thisChar GTE 48 AND thisChar LTE 57)
		   OR (thisChar GTE 65 AND thisChar LTE 90)
		   OR (thisChar GTE 97 AND thisChar LTE 122)
		>
			<!--- good --->
		<cfelse>
			<!--- bad character --->
			<cfreturn "error2">
		</cfif>
	</cfloop>
	
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[change_password] <cfqueryparam value="#session.changePass_club_id#" cfsqltype="cf_sql_integer">
									, <cfqueryparam value="#session.changePass_admin_id#" cfsqltype="cf_sql_integer">
									, <cfqueryparam value="#oldPass#" cfsqltype="cf_sql_varchar">
									, <cfqueryparam value="#newPass#" cfsqltype="cf_sql_varchar">
		</cfoutput>
	</cfquery>
	
	<cfif myQRY.msg EQ "good">
		<cfif IsDefined("session.changePass_admin_id") And IsDefined("session.changePass_club_id")>
			<cfset session.admin_id = session.changePass_admin_id>
			<cfset session.club_id = session.changePass_club_id>
			<cfset structDelete(SESSION, "changePass_admin_id")>
			<cfset structDelete(SESSION, "changePass_club_id")>
			<cfreturn "good">
		</cfif>
	<cfelse>
		<cfreturn "error3">
	</cfif>
	
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