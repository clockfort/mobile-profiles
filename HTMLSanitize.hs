module HTMLSanitize where

	--Awwww yeah, sanitizing user-editable fields with folds and list comprehensions.
	-- This is how the web was meant to be.
	sanitize str = foldl escapist [] str
	
	escapist xs x 	| x == '<' = xs ++ "&lt;"
					| x == '>' = xs ++ "&gt;"
					| x == '"' = xs ++ "&quot;"
					| x == '&' = xs ++ "&amp;"
					| otherwise = xs ++ [x]