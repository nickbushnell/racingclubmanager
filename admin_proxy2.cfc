<cfcomponent>
	
	
	
	<!--- get gamertag of racer --->
	<cffunction output="no" name="get_racer_data" access="remote" returntype="string">
		<cfargument name="racer_id" type="numeric" required="true" />
		
		<cfif Not IsDefined("Session.club_id")>
			<cfreturn "sessionError">
		</cfif>
		
		<cfset retVal = "">
		<cfquery name="myQRY" datasource="ds_rdt3">
			<cfoutput>
			EXEC [dbo].[get_racer_data] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
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
	
	
	
	
	
	<!--- get admin series --->
	<cffunction output="no" name="get_admin_series" access="remote" returntype="string">
	
		<cfif Not IsDefined("Session.club_id")>
			<cfreturn "sessionError">
		</cfif>
		
		<cfset retVal = "">
		<cfquery name="myQRY" datasource="ds_rdt3">
			<cfoutput>
			EXEC [dbo].[get_admin_series] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
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
	
	<!--- get admin races --->
	<cffunction output="no" name="get_admin_races" access="remote" returntype="string">
		<cfargument name="series_id" type="numeric" required="true" />
		
		<cfif Not IsDefined("Session.club_id")>
			<cfreturn "sessionError">
		</cfif>
		
		<cfset retVal = "">
		<cfquery name="myQRY" datasource="ds_rdt3">
			<cfoutput>
			EXEC [dbo].[get_admin_races] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
										, <cfqueryparam value="#series_id#" cfsqltype="cf_sql_integer">
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
	
	<!--- get tracks --->
	<cffunction output="no" name="get_tracks" access="remote" returntype="string">
		
		<cfif Not IsDefined("Session.club_id")>
			<cfreturn "sessionError">
		</cfif>
		
		<cfset retVal = "">
		<cfquery name="myQRY" datasource="ds_rdt3">
			<cfoutput>
			EXEC [dbo].[get_tracks] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
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
	
	<!--- get series data --->
	<cffunction output="no" name="get_series_data" access="remote" returntype="string">
		<cfargument name="series_id" type="numeric" required="true" />
		
		<cfif Not IsDefined("Session.club_id")>
			<cfreturn "sessionError">
		</cfif>
		
		<cfset retVal = "">
		<cfquery name="myQRY" datasource="ds_rdt3">
			<cfoutput>
			EXEC [dbo].[get_admin_series_data] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
												, <cfqueryparam value="#series_id#" cfsqltype="cf_sql_integer">
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
	
	<!--- get race results --->
	<cffunction output="no" name="get_race_results" access="remote" returntype="string">
		<cfargument name="race_id" type="numeric" required="true" />
		
		<cfif Not IsDefined("Session.club_id")>
			<cfreturn "sessionError">
		</cfif>
		
		<cfset retVal = "">
		<cfquery name="myQRY" datasource="ds_rdt3">
			<cfoutput>
			EXEC [dbo].[get_race_results] <cfqueryparam value="#race_id#" cfsqltype="cf_sql_integer">
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
	
	<!--- get race description --->
	<cffunction output="no" name="get_race_desc" access="remote" returntype="string">
		<cfargument name="race_id" type="numeric" required="true" />
		
		<cfif Not IsDefined("Session.club_id")>
			<cfreturn "sessionError">
		</cfif>
		
		<cfset retVal = "">
		<cfquery name="myQRY" datasource="ds_rdt3">
			<cfoutput>
			EXEC [dbo].[get_race_desc] <cfqueryparam value="#race_id#" cfsqltype="cf_sql_integer">
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
	
	<!--- save race data --->
	<cffunction output="no" name="do_save" access="remote" returntype="string">
		<cfargument name="series_id" type="numeric" />
		<cfargument name="series_name" type="string" />
		<cfargument name="race_id" type="numeric" />
		<cfargument name="race_name" type="string" />
		<cfargument name="num_laps" type="numeric" />
		<cfargument name="track_id" type="numeric" />
		<cfargument name="race_date" type="string" />
		<cfargument name="strResults" type="string" />
		<cfargument name="pts_id" type="numeric" />
		
		
		<cfif Not IsDefined("Session.club_id")>
			<cfreturn "sessionError">
		</cfif>
		
		<cfset retVal = "">
		<cfquery name="myQRY" datasource="ds_rdt3">
			<cfoutput>
			EXEC [dbo].[save_race_data] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">,
										<cfqueryparam value="#series_id#" cfsqltype="cf_sql_integer">,
										<cfqueryparam value="#Trim(doEncode(series_name))#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#race_id#" cfsqltype="cf_sql_integer">,
										<cfqueryparam value="#Trim(doEncode(race_name))#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#num_laps#" cfsqltype="cf_sql_integer">,
										<cfqueryparam value="#track_id#" cfsqltype="cf_sql_integer">,
										<cfqueryparam value="#race_date#" cfsqltype="cf_sql_date">,
										<cfqueryparam value="#pts_id#" cfsqltype="cf_sql_integer">
			</cfoutput>
		</cfquery>
		
		
		<cfset saveStatus = "">
		
		<cfoutput query="myQRY">
			
			<cfset idx = 0>
			
			<cfloop list="#ArrayToList(myQRY.getColumnNames())#" index="col"><!--- loop through columns in this row --->
				<cfset idx = idx + 1>
				
				<cfif idx EQ 1>
					<cfset saveStatus = myQRY[col][currentrow]>
				</cfif>
				
				<cfif saveStatus EQ "insert" AND idx EQ 2>
					<cfset race_id = myQRY[col][currentrow]>
				</cfif>
				
				<cfset retVal = retVal & "#myQRY[col][currentrow]#">
				
				<cfif idx LT ListLen(ArrayToList(myQRY.getColumnNames()))>
					<cfset retVal = retVal & "|">
				</cfif>
			</cfloop>
			
			<cfif myQRY.CurrentRow LT myQRY.RecordCount>
				<cfset retVal = retVal & "<row>">
			</cfif>
		</cfoutput>
		
		
		<cfquery name="myDeleteQry" datasource="ds_rdt3">
			<cfoutput>
			EXEC [dbo].[delete_race_results] <cfqueryparam value="#race_id#" cfsqltype="cf_sql_integer">
			</cfoutput>
		</cfquery>
		
		
		<cfset commaArray = ListToArray(strResults, ",")>
		<cfset retVal = retVal & "<row>">
		<cfloop from="1" to="#ArrayLen(commaArray)#" index="i">
			
			<cfset thisItem = commaArray[i]>
			<cfset colonArray = ListToArray(thisItem, ":")>
			<cfset intPlace = colonArray[1]>
			<cfset racer_id = colonArray[2]>
			
			<cfquery name="myQRY2" datasource="ds_rdt3">
				<cfoutput>
				EXEC [dbo].[save_race_result] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">,
											  <cfqueryparam value="#series_id#" cfsqltype="cf_sql_integer">,
											  <cfqueryparam value="#race_id#" cfsqltype="cf_sql_integer">, 
											  <cfqueryparam value="#intPlace#" cfsqltype="cf_sql_integer">, 
											  <cfqueryparam value="#racer_id#" cfsqltype="cf_sql_integer">
				</cfoutput>
			</cfquery>
			
			<cfoutput query="myQRY2">
				
				<cfset idx = 0>
				
				<cfloop list="#ArrayToList(myQRY2.getColumnNames())#" index="col">
					<cfset idx = idx + 1>
					
					<cfif idx EQ 1>
						<cfset saveStatus = myQRY2[col][currentrow]>
					</cfif>
					
					<cfset retVal = retVal & "#myQRY2[col][currentrow]#">
					
					<cfif idx LT ListLen(ArrayToList(myQRY2.getColumnNames()))>
						<cfset retVal = retVal & "|">
					</cfif>
				</cfloop>
				
				<cfif myQRY2.CurrentRow LT myQRY2.RecordCount>
					<cfset retVal = retVal & "<row>">
				</cfif>
			</cfoutput>
		</cfloop>
		
		
		<cfif saveStatus EQ "error">
			<cfset retVal = "error">
		</cfif>
		
		<cfreturn retVal>
	</cffunction>
	
	<!--- save series data --->
	<cffunction output="no" name="save_series_data" access="remote" returntype="string">
		<cfargument name="series_id" type="numeric" required="true" />
		<cfargument name="series_name" type="string" required="true" />
		<cfargument name="num_races" type="numeric" required="true" />
		
		<cfif Not IsDefined("Session.club_id")>
			<cfreturn "sessionError">
		</cfif>
		
		<cfset retVal = "">
		<cfquery name="myQRY" datasource="ds_rdt3">
			<cfoutput>
			EXEC [dbo].[save_series_data] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">,
										  <cfqueryparam value="#series_id#" cfsqltype="cf_sql_integer">,
										  <cfqueryparam value="#Trim(doEncode(series_name))#" cfsqltype="cf_sql_varchar">,
										  <cfqueryparam value="#num_races#" cfsqltype="cf_sql_integer">
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
	
	<!--- save series_desc --->
	<cffunction output="no" name="save_series_desc" access="remote" returntype="string">
		<cfargument name="series_id" type="numeric" required="true" />
		<cfargument name="series_desc" type="string" required="true" />
		<cfargument name="chunkIdx" type="numeric" required="true" />
		
		<!---<cfreturn "series_id = #series_id#; series_desc = #doEncode(series_desc)#; chunkIdx: #chunkIdx#">--->
		
		<cfif Not IsDefined("Session.club_id")>
			<cfreturn "sessionError">
		</cfif>
		
		<cfset retVal = "">
		<cfquery name="myQRY" datasource="ds_rdt3">
			<cfoutput>
			EXEC [dbo].[save_series_desc] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">,
										  <cfqueryparam value="#series_id#" cfsqltype="cf_sql_integer">,
										  <cfqueryparam value="#Trim(doEncode(series_desc))#" cfsqltype="cf_sql_varchar">,
										  <cfqueryparam value="#chunkIdx#" cfsqltype="cf_sql_integer">
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
	
	<!--- save race_desc --->
	<cffunction output="no" name="save_race_desc" access="remote" returntype="string">
		<cfargument name="series_id" type="numeric" required="true" />
		<cfargument name="race_id" type="numeric" required="true" />
		<cfargument name="race_desc" type="string" required="true" />
		<cfargument name="chunkIdx" type="numeric" required="true" />
		
		<cfif Not IsDefined("Session.club_id")>
			<cfreturn "sessionError">
		</cfif>
		
		<cfset retVal = "">
		<cfquery name="myQRY" datasource="ds_rdt3">
			<cfoutput>
			EXEC [dbo].[save_race_desc] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">,
										  <cfqueryparam value="#series_id#" cfsqltype="cf_sql_integer">,
										  <cfqueryparam value="#race_id#" cfsqltype="cf_sql_integer">,
										  <cfqueryparam value="#Trim(doEncode(race_desc))#" cfsqltype="cf_sql_varchar">,
										  <cfqueryparam value="#chunkIdx#" cfsqltype="cf_sql_integer">
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
	
	<!--- get series description --->
	<cffunction output="no" name="get_admin_series_desc_and_pts" access="remote" returntype="string">
		<cfargument name="series_id" type="numeric" required="true" />
		
		<cfif Not IsDefined("Session.club_id")>
			<cfreturn "sessionError">
		</cfif>
		
		<cfset retVal = "">
		<cfquery name="myQRY" datasource="ds_rdt3">
			<cfoutput>
			EXEC [dbo].[get_admin_series_desc_and_pts]  <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">,
														<cfqueryparam value="#series_id#" cfsqltype="cf_sql_integer">
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
	
	<!--- get ask to join info --->
	<cffunction output="no" name="get_ask_to_join" access="remote" returntype="string">
		<cfargument name="strUUID" type="string" required="true" />
		
		<cfif Not IsDefined("Session.club_id")>
			<cfreturn "sessionError">
		</cfif>
		
		<cfset retVal = "">
		<cfquery name="myQRY" datasource="ds_rdt3">
			<cfoutput>
			EXEC [dbo].[get_ask_to_join] <cfqueryparam value="#strUUID#" cfsqltype="cf_sql_varchar">
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
		
		<cfif Not IsDefined("Session.club_id")>
			<cfreturn "sessionError">
		</cfif>
		
		<!--- 1. update ask_to_join table --->
		<cftry>
			<cfquery name="myQRY" datasource="ds_rdt3">
				<cfoutput>
				EXEC [dbo].[complete_join_request] <cfqueryparam value="#strUUID#" cfsqltype="cf_sql_varchar">
													, <cfqueryparam value="#strApproved#" cfsqltype="cf_sql_varchar">
													, <cfqueryparam value="#session.admin_id#" cfsqltype="cf_sql_integer">
				</cfoutput>
			</cfquery>
			
			<cfcatch>
				<cfreturn "error">
			</cfcatch>
		</cftry>
		
		<!--- 2. send email to requestor --->
		<cftry>
			<cfoutput>
			<cfmail to="#myQRY.email#" from="rcm@racingclubmanager.com" subject="Racing Club Manager Join Request" type="html">
				Your request to join <b>#myQRY.club_name#</b> has been <b>#myQRY.join_status#</b>
				<br />
				The notes below were provided by an admin of the club:
				<br /><br />
				#strNotes#
			</cfmail>
			</cfoutput>
		
			<cfcatch>
				<cfreturn "error">
			</cfcatch>
		</cftry>
		
		<cfreturn "success">
	</cffunction>
	
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
	
	<!--- delete race --->
	<cffunction output="no" name="delete_race" access="remote" returntype="string">
		<cfargument name="series_id" type="numeric" required="true" />
		<cfargument name="race_id" type="numeric" required="true" />
		
		<cfif Not IsDefined("Session.club_id")>
			<cfreturn "sessionError">
		</cfif>
		
		<cfset retVal = "">
		
		<cftry>
			<cfquery name="myQRY" datasource="ds_rdt3">
				<cfoutput>
				EXEC [dbo].[delete_race] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
										, <cfqueryparam value="#series_id#" cfsqltype="cf_sql_integer">
										, <cfqueryparam value="#race_id#" cfsqltype="cf_sql_integer">
				</cfoutput>
			</cfquery>
		
			<cfcatch>
				<cfset retVal = "error">
			</cfcatch>
		</cftry>
		
		<cfoutput query="myQRY">
			<cfset retVal = msg>
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