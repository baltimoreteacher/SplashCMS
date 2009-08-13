<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>Splash CMS :: Login</title>
  <link rel="stylesheet" href="/stylesheets/base.css" type="text/css" media="screen" />
  <link rel="stylesheet" id="current-theme" href="/stylesheets/themes/blue/style.css" type="text/css" media="screen" />
  <link rel="stylesheet" id="current-theme" href="/stylesheets/splash//jquery-ui-1.7.2.custom.css" type="text/css" media="screen" />
  <script type="text/javascript" charset="utf-8" src="/javascripts/jquery-1.3.min.js"></script>
    <script type="text/javascript">
    $(document).ready(function(){
      
      // this adds the nice hover state to all of our buttons    	
    	$('.ui-button').hover(function() {
      		$(this).addClass("ui-state-hover");
      	}, function() {
      		$(this).removeClass("ui-state-hover");
    	});
    	
    });
  </script>
</head>
<body>
  <div id="container">
    <div id="header">
      <h1><a href="/admin">Splash CMS</a></h1>
    </div>
        
    <div class="block">
      <div class="content">
        <div class="inner">
          <cfoutput>#contentForLayout()#</cfoutput>
        </div>
      </div>
    </div>

    <cfoutput>#includePartial('/shared/footer')#</cfoutput>

  </div>
</body>
</html>