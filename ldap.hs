-- For Scotty
{-# LANGUAGE OverloadedStrings #-}
import Web.Scotty
import Data.Monoid (mconcat)

-- For LDAP
import LDAP
import LDAP.Constants

-- For Me
import Control.Monad.Trans
import Data.Text.Lazy

main = scotty 3000 $ do
	get "/" $
		file "main_search_page.html"
	get "/uid/:uid" $ do
		uid <- param "uid"
		name <- liftIO $ getName $ unpack uid
		json name


lookupUID uid = 
	do	
		cshLDAP <- ldapInit "ldap.csh.rit.edu" LDAP.Constants.ldapPort
		ldapSimpleBind cshLDAP "cn=hsLDAP,ou=Apps,dc=csh,dc=rit,dc=edu" ""
		let users = ldapSearch cshLDAP (Just "ou=Users,dc=csh,dc=rit,dc=edu") LdapScopeSubtree (Just ("uid=" ++ uid))  (LDAPAttrList ["cn"]) False
		users



first ldapEntries = ldapEntries !! 0
ldapAttrs (LDAPEntry {leattrs = attrs}) = attrs
cn ("cn", [str]) = str
commonName ldapEntry = cn $ first $ ldapAttrs ldapEntry

getName uid = do
	users <- lookupUID uid
	let user = first users
	let name = commonName user
	return name

