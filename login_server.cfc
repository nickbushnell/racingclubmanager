<cfcomponent>

<cffunction output="no" name="attempt_login" access="remote" returntype="any">
	<cfargument name="username" type="string" required="true" />
	<cfargument name="password" type="string" required="true" />
	<cfargument name="goto" type="string" required="true" />

	<cfset retVal = "">
	<cfset login = "">
	<cfset last_login = "1/1/1900">
	<cfset loginContinue = "no">
	
	<cfquery name="myQRY1" datasource="ds_rdt3">
		EXEC [dbo].[get_login_info] <cfqueryparam cfsqltype="cf_sql_varchar" value="#username#">
	</cfquery>
	
	<cfif myQRY1.club_name IS "">
		<cfreturn failedLogin()>
	</cfif>

	<cfif strLenMatch(password, myQRY1.admin_password) IS true>
		<cfset loginContinue = "yes">
	<cfelse>
		<cfreturn failedLogin()>
	</cfif>
	

	<cfif loginContinue IS "yes">

		<cfset userPass = ArrayNew(1)>
		<cfset realPass = ArrayNew(1)>
		
		<cfset userPass = strToArray(password, userPass)>
		<cfset realPass = strToArray(myQRY1.admin_password, realPass)>
		
		<cfset userPass = AscArray(userPass)>
		<cfset realPass = AscArray(realPass)>
		
		<cfif arrayMatch(userPass, realPass) IS true>
			<cfset session.club_id = "#myQRY1.club_id#">
			<cfset session.admin_id = "#myQRY1.admin_id#">
			<cfset session.permission = myQRY1.admin_permission>
			<cfset session.loginAttempts = 0>
			<cfset last_login = "#myQRY1.last_login#">
			
			<cfset login = "success">
			
		<cfelse>
			<cfreturn failedLogin()>
		</cfif>
	<cfelse>
		<cfreturn failedLogin()>
	</cfif><!--- END LOGIN CONTINUE --->
	

	<cfif login IS "success">
		<cfif last_login EQ "1/1/1900">
			<!--- never logged in before, set changePass session vars --->
			<cfset session.changePass_admin_id = "#myQRY1.admin_id#">
			<cfset session.changePass_club_id = "#myQRY1.club_id#">
			<cfset session.loginAttempts = 0>
			<!--- delete regular session vars --->
			<cfif IsDefined("session.club_id")>
				<cfset structDelete(SESSION, "club_id")>
			</cfif>
			<cfif IsDefined("session.admin_id")>
				<cfset structDelete(SESSION, "admin_id")>
			</cfif>
			<!--- send to changePass screen --->
			<cfreturn "changePass.cfm">
		<cfelse>
			<cfquery datasource="ds_rdt3" name="loginUpdate">
				EXEC [dbo].[update_last_login] <cfqueryparam value="#myQRY1.club_id#" cfsqltype="cf_sql_integer">
											, <cfqueryparam value="#myQRY1.admin_id#" cfsqltype="cf_sql_integer">
			</cfquery>
			
			<cfif loginUpdate.msg EQ "error">
				<cfreturn "logout.cfm?message=error2">
			</cfif>
		</cfif>
		
		<cfif LEN(goto) GTE 1>
			<cfif Find("?", goto) GT 0>
				<cfreturn "#goto#&club=#myQRY1.club_id#">
			<cfelse>
				<cfreturn "#goto#?club=#myQRY1.club_id#">
			</cfif>
		<cfelse>
			<cfif Int(myQRY1.admin_permission) LTE 1>
				<cfreturn "admin_races_results.cfm?club=#myQRY1.club_id#">
			<cfelseif Int(myQRY1.admin_permission) EQ 2>
				<cfreturn "requests_home.cfm?club=#myQRY1.club_id#">
			<cfelse>
				<cfreturn "logout.cfm?message=error1">
			</cfif>
		</cfif>
	</cfif>
	
	<cfreturn "logout.cfm?message=error3">
</cffunction>

<cffunction name="failedLogin" output="false" returntype="string">
	
	<cfif Not IsDefined("Session.loginAttempts")>
		<cfset Session.loginAttempts = 1>
	<cfelse>
		<cfset Session.loginAttempts = Session.loginAttempts + 1>

		<cfif Session.loginAttempts GTE 3>
			<cfset session.lockedOut = DateAdd("n", 10, now())>
			
			<cfreturn "lockedout.cfm">
		</cfif>
	</cfif>

	<cfreturn "login.cfm?login=false">
</cffunction>


<cffunction name="strLenMatch" output="false" returntype="boolean">
  <cfargument name="string1" type="string" required="yes">
  <cfargument name="string2" type="string" required="yes">

	<cfif Len("#string1#") IS Len("#string2#")>
		<cfset match = true>
	<cfelse>
		<cfset match = false>
	</cfif>
	
  <cfreturn match>
</cffunction>

<cffunction name="strToArray" output="false" returntype="array">
  <cfargument name="theString" type="string" required="yes">
  <cfargument name="theArray" type="array" required="yes">
	
	<cfloop from="1" to="#Len(theString)#" index="i">
		<cfset theArray[i] = Mid("#theString#", i, 1)>
	</cfloop>
	
  <cfreturn theArray>
</cffunction>

<cffunction name="AscArray" output="false" returntype="array">
  <cfargument name="theArray" type="array" required="yes">
  
	<cfloop from="1" to="#ArrayLen(theArray)#" index="i">
		<cfset theArray[i] = Asc("#theArray[i]#")>
	</cfloop>
	
  <cfreturn theArray>
</cffunction>

<cffunction name="arrayMatch" output="false" returntype="boolean">
  <cfargument name="array1" type="array" required="yes">
  <cfargument name="array2" type="array" required="yes">
  	<cfset matches = 0>
  
	<cfloop from="1" to="#ArrayLen(array1)#" index="i">
		<cfif array1[i] IS array2[i]>
			<cfset matches = matches + 1>
		</cfif>
	</cfloop>
	
	<cfif matches IS ArrayLen(array1)>
		<cfset match = true>
	<cfelse>
		<cfset match = false>
	</cfif> 
  
  <cfreturn match>
</cffunction>


</cfcomponent>