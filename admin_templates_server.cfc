<cfcomponent>

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

<!--- get points by template id --->
<cffunction output="no" name="get_points_by_template" access="remote" returntype="string">
	<cfargument name="template_id" type="numeric" required="true" />
	
	<cfif Not IsDefined("Session.club_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_points_by_template] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
											, <cfqueryparam value="#Session.admin_id#" cfsqltype="cf_sql_integer">
											, <cfqueryparam value="#template_id#" cfsqltype="cf_sql_integer">
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

<!--- check if we can remove a row in points template --->
<cffunction output="no" name="check_remove_pts_row" access="remote" returntype="string">
	<cfargument name="template_id" type="numeric" required="true" />
	<cfargument name="finish_position" type="numeric" required="true" />
	
	<cfif Not IsDefined("Session.club_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[check_remove_pts_row] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
											, <cfqueryparam value="#template_id#" cfsqltype="cf_sql_integer">
											, <cfqueryparam value="#finish_position#" cfsqltype="cf_sql_integer">
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

<!--- Save Points Template --->
<cffunction output="no" name="save_pts_template" access="remote" returntype="string">
	<cfargument name="template_id" type="numeric" required="true" />
	<cfargument name="template_name" type="string" required="true" />
	<cfargument name="strPts" type="string" required="true" />
	<cfargument name="series_id" type="string" required="true" />
	<cfargument name="num_pos" type="string" required="true" />
	
	<cfif Not IsDefined("Session.club_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<cfset strErrMsg = "An error occured while trying to save your template: ">
	<cfset temp_id = -1>
	<!--- Save the template name --->
	<cftry>
		<cfquery name="save_template_qry" datasource="ds_rdt3">
			<cfoutput>
			EXEC [dbo].[save_pts_template] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
											, <cfqueryparam value="#template_id#" cfsqltype="cf_sql_integer">
											, <cfqueryparam value="#Trim(doEncode(template_name))#" cfsqltype="cf_sql_varchar">
											, <cfqueryparam value="#series_id#" cfsqltype="cf_sql_integer">
											, <cfqueryparam value="#num_pos#" cfsqltype="cf_sql_integer">
			</cfoutput>
		</cfquery>
		
		<cfcatch>
			<cfreturn strErrMsg & "SE01">
		</cfcatch>
	</cftry>
	
	<cfif save_template_qry.msg EQ "error">
		<cfreturn strErrMsg & "SE02">
	<cfelseif save_template_qry.msg EQ "errorPos">
		<cfreturn "errorPos">
	<cfelse>
		<cfset temp_id = save_template_qry.template_id>
	</cfif>
	
	<!--- delete all points records for this template --->
	<cftry>
		<cfquery name="delete_pts_qry" datasource="ds_rdt3">
			<cfoutput>
			EXEC [dbo].[delete_points_by_template] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
													, <cfqueryparam value="#temp_id#" cfsqltype="cf_sql_integer">
			</cfoutput>
		</cfquery>
		
		<cfcatch>
			<cfreturn strErrMsg & "SE03">
		</cfcatch>
	</cftry>
	
	<!--- save points by template --->
	<cfset commaArray = ListToArray(strPts, ",")>
	<cfloop from="1" to="#ArrayLen(commaArray)#" index="i">
		<cfset dataArray = ListToArray(commaArray[i], "=")>
		<cfset pos = dataArray[1]>
		<cfset pts = dataArray[2]>
		
		<cftry>
			<cfquery name="save_pts_qry" datasource="ds_rdt3">
				<cfoutput>
				EXEC [dbo].[save_points_by_template] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
													, <cfqueryparam value="#temp_id#" cfsqltype="cf_sql_integer">
													, <cfqueryparam value="#pos#" cfsqltype="cf_sql_integer">
													, <cfqueryparam value="#pts#" cfsqltype="cf_sql_integer">
				</cfoutput>
			</cfquery>
			
			<cfcatch>
				<cfreturn strErrMsg & "SE04:" & i>
			</cfcatch>
		</cftry>
	</cfloop>
	
	<cfreturn "good">
</cffunction>

<!--- save this template id to this series --->
<cffunction output="no" name="save_template_to_series" access="remote" returntype="string">
	<cfargument name="series_id" type="numeric" required="true" />
	<cfargument name="template_id" type="numeric" required="true" />
	
	<cfif Not IsDefined("Session.club_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[save_template_to_series] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
											, <cfqueryparam value="#series_id#" cfsqltype="cf_sql_integer">
											, <cfqueryparam value="#template_id#" cfsqltype="cf_sql_integer">
		</cfoutput>
	</cfquery>
	
	<cfreturn myQRY.msg>
</cffunction>

<!--- check if we can remove a row in points template --->
<cffunction output="no" name="delete_pts_template" access="remote" returntype="string">
	<cfargument name="template_id" type="numeric" required="true" />
	
	<cfif Not IsDefined("Session.club_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[delete_pts_template] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
										, <cfqueryparam value="#template_id#" cfsqltype="cf_sql_integer">
		</cfoutput>
	</cfquery>
	
	<cfreturn myQRY.msg>
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