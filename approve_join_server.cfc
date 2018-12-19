<cfcomponent>

<!--- get ask to join info --->
	<cffunction output="no" name="get_ask_to_join" access="remote" returntype="string">
		<cfargument name="strUUID" type="string" required="true" />
		
		<cfif Not IsDefined("Session.club_id")>
			<cfreturn "sessionError">
		</cfif>
		
		<cfset retVal = "">
		<cfquery name="myQRY" datasource="ds_rdt3">
			<cfoutput>
			EXEC [dbo].[get_ask_to_join] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
										, <cfqueryparam value="#strUUID#" cfsqltype="cf_sql_varchar">
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
	
	<!--- complete the join request --->
	<cffunction output="no" name="complete_request" access="remote" returntype="string">
		<cfargument name="strUUID" type="string" required="true" />
		<cfargument name="strApproved" type="string" required="true" />
		<cfargument name="strNotes" type="string" required="true" />
		<cfargument name="strUseRealEmail" type="string" required="true" />
		
		<cfif Not IsDefined("Session.club_id")>
			<cfreturn "sessionError">
		</cfif>
		
		<cfset emailReplyTo = "no-reply@racingclubmanager.com">
		<cfif strApproved EQ "true" And strUseRealEmail EQ "true">
			<!--- if approved request, set replyto to admins real email address --->
			
			
			<cftry>
				<cfquery name="myQRY" datasource="ds_rdt3">
					<cfoutput>
					EXEC [dbo].[admin_get_email_address] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
														, <cfqueryparam value="#session.admin_id#" cfsqltype="cf_sql_integer">
					</cfoutput>
				</cfquery>
				
				<cfcatch>
					<cfreturn "error">
				</cfcatch>
			</cftry>
			
			<cfset emailReplyTo = "#myQRY.email#">
		</cfif>
		
		<!--- 1. update ask_to_join table --->
		<cftry>
			<cfquery name="myQRY" datasource="ds_rdt3">
				<cfoutput>
				EXEC [dbo].[complete_join_request] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
												, <cfqueryparam value="#strUUID#" cfsqltype="cf_sql_varchar">
												, <cfqueryparam value="#strApproved#" cfsqltype="cf_sql_varchar">
												, <cfqueryparam value="#session.admin_id#" cfsqltype="cf_sql_integer">
				</cfoutput>
			</cfquery>
			
			<cfcatch>
				<cfreturn "error">
			</cfcatch>
		</cftry>
		
		<cfif myQRY.msg EQ "good">
			
			
			<cfsavecontent variable="myTextContent">
			<cfoutput>
				Your request to join #myQRY.club_name# has been #myQRY.join_status#
				
				The notes below were provided by an admin of the club:
				
				
				
				#strNotes#
			</cfoutput>
			</cfsavecontent>
			
			<cfsavecontent variable="myHTMLContent">
			<cfoutput>
				Your request to join <b>#myQRY.club_name#</b> has been <b>#myQRY.join_status#</b>
				<br />
				The notes below were provided by an admin of the club:
				<br /><br />
				#strNotes#
			</cfoutput>
			</cfsavecontent>
		
			<!--- 2. send email to requestor --->
			<cftry>
				<cfoutput>
				<cfmail to="#myQRY.email#" from="rcm@racingclubmanager.com" subject="Racing Club Manager Join Request" type="html" replyto="#emailReplyTo#">
					<cfmailpart type="text/plain" charset="utf-8">#myTextContent#</cfmailpart>
					<cfmailpart type="text/html" charset="utf-8">#myHTMLContent#</cfmailpart>
				</cfmail>
				</cfoutput>
			
				<cfcatch>
					<cfreturn "error">
				</cfcatch>
			</cftry>
		<cfelseif myQRY.msg EQ "error">
			<cfreturn "error">
		</cfif>
		
		<cfreturn "success">
	</cffunction>
	
	
	<cffunction output="no" name="dismiss_request" access="remote" returntype="string">
		<cfargument name="strUUID" type="string" required="true" />
		
		<cfif Not IsDefined("Session.club_id")>
			<cfreturn "sessionError">
		</cfif>
		
		<cfquery name="myQRY" datasource="ds_rdt3">
			<cfoutput>
			EXEC [dbo].[admin_dismiss_join_request] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
													, <cfqueryparam value="#session.admin_id#" cfsqltype="cf_sql_integer">
													, <cfqueryparam value="#strUUID#" cfsqltype="cf_sql_varchar">
			</cfoutput>
		</cfquery>
		
		<!---<cfoutput query="myQRY">
			
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
		--->
		<cfreturn myQRY.msg>
		
	</cffunction>

</cfcomponent>