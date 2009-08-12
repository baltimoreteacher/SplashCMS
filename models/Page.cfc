<cfcomponent extends="Model">

	<!--- All initialization related tasks are done in the "init" function which is run the first time the model is requested. --->
	<cffunction name="init">
	  <cfset belongsTo(name='pageLayout', class="layout", foreignKey="layoutID")>
	  <cfset hasOne('pageClass')>
	  <cfset hasMany('PageParts')>
	    
	  <cfset validatesPresenceOf(property="title" , message="Your page must have a title.")>
	  <cfset validatesPresenceOf(property="slug" , message="Your page must have a slug." )>
	  <cfset validatesUniquenessOf(property="slug", message="The slug you entered already exists.")>
	    
	  <cfset beforeCreate('setCreatedByID')>
	  <cfset beforeUpdate('setUpdatedByID')>
	</cffunction>
	
	<cffunction name="process">
	 
    <!--- get the layout --->
	  <cfset var layout = this.pageLayout().content>
	     
    <!--- look for snippet tags in the layout and process them --->
    <cfset layout = parseSnippets(layout)>
    
    <!--- look for content tags in the layout and process them --->
    <cfset layout = parseContent(layout)>
      
    <!--- look for title tags and replace them with the page title attribute --->
    <cfset layout = parseTitle(layout)>
      
    <!--- look for the navigation tags and parse them --->
    <cfset layout = parseNavigation(layout)>
    
    <!--- this fixes our invalid tags due to CF's script protection --->
    <cfset layout = fixScriptTags(layout)>
	  <cfreturn layout>
	</cffunction>
	
  <cffunction name="parseTitle">
    
  </cffunction>
  
  <cffunction name="parseContent">
    <cfargument name="content" type="string" required="true" />
    <cfset var content = arguments.content>
    <cfset var hasContent = TRUE>
    <cfset var pagePart = "">
    <cfset var splashTag = "">
    <cfset var xmlTag = "">
    <cfset var pagePartName = "">
      
    <cfloop condition=" hasContent ">
      <cfif findnocase("<content", content) >
        <cfset splashTag = getSplashTag(stripMode="disallow", myTags="content", myString="#content#", findOnly="true")>
        <cfset xmlTag = xmlParse(splashTag)>
          <!---
            TODO Need to add some checking here for condition attributes
          --->
        <cfset pagePartName = xmltag.xmlRoot.xmlAttributes.part>
        <cfset pagePart = model('pagePart').findOneByPageidAndName("#this.id#, #pagePartName#")>
        <cfif isObject(pagePart)>
          <cfset pagePart = parseSnippets(pagePart.content)>
          <cfset pagePart = textile(pagePart)>
          <cfset content = replaceNoCase(content, splashTag, pagePart)>
        <cfelse>
          <!--- if we cant find the pagePart just replace the tag with a comment --->
          <cfset content = replaceNoCase(content, splashTag, "<!-- You referenced a pagePart that doesnt exist --->")>
        </cfif>
      <cfelse>
        <cfset hasContent = FALSE>
      </cfif>
    </cfloop>
    <cfreturn content>
  </cffunction>
  
  <cffunction name="parseSnippets">
    <cfargument name="content" type="string" required="true" />
    <cfset var content = arguments.content>
    <cfset var hasSnippets = true>
    <cfset var splashTag = "">
    <cfset var xmlTag = "">
    <cfset var snippetName = "">
    <cfset var snippet = "">
    
    <cfloop condition=" hasSnippets ">
      <cfif findNoCase("<snippet", content)>
        <cfset splashTag = getSplashTag(stripMode="disallow", myTags="snippet", myString="#content#", findOnly="true")>
        <cfset xmlTag = xmlParse(splashTag)>
        <cfset snippetName = xmltag.xmlRoot.xmlAttributes.name>
        <cfset snippet = model('snippet').findOneByName(snippetName)>
        <cfif isObject(snippet)>
          <cfset content = replaceNoCase(content, splashTag, snippet.content)>
        <cfelse>
          <!--- if we cant find the snippet just replace the tag with a comment --->
          <cfset content = replaceNoCase(content, splashTag, "<!-- You referenced a snippet that doesnt exist --->")>
        </cfif>
      <cfelse>
        <cfset hasSnippets = FALSE>
      </cfif>
    </cfloop>
    <cfreturn content>
  </cffunction>

  <cffunction name="parseTitle">
    <cfargument name="content" type="string" required="true" />
    <cfset var content = arguments.content>
    <cfset var hasTitle = true>
      
      <cfif findNoCase("<title", content)>
        <!---
          TODO Need to look at some regex matching for these to clean this up some
        --->
        <cfset content = replaceNoCase(content, "<title/>", this.title, "ALL")>
        <cfset content = replaceNoCase(content, "<title />", this.title, "ALL")>
      <cfelse>
        <cfset hasTitle = FALSE>
      </cfif>
    <cfreturn content>
  </cffunction>
  
  <cffunction name="parseNavigation">
    <cfargument name="content" type="string" required="true" />
    <cfset var content = arguments.content>
    <cfset var hasNavigation = true>
    <cfset var splashTag = "">
    <cfset var xmlTag = "">
    <cfset var urls = "">
    <cfset var parsedNav = "">
    <!---
      TODO need to add the current state attribute to the parser
    --->
    <cfloop condition=" hasNavigation ">
      <cfif findNoCase("<navigation", content)>
        <cfset splashTag = getSplashTag(stripMode="disallow", myTags="navigation", myString="#content#", findOnly="true")>
        <cfset xmlTag = xmlParse(splashTag)>
        <cfset urls = xmltag.xmlRoot.xmlAttributes.urls>
          
        <cfif findNoCase("enclosingTag", splashTag)>
          <cfset linkPrepend = "<" & xmltag.xmlRoot.xmlAttributes.enclosingTag & ">">
          <cfset linkAppend = "</" & xmltag.xmlRoot.xmlAttributes.enclosingTag & ">">
        <cfelse>
          <cfset linkPrepend = "">
          <cfset linkAppend = "">
        </cfif>
        
        <cfloop list="#urls#" index="item" delimiters="|">
          <cfset parsedNav = parsedNav & linkPrepend & '<a href="#listLast(item,':')#">' & listFirst(item,":") & '</a>' & linkAppend>
        </cfloop>

        <cfset content = replaceNoCase(content, splashTag, parsedNav)>
      <cfelse>
        <cfset hasNavigation = FALSE>
      </cfif>
    </cfloop>
    <cfreturn content>
  </cffunction>
  

  <!--- PRIVATE METHODS --->
	
	<cffunction name="fixScriptTags" access="private">
    <cfargument name="code" type="string" required="true">
    <cfset var loc = arguments.code>
    <cfreturn replaceNoCase(loc, 'invalidtag', 'script', 'ALL')>
  </cffunction>

</cfcomponent>


