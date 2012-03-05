module Backend where
	-- For LDAP
	import LDAP

	-- For Me
	import Data.Text.Lazy
	import Data.Maybe
	
	import Config
	
	lookupUID uid = 
		do	
			cshLDAP <- ldapInit ldapHost Config.ldapPort
			ldapSimpleBind cshLDAP ldapUsername ldapPassword
			let users = ldapSearch cshLDAP (Just ldapSearchOU) LdapScopeSubtree (Just ("uid=" ++ uid))  (LDAPAttrList ["cn"]) False
			users

	fetchAll uid = 
		do	
			cshLDAP <- ldapInit ldapHost Config.ldapPort
			ldapSimpleBind cshLDAP ldapUsername ldapPassword
			let users = ldapSearch cshLDAP (Just ldapSearchOU) LdapScopeSubtree (Just ("uid=" ++ uid))  (LDAPAllUserAttrs) False
			users


	first ldapEntries = ldapEntries !! 0
	ldapAttrs (LDAPEntry {leattrs = attrs}) = attrs

	getInfo uid = do
		users <- fetchAll uid
		let user = first users
		let name = names user
		let cell = cellphones user
		let home = homephones user
		let email = emails user
		return [name, cell, home, email]


	names ldapEntry = fromMaybe [] $ lookup "cn" $ ldapAttrs ldapEntry
	cellphones ldapEntry = fromMaybe [] $ lookup "cellPhone" $ ldapAttrs ldapEntry
	homephones ldapEntry = fromMaybe [] $ lookup "homePhone" $ ldapAttrs ldapEntry
	emails ldapEntry = fromMaybe [] $ lookup "mail" $ ldapAttrs ldapEntry
