<cfcomponent>

<!--- get all personalities --->
<cffunction output="no" name="get_all_personalities" access="remote" returntype="string">
	
	<cfif Not IsDefined("Session.club_id")>
		<cfreturn "sessionError">
	</cfif>
	
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

<!--- check club profile data --->
<cffunction output="no" name="get_admin_club_profile_data" access="remote" returntype="string">
	
	<cfif Not IsDefined("Session.club_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_admin_club_profile_data] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
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
	
	<cfif Not IsDefined("Session.club_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[check_club_name_unique] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
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

<!--- check slug name for uniqueness --->
<cffunction output="no" name="check_slug_name_unique" access="remote" returntype="string">
	<cfargument name="slug_name" type="string" required="true" />
	
	<cfif Not IsDefined("Session.club_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[check_slug_name_unique] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
											, <cfqueryparam value="#TRIM(doEncode(slug_name))#" cfsqltype="cf_sql_varchar">
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

<!--- save club profile data --->
<cffunction output="no" name="save_admin_club_profile_data" access="remote" returntype="string">
	<cfargument name="club_name" type="string" required="true" />
	<cfargument name="slug_name" type="string" required="true" />
	<cfargument name="personality_id" type="numeric" required="true" />
	<cfargument name="ask_to_join" type="numeric" required="true" />
	<cfargument name="platform" type="string" required="true" />
	
	<cfif Not IsDefined("Session.club_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<!--- check that the club name uses only the allowed characters --->
	<cfloop index="i" from="1" to="#Len(club_name)#">
		<cfset thisChar = Asc(Mid(club_name,i,1))>
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
			<cfreturn "invalidClubError">
		</cfif>
	</cfloop>

	<!--- check that the slug name uses only the allowed characters --->
	<cfloop index="i" from="1" to="#Len(slug_name)#">
		<cfset thisChar = Asc(Mid(slug_name,i,1))>
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
			<cfreturn "invalidSlugError">
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
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[save_admin_club_profile_data] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
												, <cfqueryparam value="#TRIM(doEncode(club_name))#" cfsqltype="cf_sql_varchar">
												, <cfqueryparam value="#personality_id#" cfsqltype="cf_sql_integer">
												, <cfqueryparam value="#ask_to_join#" cfsqltype="cf_sql_integer">
												, <cfqueryparam value="#TRIM(doEncode(slug_name))#" cfsqltype="cf_sql_varchar">
												, <cfqueryparam value="#TRIM(doEncode(platform))#" cfsqltype="cf_sql_varchar">
		</cfoutput>
	</cfquery>
	
	<cfoutput query="myQRY">
		<cfset retVal = myQRY.msg>
	</cfoutput>
	
	<cfreturn retVal>
</cffunction>

<!--- save club desc --->
<cffunction output="no" name="save_admin_club_desc" access="remote" returntype="string">
	<cfargument name="club_desc" type="string" required="true" />
	<cfargument name="chunk_idx" type="numeric" required="true" />
	
	<cfif Not IsDefined("Session.club_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[save_admin_club_desc] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
										, <cfqueryparam value="#TRIM(club_desc)#" cfsqltype="cf_sql_varchar">
										, <cfqueryparam value="#chunk_idx#" cfsqltype="cf_sql_integer">
		</cfoutput>
	</cfquery>
	
	<cfoutput query="myQRY">
		<cfset retVal = myQRY.msg>
	</cfoutput>
	
	<cfreturn retVal>
</cffunction>

<cffunction output="no" name="delete_club" access="remote" returntype="string">
	<cfif Not IsDefined("Session.club_id")>
		<cfreturn "sessionError">
	</cfif>
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[admin_delete_club] <cfqueryparam value="#Session.club_id#" cfsqltype="cf_sql_integer">
		</cfoutput>
	</cfquery>
	
	<cfif myQRY.msg EQ "error">
		<cfreturn "error">
	<cfelse>
		<cfreturn "good">
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