module HTMLSanitize where

	--Awwww yeah, sanitizing user-editable fields with folds and list comprehensions.
	-- This is how the web was meant to be.
	sanitize str = stripEscapists $ stripTags str
	
	stripTags = res . foldl update (Right "")
		where
			res (Left s)  = s
			res (Right s) = s

			update (Left c) '>'  = Right c
			update (Left c) _    = Left c
			update (Right c) '<' = Left c
			update (Right c) n   = Right (c ++ [n])

	stripEscapists str = [ ch | ch <- str, ch `notElem` "\\<>\"&" ]