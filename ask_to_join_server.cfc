<cfcomponent>

<cffunction output="no" name="ask_to_join" access="remote" returntype="string">
	<cfargument name="club_id" type="numeric" required="true" />
	<cfargument name="gamertag" type="string" required="true" />
	<cfargument name="email" type="string" required="true" />
	<cfargument name="tcs" type="string" required="true" />
	<cfargument name="abs" type="string" required="true" />
	<cfargument name="auto" type="string" required="true" />
	<cfargument name="stability" type="string" required="true" />
	<cfargument name="line" type="string" required="true" />
	<cfargument name="steering" type="string" required="true" />
	<cfargument name="level" type="string" required="true" />
	<cfargument name="desc" type="string" required="true" />
	
	<!---
		1. get list of admins
		2. add GUID to ask to join table with status of ask to join = request sent
		3. construct and send email
	--->
	
	<!--- 1 --->
	<cftry>
		<cfquery name="getAdmins" datasource="ds_rdt3">
			<cfoutput>
			EXEC [dbo].[get_admins_for_club] <cfqueryparam value="#club_id#" cfsqltype="cf_sql_integer">
			</cfoutput>
		</cfquery>
		

		<cfcatch>
			<cfreturn "error1">
		</cfcatch>
	</cftry>
	
	<cfset adminEmails = ValueList(getAdmins.email)>
	<cfset club_name = "#getAdmins.club_name#">
	<cfset myUUID = "#CreateUUID()#">

	<cfsavecontent variable="myTextContent">
	<cfoutput>
		#gamertag# is requesting to join #club_name#
		
		http://racingclubmanager.com/requests_home.cfm?id=#myUUID#
		
		Use the above URL to accept or deny this request.
		
		ASSISTS:
		-TRACTION CONTROL: #tcs#
		-ABS: #abs#
		-AUTOMATIC TRANSMISSION: #auto#
		-STABILITY CONTROL: #stability#
		SUGGESTED LINE(Braking or Full): #line#
		-NORMAL STEERING: #steering#
		DRIVER LEVEL: #level#
		
		#desc#
	</cfoutput>
	</cfsavecontent>
	
	<cfset emailMsg = "<b>#gamertag#</b> is requesting to join <b>#club_name#</b><br />">
	<cfset emailMsg = emailMsg & "http://racingclubmanager.com/requests_home.cfm?id=">
	<cfset emailMsg = emailMsg & "#myUUID#">
	<cfset emailMsg = emailMsg & "<br /> Use the above URL to accept or deny this request.">
	<cfset emailMsg = emailMsg & "<br /><br />">
	<cfset emailMsg = emailMsg & "ASSISTS<br />">
	<cfset emailMsg = emailMsg & "-TRACTION CONTROL: #tcs#<br />">
	<cfset emailMsg = emailMsg & "-ABS: #abs#<br />">
	<cfset emailMsg = emailMsg & "-AUTOMATIC TRANSMISSION: #auto#<br />">
	<cfset emailMsg = emailMsg & "-STABILITY CONTROL: #stability#<br />">
	<cfset emailMsg = emailMsg & "-SUGGESTED LINE(Braking or Full): #line#<br />">
	<cfset emailMsg = emailMsg & "-NORMAL STEERING: #steering#<br />">
	<cfset emailMsg = emailMsg & "<br /><br />">
	<cfset emailMsg = emailMsg & "DRIVER LEVEL: #level#">
	<cfset emailMsg = emailMsg & "<br /><br />">
	<cfset emailMsg = emailMsg & "#desc#">
	<cfset emailMsg = REPLACE(emailMsg, "'", "''", "All")>
	
	<cfsavecontent variable="myHTMLContent">
	<cfoutput>
		#emailMsg#
	</cfoutput>
	</cfsavecontent>

	<!--- 2 --->
	<cftry>
		<cfquery name="ask_to_join" datasource="ds_rdt3">
			<cfoutput>
			EXEC [dbo].[add_ask_to_join] <cfqueryparam value="#club_id#" cfsqltype="cf_sql_integer">
										, <cfqueryparam value="#myUUID#" cfsqltype="cf_sql_varchar">
										, <cfqueryparam value="#email#" cfsqltype="cf_sql_varchar">
										, <cfqueryparam value="#gamertag#" cfsqltype="cf_sql_varchar">
										, <cfqueryparam value="REQUEST SENT" cfsqltype="cf_sql_varchar">
										, <cfqueryparam value="#emailMsg#" cfsqltype="cf_sql_varchar">
			</cfoutput>
		</cfquery>
		
		<cfcatch>
			<cfoutput>
			<cfreturn "error2">
			</cfoutput>
		</cfcatch>
	</cftry>
	
	<cfif ask_to_join.msg EQ "racerExists">
		<cfreturn "racerExists">
	<cfelseif ask_to_join.msg EQ "good">
	
		<!--- 3 --->
		<cftry>
			<cfoutput>
			<cfmail to="#adminEmails#" from="no-reply@racingclubmanager.com" subject="Racing Club Manager - Request to Join" type="html"> 
				<cfmailpart type="text/plain" charset="utf-8">#myTextContent#</cfmailpart>
				<cfmailpart type="text/html" charset="utf-8">#myHTMLContent#</cfmailpart>
			</cfmail>
			</cfoutput>
			
			<cfcatch>
				<cfreturn "error3">
			</cfcatch>
		</cftry>

	</cfif>
	
		
	<cfreturn "success">
</cffunction>


</cfcomponent>