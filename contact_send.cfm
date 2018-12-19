<cfif IsDefined("btnSubmit")>
	<!--- btnSubmit was clicked! :) --->
	
	<cfsavecontent variable="myTextContent">
	<cfoutput>
		Name: #FORM.txtName#
		
		Email: #FORM.txtFrom#
		
		#FORM.txtBody#
	</cfoutput>
	</cfsavecontent>
	
	<cfsavecontent variable="myHTMLContent">
	<cfoutput>
		<b>Name:</b> #FORM.txtName#<br />
		<b>Email:</b> #FORM.txtFrom#<br /><br />
		#FORM.txtBody#
	</cfoutput>
	</cfsavecontent>
	
	<cftry>
	<cfoutput>
		<cfmail to="rcm@racingclubmanager.com" from="no-reply@racingclubmanager.com" subject="E-mail from racingclubmanager.com" replyto="#FORM.txtFrom#" type="html">
			<cfmailpart type="text/plain" charset="utf-8">#myTextContent#</cfmailpart>
			<cfmailpart type="text/html" charset="utf-8">#myHTMLContent#</cfmailpart>
		</cfmail>
	</cfoutput>
	
		<cfcatch>
			<cflocation url="contact.cfm?sent=0" addtoken="no">
		</cfcatch>
	</cftry>
	
	<cflocation url="contact.cfm?sent=1" addtoken="no">
<cfelse>
	<!--- btnSubmit was not clicked! :( --->
	<cflocation url="contact.cfm" addtoken="no">
</cfif>