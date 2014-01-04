module LDAPAttributes where
	import LDAP
	import Data.Maybe
	
	first ldapEntries = ldapEntries !! 0
	ldapAttrs (LDAPEntry {leattrs = attrs}) = attrs
	
	-- Generic Wrapper
	entryAttrs attr ldapEntry = fromMaybe [] $ lookup attr $ ldapAttrs ldapEntry
	-- Wrappers that simultaenously provide for LDAP attribute element retrieval
	-- and deal with cases of non-existant elements gracefully
	names      = entryAttrs "names"
	cellphones = entryAttrs "mobile"
	homephones = entryAttrs "homePhone"
	emails     = entryAttrs "mail"
	aims       = entryAttrs "aolScreenName"
	sn         = entryAttrs "sn"
	
	justAttr attr strMap = first $ fromJust $ lookup attr strMap
	
