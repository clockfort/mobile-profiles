module LDAPAttributes where
	import LDAP
	import Data.Maybe
	
	first ldapEntries = ldapEntries !! 0
	ldapAttrs (LDAPEntry {leattrs = attrs}) = attrs
	
	names ldapEntry = fromMaybe [] $ lookup "cn" $ ldapAttrs ldapEntry
	cellphones ldapEntry = fromMaybe [] $ lookup "cellPhone" $ ldapAttrs ldapEntry
	homephones ldapEntry = fromMaybe [] $ lookup "homePhone" $ ldapAttrs ldapEntry
	emails ldapEntry = fromMaybe [] $ lookup "mail" $ ldapAttrs ldapEntry
	aims ldapEntry = fromMaybe [] $ lookup "aolScreenName" $ ldapAttrs ldapEntry
	sn ldapEntry = fromMaybe [] $ lookup "sn" $ ldapAttrs ldapEntry
	
	justAttr attr strMap = first $ fromJust $ lookup attr strMap
	