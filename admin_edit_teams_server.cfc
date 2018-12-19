<cfcomponent>

<cffunction output="no" name="get_teams" access="remote" returntype="string">
	<cfargument name="series_id" type="numeric" required="true" />
	
	<cfif Not IsDefined("Session.club_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[admin_get_teams] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
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


<cffunction output="no" name="check_number_teams" access="remote" returntype="string">
	<cfargument name="series_id" type="numeric" required="true" />
	
	<cfif Not IsDefined("Session.club_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[admin_check_number_teams] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
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


<cffunction output="no" name="get_avail_members" access="remote" returntype="string">
	<cfargument name="series_id" type="numeric" required="true" />
	
	<cfif Not IsDefined("Session.club_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[admin_get_avail_team_members] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
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


<cffunction output="no" name="load_team" access="remote" returntype="string">
	<cfargument name="series_id" type="numeric" required="true" />
	<cfargument name="team_id" type="numeric" required="true" />
	
	<cfif Not IsDefined("Session.club_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[admin_load_team] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
									, <cfqueryparam value="#series_id#" cfsqltype="cf_sql_integer">
									, <cfqueryparam value="#team_id#" cfsqltype="cf_sql_integer">
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


<cffunction output="no" name="remove_racer_from_team" access="remote" returntype="string">
	<cfargument name="series_id" type="numeric" required="true" />
	<cfargument name="team_id" type="numeric" required="true" />
	<cfargument name="racer_id" type="numeric" required="true" />
	
	<cfif Not IsDefined("Session.club_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[admin_remove_racer_from_team] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
												, <cfqueryparam value="#series_id#" cfsqltype="cf_sql_integer">
												, <cfqueryparam value="#team_id#" cfsqltype="cf_sql_integer">
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


<cffunction output="no" name="add_racer_to_team" access="remote" returntype="string">
	<cfargument name="series_id" type="numeric" required="true" />
	<cfargument name="team_id" type="numeric" required="true" />
	<cfargument name="racer_id" type="numeric" required="true" />
	
	<cfif Not IsDefined("Session.club_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[admin_add_racer_to_team] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
											, <cfqueryparam value="#series_id#" cfsqltype="cf_sql_integer">
											, <cfqueryparam value="#team_id#" cfsqltype="cf_sql_integer">
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

<cffunction output="no" name="delete_team" access="remote" returntype="string">
	<cfargument name="series_id" type="numeric" required="true" />
	<cfargument name="team_id" type="numeric" required="true" />
	
	<cfif Not IsDefined("Session.club_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<!---
	<cfoutput>
		<cfreturn "EXEC [dbo].[admin_delete_team] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">, #series_id#, #team_id#">
	</cfoutput>
	--->
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[admin_delete_team] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
										, <cfqueryparam value="#series_id#" cfsqltype="cf_sql_integer">
										, <cfqueryparam value="#team_id#" cfsqltype="cf_sql_integer">
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

<cffunction output="no" name="add_save_team" access="remote" returntype="string">
	<cfargument name="series_id" type="numeric" required="true" />
	<cfargument name="team_id" type="numeric" required="true" />
	<cfargument name="team_name" type="string" required="true" />
	<cfargument name="team_abbr" type="string" required="true" />
	
	<cfif Not IsDefined("Session.club_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<cfif Len(team_name) LTE 0>
		<cfreturn "lenError">
	</cfif>
	
	<cfloop index="i" from="1" to="#Len(team_name)#">
		<cfset thisChar = Asc(Mid(team_name,i,1))>
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
	
	<cfif Len(team_abbr) GT 0>
		<cfloop index="i" from="1" to="#Len(team_abbr)#">
			<cfset thisChar = Asc(Mid(team_abbr,i,1))>
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
	<cfelse>
		<cfset team_abbr = Left(team_name, 4)>
	</cfif>
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[admin_add_save_team] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
										, <cfqueryparam value="#series_id#" cfsqltype="cf_sql_integer">
										, <cfqueryparam value="#team_id#" cfsqltype="cf_sql_integer">
										, <cfqueryparam value="#team_name#" cfsqltype="cf_sql_varchar">
										, <cfqueryparam value="#team_abbr#" cfsqltype="cf_sql_varchar">
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