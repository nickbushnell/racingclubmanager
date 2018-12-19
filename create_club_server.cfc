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

<!--- create club --->
<cffunction output="no" name="create_club" access="remote" returntype="string">
	<cfargument name="club" type="string" required="true" />
	<cfargument name="email" type="string" required="true" />
	<cfargument name="game_id" type="numeric" required="true" />
	<cfargument name="personality_id" type="numeric" required="true" />
	<cfargument name="platform" type="string" required="true" />
	
	<!--- check that the email is ina  valid format --->
	<cfif Not IsValid("email", email)>
		<cfreturn "emailError">
	</cfif>
	
	<!--- check that the club name uses only the allowed characters --->
	<cfloop index="i" from="1" to="#Len(club)#">
		<cfset thisChar = Asc(Mid(club,i,1))>
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
	
	<cfif platform EQ "PC"
	   OR platform EQ "XBOX One"
	   OR platform EQ "XBOX 360"
	   OR platform EQ "Playstation 4"
	   OR platform EQ "Playstation 3"
	>
		<!--- good --->
	<cfelse>
		<cfreturn "platformError">
	</cfif>

	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[create_new_club] <cfqueryparam value="#doEncode(club)#" cfsqltype="cf_sql_varchar">
									, <cfqueryparam value="#doEncode(email)#" cfsqltype="cf_sql_varchar">
									, <cfqueryparam value="#game_id#" cfsqltype="cf_sql_integer">
									, <cfqueryparam value="#personality_id#" cfsqltype="cf_sql_integer">
									, <cfqueryparam value="#TRIM(doEncode(platform))#" cfsqltype="cf_sql_varchar">
		</cfoutput>
	</cfquery>
	
	<!--- check for errors --->
	<cfif myQRY.msg EQ "invalidPersonality" OR myQRY.msg EQ "invalidGame">
		<cfreturn "error">
	<cfelseif myQRY.msg EQ "clubExists">
		<cfreturn "clubExists">
	<cfelse>
		<!--- if no errors, send an email --->
		
		<cfsavecontent variable="myTextContent">
		<cfoutput>
			You are now an admin on Racing Club Manager - http://racingclubmanager.com/login.cfm
			
			Your login is: #myQRY.login_name#
			Your password is: #myQRY.password#
			
			When you log in, you will be prompted to change your password. You can change your login name by visiting the Admins Club Profile and clicking the "Add/Edit Admins" Link.
		</cfoutput>
		</cfsavecontent>
		
		<cfsavecontent variable="myHTMLContent">
		<cfoutput>
			You are now an admin on <a href="http://racingclubmanager.com/login.cfm">Racing Club Manager</a><br />
			Your login is: #myQRY.login_name#<br />
			Your password is: #myQRY.password#<br />
			When you log in, you will be prompted to change your password. You can change your login name by visiting the Admins Club Profile and clicking the "Add/Edit Admins" Link.
		</cfoutput>
		</cfsavecontent>

		<cftry>
			<cfoutput>
			<cfmail to="#email#" from="no-reply@racingclubmanager.com" subject="Welcome to Racing Club Manager" type="html">
				<cfmailpart type="text/plain" charset="utf-8">#myTextContent#</cfmailpart>
				<cfmailpart type="text/html" charset="utf-8">#myHTMLContent#</cfmailpart>
			</cfmail>
			</cfoutput>
		
			<cfcatch>
				<cfreturn "sendMailError">
			</cfcatch>
		</cftry>
		
		<cfreturn "good">
	</cfif>
</cffunction>

<!--- get all personalities --->
<cffunction output="no" name="get_all_personalities" access="remote" returntype="string">
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_all_personalities]
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

<!--- check club name for uniqueness --->
<cffunction output="no" name="check_club_name_unique" access="remote" returntype="string">
	<cfargument name="club_name" type="string" required="true" />
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[check_club_name_unique] <cfqueryparam value="0" cfsqltype="cf_sql_integer">
											, <cfqueryparam value="#TRIM(doEncode(club_name))#" cfsqltype="cf_sql_varchar">
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