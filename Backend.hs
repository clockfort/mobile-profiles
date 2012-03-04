module Backend where
	-- For LDAP
	import LDAP
	import LDAP.Constants

	-- For Me
	import Control.Monad.Trans
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
		let cell = cells user
		let email = emails user
		return [name, cell, email]


	names ldapEntry = fromMaybe [""] $ lookup "cn" $ ldapAttrs ldapEntry
	cells ldapEntry = fromMaybe [""] $ lookup "cellPhone" $ ldapAttrs ldapEntry
	emails ldapEntry = fromMaybe [""] $ lookup "mail" $ ldapAttrs ldapEntry	 