module Backend where
	-- For LDAP
	import LDAP

	-- For Me
	import qualified Data.Text.Lazy as Lazy
	import Data.Maybe
	import Data.List
	import Config
	

	fetchAll uid = 
		do	
			cshLDAP <- ldapInit ldapHost Config.ldapPort
			ldapSimpleBind cshLDAP ldapUsername ldapPassword
			let users = ldapSearch cshLDAP (Just ldapSearchOU) LdapScopeSubtree (Just ("uid=" ++ uid))  (LDAPAllUserAttrs) False
			users

	fetchOverview = 
		do	
			cshLDAP <- ldapInit ldapHost Config.ldapPort
			ldapSimpleBind cshLDAP ldapUsername ldapPassword
			let users = ldapSearch cshLDAP (Just ldapSearchOU) LdapScopeSubtree (Just "uid=*")  (LDAPAttrList ["cn", "sn"]) False
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
		let aim = aims user
		return [name, cell, home, email, aim]


	names ldapEntry = fromMaybe [] $ lookup "cn" $ ldapAttrs ldapEntry
	cellphones ldapEntry = fromMaybe [] $ lookup "cellPhone" $ ldapAttrs ldapEntry
	homephones ldapEntry = fromMaybe [] $ lookup "homePhone" $ ldapAttrs ldapEntry
	emails ldapEntry = fromMaybe [] $ lookup "mail" $ ldapAttrs ldapEntry
	aims ldapEntry = fromMaybe [] $ lookup "aolScreenName" $ ldapAttrs ldapEntry
	sn ldapEntry = fromMaybe [] $ lookup "sn" $ ldapAttrs ldapEntry
	
	
	sortedPeople = do
		people <- fetchOverview
		let list = sortBy surnameSort [ person | person <- people]
		return list
	

	surnameSort personA personB | lowerSN personA  < lowerSN personB = LT
								| otherwise = GT
								
	lowerSN person = map Lazy.toLower $ map Lazy.pack $ sn person