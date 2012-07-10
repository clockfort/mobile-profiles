module HTMLBackend where
	import HTMLSanitize
	import LDAPAttributes
	
	prettyConcat []		= []
	prettyConcat (x:xs)	= x ++ "\n" ++ prettyConcat xs
	
	elementize groupName strList
		| length strList > 0	= prettyConcat $ ["<li class=\"group\">"++groupName++"</li>"] ++ [concat["<li>",sanitize x,"</li>"] | x <- strList]
		| otherwise = ""
		
	elementLink groupName strList linkPrefix
		| length strList > 0	= prettyConcat $ [
			"<li class=\"group\">"++groupName++"</li>"] ++ 
			[concat["<li><a href=\"",linkPrefix, sanitize x, "\">",
			sanitize x, "</a></li>"] | x <- strList]
		| otherwise = ""
	
	groupedList people = prettyConcat ["<li><a href=\"../uid/"++sanitize (justAttr "uid" person)++"\">"++sanitize (justAttr "cn" person)++"</a></li>" | person <- people]
	
	alphaList = prettyConcat ["<li class=\"group\"><a href=\"search/"++ sanitize [ch] ++ "\">"++sanitize [ch]++"</a></li>" | ch <- ['A'..'Z']]
