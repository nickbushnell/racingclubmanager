<cfcomponent>




<!--- get current flag --->
<cffunction output="no" name="get_current_flag" access="remote" returntype="string">
	<cfargument name="race_id" type="numeric" required="true" />
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_flag] <cfqueryparam value="#race_id#" cfsqltype="cf_sql_integer">
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

<!--- get race name --->
<cffunction output="no" name="get_race_info" access="remote" returntype="string">
	<cfargument name="race_id" type="numeric" required="true" />
	
	<cfquery name="clubQRY" datasource="ds_rdt3">
		<cfoutput>
		SELECT club_id 
		FROM series 
		WHERE series_id IN( 
			SELECT series_id 
			FROM races 
			WHERE race_id = <cfqueryparam value="#race_id#" cfsqltype="cf_sql_integer">
		)
		</cfoutput>
	</cfquery>
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
		EXEC [dbo].[get_race_share] <cfqueryparam value="#clubQRY.club_id#" cfsqltype="cf_sql_integer">
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