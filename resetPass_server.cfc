<cfcomponent>

<!--- get club name --->
<cffunction output="no" name="reset_password" access="remote" returntype="string">
	<cfargument name="club" type="string" required="true" />
	<cfargument name="login" type="string" required="true" />
	<cfargument name="email" type="string" required="true" />
	
	<cfoutput>
	<cfset strSQL = "" ><!---"EXEC [dbo].[reset_password] '#doEncode(club)#', '#doEncode(login)#', '#doEncode(email)#'">--->
	</cfoutput>
	
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[reset_password] <cfqueryparam value="#doEncode(club)#" cfsqltype="cf_sql_varchar">
									, <cfqueryparam value="#doEncode(login)#" cfsqltype="cf_sql_varchar">
									, <cfqueryparam value="#doEncode(email)#" cfsqltype="cf_sql_varchar">
		</cfoutput>
	</cfquery>
	
	<cfif myQRY.msg EQ "good">
		<cftry>
			<cfoutput>
			<cfmail to="#email#" from="rcm@racingclubmanager.com" subject="Racing Club Manager Password Reset" type="html">
				You have requested to reset your password.<br />
				Your temporary password is: #myQRY.new_password#<br />
				When you log in, you will be prompted to change your password.
			</cfmail>
			</cfoutput>
		
			<cfcatch>
				<cfreturn "sendMailError">
			</cfcatch>
		</cftry>
		
		<cfreturn "good">
	<cfelse>
		<cfreturn myQRY.msg & "<row>" & strSQL>
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