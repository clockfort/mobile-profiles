module Backend where
	-- For LDAP
	import LDAP

	-- For Me
	import qualified Data.Text.Lazy as Lazy
	import Data.Maybe
	import Data.List
	
	-- Internal
	import Config
	import LDAPAttributes
	import HTMLSanitize
	
	fetchAll uid = 
		do	
			cshLDAP <- ldapInit ldapHost Config.ldapPort
			ldapSimpleBind cshLDAP ldapUsername ldapPassword
			let users = ldapSearch cshLDAP (Just ldapSearchOU) LdapScopeSubtree (Just ("uid=" ++ sanitize uid))  (LDAPAllUserAttrs) False
			users

	fetchOverview searchString = 
		do	
			cshLDAP <- ldapInit ldapHost Config.ldapPort
			ldapSimpleBind cshLDAP ldapUsername ldapPassword
			let users = ldapSearch cshLDAP (Just ldapSearchOU) LdapScopeSubtree (Just ("sn=" ++ sanitize searchString ++ "*"))  (LDAPAttrList ["cn", "sn", "uid"]) False
			users
			


	getInfo uid = do
		users <- fetchAll uid
		let user = first users
		let name = names user
		let cell = cellphones user
		let home = homephones user
		let email = emails user
		let aim = aims user
		return [name, cell, home, email, aim]



	
	
	sortedPeople searchString = do
		people <- fetchOverview searchString
		let list = map ldapAttrs $ sortBy surnameSort people
		return list
	

	surnameSort personA personB | lowerSN personA  < lowerSN personB = LT
								| otherwise = GT
								
	lowerSN person = map Lazy.toUpper $ map Lazy.pack $ sn person