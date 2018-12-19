<cfcomponent>


<cffunction output="no" name="getWinnersCircle" access="remote" returntype="string">
	<cfargument name="club_id" type="numeric" required="true" />
	<cfargument name="racer_id" type="numeric" required="true" />
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
			EXEC [dbo].[get_winners_circle_data] <cfqueryparam value="#club_id#" cfsqltype="cf_sql_integer">
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

<cffunction output="no" name="getWinnersCircle_slice" access="remote" returntype="string">
	<cfargument name="club_id" type="numeric" required="true" />
	<cfargument name="racer_id" type="numeric" required="true" />
	<cfargument name="slice" type="string" required="true" />
	
	<cfif slice EQ "Gold" OR
		  slice EQ "Silver" OR
		  slice EQ "Bronze" OR
		  slice EQ "Non Podium" OR
		  slice EQ "DNF">
		<!--- GREAT! --->
	<cfelse>
		<cfreturn "error">
	</cfif>

	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
			EXEC [dbo].[get_winners_circle_slice] <cfqueryparam value="#club_id#" cfsqltype="cf_sql_integer">
												, <cfqueryparam value="#racer_id#" cfsqltype="cf_sql_integer">
												, <cfqueryparam value="#slice#" cfsqltype="cf_sql_varchar">
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

<cffunction output="no" name="getAvgFinChart" access="remote" returntype="string">
	<cfargument name="club_id" type="numeric" required="true" />
	<cfargument name="racer_id" type="numeric" required="true" />
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
			EXEC [dbo].[get_avgFinishChartData_perRacer] <cfqueryparam value="#club_id#" cfsqltype="cf_sql_integer">
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

<cffunction output="no" name="getRacerNameClubStatus" access="remote" returntype="string">
	<cfargument name="club_id" type="numeric" required="true" />
	<cfargument name="racer_id" type="numeric" required="true" />
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
			EXEC [dbo].[get_racerDetails] <cfqueryparam value="#club_id#" cfsqltype="cf_sql_integer">
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

<cffunction output="no" name="getSeriesWins" access="remote" returntype="string">
	<cfargument name="club_id" type="numeric" required="true" />
	<cfargument name="racer_id" type="numeric" required="true" />
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
			EXEC [dbo].[getSeriesWins] <cfqueryparam value="#club_id#" cfsqltype="cf_sql_integer">
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

<cffunction output="no" name="getRacesWins" access="remote" returntype="string">
	<cfargument name="club_id" type="numeric" required="true" />
	<cfargument name="racer_id" type="numeric" required="true" />
	
	<cfset retVal = "">
	<cfquery name="myQRY" datasource="ds_rdt3">
		<cfoutput>
			EXEC [dbo].[getRacesWins] <cfqueryparam value="#club_id#" cfsqltype="cf_sql_integer">
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