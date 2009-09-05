  <cfif thisTag.executionMode is "start">
    <cfset url = request.page.slug>  
    <cfset title = request.page.title>
    <cfset urlString='<a href="'>
  </cfif>
  <cfif thisTag.executionMode is "end">
    <cfif len(thisTag.generatedContent)>
      <cfset linkText = thisTag.generatedContent>
      <cfset thisTag.generatedContent = "">
    <cfelse>
      <cfset linkText = title>
    </cfif>
    <cfset urlString = urlString & request.page.slug & '">' & linkText & '</a>'>
    <cfoutput>#urlString#</cfoutput>
  </cfif>