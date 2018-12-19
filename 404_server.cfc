<cfcomponent>

<!--- get tracks --->
<cffunction output="no" name="get_club_slug" access="remote" returntype="string">
	<cfargument name="club_slug" type="string" />
	
	<cfset club_slug = URLDecode(club_slug)>
	<cfset club_slug = doEncode(club_slug)>
	<cfset club_slug = Trim(club_slug)>
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_club_slug] <cfqueryparam value="#club_slug#" cfsqltype="cf_sql_varchar">
		</cfoutput>
	</cfquery>
	
	<cfreturn myQRY.club_id>

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