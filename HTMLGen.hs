module HTMLGen where
	-- I think this might be the most functional way to define dynamic webpages 
	-- (combination of folds, recursion, and heavily nested build-upon functions)
	
	prettyConcat []		= []
	prettyConcat (x:xs)	= x ++ "\n" ++ prettyConcat xs
	
	-- I really hope the compiler evaluates this at compile-time.
	htmlPage pageTitle = prettyConcat ["<!DOCTYPE html>","<html>", htmlHeader "", htmlBody pageTitle, "</html>"]
	
	htmlHeader prelink= prettyConcat ["<head>", htmlTitle, htmlMeta, htmlIcon, htmlCSS prelink, googleAnalytics, "</head>"]
	htmlTitle = prettyConcat ["<title>","CSH Mobile Profiles","</title>"]
	htmlMeta = "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0\"/>"
	
	htmlIcon = prettyConcat ["<link rel=\"icon\" type=\"image/x-icon\" href=\"http://csh.rit.edu/files/favicon.ico\">",
		"<link rel=\"apple-touch-icon\" href=\"iui/iui-logo-touch-icon.png\" />"]
		
	htmlCSS prelink = prettyConcat [
		"<link rel=\"stylesheet\" href=\""++prelink++"iui/iui.css\" type=\"text/css\" />",
		"<link rel=\"stylesheet\" title=\"Default\" href=\""++prelink++"iui/t/default/default-theme.css\"  type=\"text/css\"/>",
		"<link rel=\"stylesheet\" href=\""++prelink++"iui/iui-panel-list.css\" type=\"text/css\" />",
		"<style type=\"text/css\">",
		".panel p.normalText { text-align: left;  padding: 0 10px 0 10px; }",
		"</style>"
		]
		
	googleAnalytics = prettyConcat ["<script type=\"text/javascript\">",
		"var _gaq = _gaq || [];",
		"_gaq.push(['_setAccount', 'UA-8634743-10'], ['_trackPageview']);",
		"</script>",
		"<script type=\"text/javascript\">",
		"(function() {",
		"var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;",
		"ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';",
		"var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);",
		"})();",
		"</script>"]
	
	htmlBody pageTitle = prettyConcat ["<body>", toolbar pageTitle, "</body>"]
	
	
	toolbar pageTitle = prettyConcat [
		"<div class=\"toolbar\">",
		"<h1 id=\"pageTitle\">"++pageTitle++"</h1>",
		"<a id=\"backButton\" class=\"button\" href=\"#\"></a>",
		"<a class=\"button\" href=\"http://members.csh.rit.edu/profiles/\">Old Site</a>",
		"</div>" ]
	
	contactPage [names, cellphones, homephones, emails, aims] = prettyConcat [
		"<!DOCTYPE html>",
		"<html>",
		htmlHeader "../",
		"<body>",
		toolbar "Contact",
		contactScreen [names, cellphones, homephones, emails, aims],
		"</body>",
		"</html>" ]
	
	contactScreen [names, cellphones, homephones, emails, aims] = prettyConcat [
		"<ul id=\"screen1\" title=\"Profiles\" selected=\"true\">",
		elementize "Name" names,
		elementize "Cell Phone" cellphones,
		elementize "Home Phone" homephones,
		elementLink "Email Address" emails "mailto:",
		elementLink "AIM Screen Name" aims "aim:goim?screenname=",
		"</ul>" ]
	
	
	elementize groupName strList
		| (length strList) > 0	= prettyConcat $ ["<li class=\"group\">"++groupName++"</li>"] ++ [concat["<li>",sanitize x,"</li>"] | x <- strList]
		| otherwise = ""
		
	elementLink groupName strList linkPrefix
		| (length strList) > 0	= prettyConcat $ ["<li class=\"group\">"++groupName++"</li>"] ++ [concat["<li><a href=\"", linkPrefix, sanitize x, "\">", sanitize x, "</a></li>"] | x <- strList]
		| otherwise = ""

	sanitize str = stripEscapists $ stripTags str
	
	stripTags = res . foldl update (Right "")
		where
			res (Left s)  = s
			res (Right s) = s

			update (Left c) '>'  = Right c
			update (Left c) _    = Left c
			update (Right c) '<' = Left c
			update (Right c) n   = Right (c ++ [n])

	stripEscapists str = [ ch | ch <- str, ch `notElem` "\\<>\"" ]