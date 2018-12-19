<!--- admin_races_results_server --->
<cfcomponent>


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

<!--- get all racers in this club --->
<cffunction output="no" name="get_admin_racers" access="remote" returntype="string">
	<cfargument name="race_id" type="numeric" required="true" />
	
	<cfif Not IsDefined("Session.club_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[admin_get_racers_byRaceId] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
											, <cfqueryparam value="#race_id#" cfsqltype="cf_sql_integer">
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

<!--- get points templates --->
<cffunction output="no" name="get_points_templates" access="remote" returntype="string">
	
	<cfif Not IsDefined("Session.club_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_pts_templates] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
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

<!--- get series desc --->
<cffunction output="no" name="get_admin_desc" access="remote" returntype="string">
	<cfargument name="type" type="string" required="true" />
	<cfargument name="id" type="numeric" required="true" />
	
	<cfif Not IsDefined("Session.club_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<!---
	<cfoutput>
	<cfreturn "EXEC [dbo].[get_admin_desc] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">, '#type#', #id#">
	</cfoutput>
	--->
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_admin_desc] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
									, <cfqueryparam value="#type#" cfsqltype="cf_sql_varchar">
									, <cfqueryparam value="#id#" cfsqltype="cf_sql_integer">
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

<!--- get races in series--->
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

<!--- get race results --->
<cffunction output="no" name="get_race_results" access="remote" returntype="string">
	<cfargument name="race_id" type="numeric" required="true" />
	<cfargument name="series_type" type="string" required="true" />
	
	<cfif Not IsDefined("Session.club_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<!---
	<cfoutput>
		<cfreturn "EXEC [dbo].[get_race_results] #race_id#, '#series_type#'">
	</cfoutput>
	--->
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_race_results] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
									, <cfqueryparam value="#race_id#" cfsqltype="cf_sql_integer">
									, <cfqueryparam value="#series_type#" cfsqltype="cf_sql_varchar">
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

<!--- save descriptions --->
<cffunction output="no" name="save_admin_desc" access="remote" returntype="string">
	<cfargument name="desc" type="string" required="true" />
	<cfargument name="chunk_idx" type="numeric" required="true" />
	<cfargument name="type" type="string" required="true" />
	<cfargument name="id" type="numeric" required="true" />
	
	<cfif Not IsDefined("Session.club_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[save_admin_desc] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
									, <cfqueryparam value="#TRIM(doEncode(desc))#" cfsqltype="cf_sql_varchar">
									, <cfqueryparam value="#chunk_idx#" cfsqltype="cf_sql_integer">
									, <cfqueryparam value="#type#" cfsqltype="cf_sql_varchar">
									, <cfqueryparam value="#id#" cfsqltype="cf_sql_integer">
		</cfoutput>
	</cfquery>
	
	<cfoutput query="myQRY">
		<cfset retVal = myQRY.msg>
	</cfoutput>
	
	<cfreturn retVal>
</cffunction>

<!--- Save admin series data --->
<cffunction output="no" name="save_admin_series_data" access="remote" returntype="string">
	<cfargument name="series_id" type="numeric" required="true" />
	<cfargument name="series_name" type="string" required="true" />
	<cfargument name="pts_id" type="numeric" required="true" />
	
	<cfif Not IsDefined("Session.club_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[save_admin_series_data] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
											, <cfqueryparam value="#series_id#" cfsqltype="cf_sql_integer">
											, <cfqueryparam value="#TRIM(doEncode(series_name))#" cfsqltype="cf_sql_varchar">
											, <cfqueryparam value="#pts_id#" cfsqltype="cf_sql_integer">
		</cfoutput>
	</cfquery>
	
	<cfoutput query="myQRY">
		<cfset retVal = myQRY.msg>
	</cfoutput>
	
	<cfreturn retVal>
</cffunction>

<!--- make sure this points template will work with all the results of races in this series --->
<cffunction output="no" name="check_admin_points_template" access="remote" returntype="string">
	<cfargument name="series_id" type="numeric" required="true" />
	<cfargument name="pts_id" type="numeric" required="true" />
	
	<cfif Not IsDefined("Session.club_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[check_admin_points_template] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
												, <cfqueryparam value="#series_id#" cfsqltype="cf_sql_integer">
												, <cfqueryparam value="#pts_id#" cfsqltype="cf_sql_integer">
		</cfoutput>
	</cfquery>
	
	<cfoutput query="myQRY">
		<cfset retVal = myQRY.msg>
	</cfoutput>
	
	<cfreturn retVal>
</cffunction>

<!--- add new race to this series --->
<cffunction output="no" name="add_new_race" access="remote" returntype="string">
	<cfargument name="series_id" type="numeric" required="true" />
	
	<cfif Not IsDefined("Session.club_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[add_new_race] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
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


<!--- save_admin_race_data(g_seriesId, g_raceId, race_name, laps, track_id, race_date, strResults) --->
<!--- save race data --->
<cffunction output="no" name="save_admin_race_data" access="remote" returntype="string">
	<cfargument name="series_id" type="numeric" />
	<cfargument name="race_id" type="numeric" />
	<cfargument name="race_name" type="string" />
	<cfargument name="raceLenType" type="string" />
	<cfargument name="distVal" type="string" />
	<cfargument name="unitMeasureVal" type="string" />
	<cfargument name="track_id" type="numeric" />
	<cfargument name="race_date" type="string" />
	<cfargument name="strResults" type="string" />
	<cfargument name="strQual" type="string" />
	
	<cfif Not IsDefined("Session.club_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<cfif raceLenType EQ "Distance">
		<cfset distVal = validDistance(distVal, "0.000")>
	<cfelseif raceLenType EQ "Time">
		<cfset distVal = validTimeHourMinute(distVal, "00:00")>
	<cfelse>
		<cfreturn "error">
	</cfif>
	
	<cfif unitMeasureVal EQ "laps" Or
		  unitMeasureVal EQ "km" Or
		  unitMeasureVal EQ "m" Or
		  unitMeasureVal EQ "mi" Or
		  unitMeasureVal EQ "ft">
	<!--- all good --->
	<cfelse>
		<cfreturn "error">
	</cfif>
	
	<cftry>
		<cfquery name="myQRY" datasource="ds_rdt3">
			<cfoutput>
			EXEC [dbo].[save_admin_race_data] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">,
										 <cfqueryparam value="#series_id#" cfsqltype="cf_sql_integer">,
										 <cfqueryparam value="#race_id#" cfsqltype="cf_sql_integer">,
										 <cfqueryparam value="#Trim(doEncode(race_name))#" cfsqltype="cf_sql_varchar">,
										 <cfqueryparam value="#Trim(raceLenType)#" cfsqltype="cf_sql_varchar">,
										 <cfqueryparam value="#Trim(distVal)#" cfsqltype="cf_sql_varchar">,
										 <cfqueryparam value="#Trim(unitMeasureVal)#" cfsqltype="cf_sql_varchar">,
										 <cfqueryparam value="#track_id#" cfsqltype="cf_sql_integer">,
										 <cfqueryparam value="#race_date#" cfsqltype="cf_sql_varchar">
			</cfoutput>
		</cfquery>
		
		<cfcatch>
			<cfreturn "We encountered an issue trying to save the race data. [" & cfcatch.message & "]">
		</cfcatch>
	</cftry>
	
	<cfoutput query="myQRY">
		<cfif myQRY.msg EQ "error">
			<cfreturn "We encountered an issue while processing the race data.">
		</cfif>
	</cfoutput>
	
	<cftry>
		<cfquery name="myDeleteQry" datasource="ds_rdt3">
			<cfoutput>
			EXEC [dbo].[delete_race_results] #race_id#
			</cfoutput>
		</cfquery>
		
		<cfcatch>
			<cfreturn "We encountered an issue while prepping the race results. [" & cfcatch.message & "]">
		</cfcatch>
	</cftry>
	
	<cfset commaArray = ListToArray(strResults, ",")>
	<cfloop from="1" to="#ArrayLen(commaArray)#" index="i">
		<cfset thisItem = commaArray[i]>
		<cfset colonArray = ListToArray(thisItem, "!")>
		<cfset intPlace = colonArray[1]>
		<cfset racer_id = colonArray[2]>
		<cfset bonus_pts = colonArray[3]>
		
		<cfif strQual EQ "ON">
			<cfset qual_pos = colonArray[4]>
		<cfelse>
			<cfset qual_pos = "0">
		</cfif>
		
		<cfset bestLap = validTime(colonArray[5], "00:00.000")>
		<cfset overall = validTime(colonArray[6], "00:00:00.000")>
		<cfset distance = validDistance(colonArray[7], "0.000")>
		<cfset penalty_pts = colonArray[8]>
		
		<cftry>
			<cfquery name="myQRY2" datasource="ds_rdt3">
				EXEC [dbo].[save_race_result] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">,
											  <cfqueryparam value="#series_id#" cfsqltype="cf_sql_integer">,
											  <cfqueryparam value="#race_id#" cfsqltype="cf_sql_integer">, 
											  <cfqueryparam value="#intPlace#" cfsqltype="cf_sql_integer">, 
											  <cfqueryparam value="#racer_id#" cfsqltype="cf_sql_integer">,
											  <cfqueryparam value="#bonus_pts#" cfsqltype="cf_sql_integer">,
											  <cfqueryparam value="#qual_pos#" cfsqltype="cf_sql_integer">,
											  <cfqueryparam value="#bestLap#" cfsqltype="cf_sql_varchar">,
											  <cfqueryparam value="#overall#" cfsqltype="cf_sql_varchar">,
											  <cfqueryparam value="#distance#" cfsqltype="cf_sql_integer">,
											  <cfqueryparam value="#penalty_pts#" cfsqltype="cf_sql_integer">
			</cfquery>
			
			<cfcatch>
				<cfreturn "We encountered an issue while saving race results. [" & cfcatch.message & "]">
			</cfcatch>
		</cftry>
		
		<cfoutput query="myQRY2">
			<cfif myQRY2.msg EQ "error">
				<cfreturn "We encountered an issue while processing the race results.">
			</cfif>
		</cfoutput>
	</cfloop>
	
	<!--- now check to see if we saved more finish positions than our template allows --->
	<cfquery name="myTemplateQRY" datasource="ds_rdt3">
		EXEC [dbo].[check_template_finishers] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
												, <cfqueryparam value="#series_id#" cfsqltype="cf_sql_integer">
												, <cfqueryparam value="#race_id#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<cfreturn myTemplateQRY.msg>
	
	<cfreturn "good">
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

<!--- delete series --->
<cffunction output="no" name="delete_series" access="remote" returntype="string">
	<cfargument name="series_id" type="numeric" required="true" />
	
	<cfif Not IsDefined("Session.club_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<cfset retVal = "">
	
	<cftry>
		<cfquery name="myQRY" datasource="ds_rdt3">
			<cfoutput>
			EXEC [dbo].[delete_series] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
										, <cfqueryparam value="#series_id#" cfsqltype="cf_sql_integer">
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

<!--- delete race --->
<cffunction output="no" name="exclude_race" access="remote" returntype="string">
	<cfargument name="series_id" type="numeric" required="true" />
	<cfargument name="race_id" type="numeric" required="true" />
	<cfargument name="exclude" type="numeric" required="true" />
	
	<cfif Not IsDefined("Session.club_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<cfset retVal = "">
	
	<!--- exclude can only be 0 or 1 and nothing else --->
	<cfif exclude NEQ 0 AND exclude NEQ 1>
		<cfreturn "excludeError">
	</cfif>
	
	
	<cftry>
		<cfquery name="myQRY" datasource="ds_rdt3">
			<cfoutput>
			EXEC [dbo].[exclude_race] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
									, <cfqueryparam value="#series_id#" cfsqltype="cf_sql_integer">
									, <cfqueryparam value="#race_id#" cfsqltype="cf_sql_integer">
									, <cfqueryparam value="#exclude#" cfsqltype="cf_sql_integer">
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

<!--- update_series_qual_setting --->
<cffunction output="no" name="update_series_qual_setting" access="remote" returntype="string">
	<cfargument name="series_id" type="numeric" required="true" />
	<cfargument name="desired_qual_setting" type="string" required="true" />
	
	<cfif Not IsDefined("Session.club_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<!--- only allow ON or OFF values --->
	<cfif desired_qual_setting NEQ "ON" AND desired_qual_setting NEQ "OFF">
		<cfreturn "error">
	</cfif>
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[admin_update_qual_setting] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
												, <cfqueryparam value="#series_id#" cfsqltype="cf_sql_integer">
												, <cfqueryparam value="#desired_qual_setting#" cfsqltype="cf_sql_varchar">
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

<cffunction output="no" name="validTime" returntype="string">
<!--- acceptable formats are 00:00:00.000 and 00:00.000 --->
	<cfargument name="strVal" type="String">
	<cfargument name="default" type="string">
	
	<cfset retVal = default>
	<cfset hms = "">
	<cfset hours = 0>
	<cfset minutes = 0>
	<cfset seconds = 0>
	<cfset ms = 0>
	
	<!--- make sure string is valid length --->
	<cfif Len(strVal) LTE 12>
		<!--- break apart the string into hours/minutes/seconds/milliseconds --->
		<cfif Find(".", strVal) GT 0>
			<cfset timeArr = ListToArray(strVal, ".")>
			<cfif ArrayLen(timeArr) EQ 2>
				<cfset hms = timeArr[1]>
				<cfset ms = timeArr[2]>
			<cfelseif ArrayLen(timeArr) EQ 1>
				<cfset hms = timeArr[1]>
			</cfif>
		</cfif>
		
		<cfif Len(hms) GT 0>
			<cfif Find(":", hms) GT 0>
				<cfset hmsArr = ListToArray(hms, ":")>
				
				<cfif ArrayLen(hmsArr) EQ 2><!--- 00:00 --->
					<cfset minutes = hmsArr[1]>
					<cfset seconds = hmsArr[2]>
				<cfelseif ArrayLen(hmsArr) EQ 3><!--- 00:00:00 --->
					<cfset hours = hmsArr[1]>
					<cfset minutes = hmsArr[2]>
					<cfset seconds = hmsArr[3]>
				</cfif>
			</cfif>
		</cfif>
		
		<!--- validate that each part is a number --->
		<cfif Not IsNumeric(hours)>
			<cfset hours = 0>
		</cfif>
		<cfif Not IsNumeric(minutes)>
			<cfset minutes = 0>
		</cfif>
		<cfif Not IsNumeric(seconds)>
			<cfset seconds = 0>
		</cfif>
		<cfif Not IsNumeric(ms)>
			<cfset ms = 0>
		</cfif>

		<!--- reconstruct the time with padding and return it --->
		<cfif Int(hours) GT 0>
			<cfset retVal = padFront(hours, "00") & ":" & padFront(minutes, "00") & ":" & padFront(seconds, "00") & "." & padEnd(ms, "000")>
		<cfelse>
			<cfset retVal = padFront(minutes, "00") & ":" & padFront(seconds, "00") & "." & padEnd(ms, "000")>
		</cfif>
	</cfif>
	
	<cfreturn retVal>
	
</cffunction>

<cffunction output="no" name="validTimeHourMinute" returntype="string">
<!--- acceptable formats is 00:00 --->
	<cfargument name="strVal" type="String">
	<cfargument name="default" type="string">
	
	<cfset retVal = default>
	<cfset hours = 0>
	<cfset minutes = 0>
	
	<!--- make sure string is valid length --->
	<cfif Find(":", strVal) GT 0>
		<cfset hmsArr = ListToArray(strVal, ":")>
		
		<cfif ArrayLen(hmsArr) EQ 2><!--- 00:00 --->
			<cfset hours = hmsArr[1]>
			<cfset minutes = hmsArr[2]>
		</cfif>
	<cfelse>
		<cfset minutes = strVal>
	</cfif>
	
	<!--- validate that each part is a number --->
	<cfif Not IsNumeric(hours)>
		<cfset hours = 0>
	</cfif>
	<cfif Not IsNumeric(minutes)>
		<cfset minutes = 0>
	</cfif>

	<!--- reconstruct the time with padding and return it --->
	<cfset retVal = padFront(hours, "00") & ":" & padFront(minutes, "00")>
	
	<cfreturn retVal>
	
</cffunction>

<cffunction output="no" name="validDistance" returntype="string">
<!--- acceptable format is 000000.000 --->
	<cfargument name="strVal" type="String">
	<cfargument name="default" type="string">
	
	<cfset retVal = default>
	<cfset intNum = 0>
	<cfset dec = 0>
	
	<!--- make sure string is valid length --->
	<cfif Len(strVal) LTE 10>
		<!--- break apart the string into whole num/decimal --->
		<cfif Find(".", strVal) GT 0>
			<cfset distArr = ListToArray(strVal, ".")>
			<cfif ArrayLen(distArr) EQ 2>
				<cfset intNum = distArr[1]>
				<cfset dec = distArr[2]>
			<cfelseif ArrayLen(distArr) EQ 1>
				<cfset intNum = distArr[1]>
			</cfif>
		<cfelse>
			<cfset intNum = strVal>
		</cfif>
		
		<!--- validate that each part is a number --->
		<cfif Not IsNumeric(intNum)>
			<cfset intNum = 0>
		</cfif>
		<cfif Not IsNumeric(dec)>
			<cfset dec = 0>
		</cfif>
		
		<!--- reconstruct the distance with padding and return it --->
		<cfset retVal = intNum & "." & padEnd(dec, "000")>
		
	</cfif>
	
	<cfreturn retVal>
</cffunction>

<cffunction output="no" name="padFront" returntype="string">
	<cfargument name="strVal" type="string">
	<cfargument name="strPad" type="string">
	
	<cfset strTemp = strPad & strVal><!--- 00+1 --->
	<cfset strTemp = Right(strTemp, Len(strPad))><!--- 0[01] where pad length = 2 --->
	
	<cfreturn strTemp>
</cffunction>

<cffunction output="no" name="padEnd" returntype="string">
	<cfargument name="strVal" type="string">
	<cfargument name="strPad" type="string">
	
	<cfset strTemp = strVal & strPad><!--- 1+000 --->
	<cfset strTemp = Left(strTemp, Len(strPad))><!--- [100]0 where pad length = 3 --->
	
	<cfreturn strTemp>
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