<cfcomponent>

<cffunction output="no" name="get_admins" access="remote" returntype="string">
	
	<cfif Not IsDefined("Session.club_id") And Not IsDefined("Session.admin_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_admin_admins] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
									, <cfqueryparam value="#session.admin_id#" cfsqltype="cf_sql_integer">
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


<cffunction output="no" name="check_login_unique" access="remote" returntype="string">
	<cfargument name="admin_id" type="numeric" required="true" />
	<cfargument name="login" type="string" required="true" />
	
	<cfif Not IsDefined("Session.club_id") And Not IsDefined("Session.admin_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<!---<cfreturn "[" & admin_id & "] [" & login & "]">--->
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[check_login_unique] <cfqueryparam value="#admin_id#" cfsqltype="cf_sql_integer">
										, <cfqueryparam value="#login#" cfsqltype="cf_sql_varchar">
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


<cffunction output="no" name="delete_admin" access="remote" returntype="string">
	<cfargument name="admin_id" type="numeric" required="true" />
	
	<cfif Not IsDefined("Session.club_id") And Not IsDefined("Session.admin_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[delete_admin] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
								, <cfqueryparam value="#admin_id#" cfsqltype="cf_sql_integer">
								, <cfqueryparam value="#session.admin_id#" cfsqltype="cf_sql_integer">
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

<cffunction output="no" name="save_admin" access="remote" returntype="string">
	<cfargument name="admin_id" type="numeric" required="true" />
	<cfargument name="login" type="string" required="true" />
	<cfargument name="email" type="string" required="true" />
	<cfargument name="permission" type="numeric" required="true" />
	<cfargument name="joinMail" type="numeric" required="true" />
	
	<cfif Not IsDefined("Session.club_id") And Not IsDefined("Session.admin_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<!--- check that the new password uses only the allowed characters --->
	<cfloop index="i" from="1" to="#Len(login)#">
		<cfset thisChar = Asc(Mid(login,i,1))>
		<cfif thisChar EQ 32 
		   OR thisChar EQ 46
		   OR thisChar EQ 95
		   OR (thisChar GTE 48 AND thisChar LTE 57)
		   OR (thisChar GTE 65 AND thisChar LTE 90)
		   OR (thisChar GTE 97 AND thisChar LTE 122)
		>
			<!--- good --->
		<cfelse>
			<!--- bad character --->
			<cfreturn "invalidError">
		</cfif>
	</cfloop>
	
	<cfif Not IsValid("email", email)>
		<cfreturn "emailError">
	</cfif>
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[save_admin] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
								, <cfqueryparam value="#admin_id#" cfsqltype="cf_sql_integer">
								, <cfqueryparam value="#login#" cfsqltype="cf_sql_varchar">
								, <cfqueryparam value="#email#" cfsqltype="cf_sql_varchar">
								, <cfqueryparam value="#permission#" cfsqltype="cf_sql_integer">
								, <cfqueryparam value="#joinMail#" cfsqltype="cf_sql_integer">
		</cfoutput>
	</cfquery>
	
	<cfif myQRY.msg EQ "added">
		<!--- send email to this person --->
		
		<cfsavecontent variable="myTextContent">
		<cfoutput>
			You are now an admin on Racing Club Manager.
			
			Use this URL to login: http://racingclubmanager.com/login.cfm
			
			Your login is: #login#
			
			Your password is: #myQRY.new_password#
			
			When you log in, you will be prompted to change your password.
		</cfoutput>
		</cfsavecontent>
		
		<cfsavecontent variable="myHTMLContent">
		<cfoutput>
			You are now an admin on <a href="http://racingclubmanager.com/login.cfm">Racing Club Manager</a><br />
			Your login is: #login#<br />
			Your password is: #myQRY.new_password#<br />
			When you log in, you will be prompted to change your password.
		</cfoutput>
		</cfsavecontent>

		
		<cftry>
			<cfoutput>
			<cfmail to="#email#" from="no-reply@racingclubmanager.com" subject="Racing Club Manager Admin Password" type="html">
				<cfmailpart type="text/plain" charset="utf-8">#myTextContent#</cfmailpart>
				<cfmailpart type="text/html" charset="utf-8">#myHTMLContent#</cfmailpart>
			</cfmail>
			</cfoutput>
		
			<cfcatch>
				<cfreturn "sendMailError">
			</cfcatch>
		</cftry>
		
		<cfreturn "good">
	<cfelseif myQRY.msg EQ "good">
		<cfreturn "good">
	<cfelse>
		<cfreturn "error">
	</cfif>
</cffunction>

</cfcomponent>