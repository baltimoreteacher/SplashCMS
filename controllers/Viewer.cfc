<!---  Viewer --->
<!--- @@Created By: Russ Johnson on 2009-07-30. --->
<!--- @@Copyright: Copyright (c) 2009 Mad Piranha, Inc.. All rights reserved. --->
<!--- @@License: --->
<cfcomponent extends="Controller">
	
	<cffunction name="init">
	</cffunction>
	
	<cffunction name="index">
    <cfparam name="params.slug" default="/">
    <cfset page = model('page').findOneBySlug(params.slug)>
    
    <!--- todo: we need to make sure a page was returned, if not redirect to the home page --->
    <cfif isObject(page)>
      <cfset renderedPage = page.process()>
    <cfelse>
      <!--- set something in the flash here and redirect home --->
    </cfif>
  </cffunction>
	
</cfcomponent>