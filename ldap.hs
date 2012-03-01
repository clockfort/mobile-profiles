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
import Config

main = scotty (fromInteger listenPort) $ do
	get "/" $
		file "list.html"

	get "/uid/:uid" $ do
		uid <- param "uid"
		name <- liftIO $ getName $ unpack uid
		json name

	-- It's worth noting that these are protected from unwanted
	-- directory traversal attacks (a la handle="../../../../foo")
	-- by the library above me, so it needn't be handled here.
	get "/iui/t/default/:handle" $ do --TODO: Add theming support for android
		handle <- param "handle"
		file $ "iui/t/default/" ++ (unpack handle)
	get "/iui/:handle" $ do
		handle <- param "handle"
		file $ "iui/" ++ (unpack handle)
	get "/css/:handle" $ do
		handle <- param "handle"
		file $ "css/" ++ (unpack handle)
	get "/htmltest" $ do
		html $ "<!DOCTYPE html><html><head><title>foo</title></head><body><h1>HTML Test</h1></body></html>"
		
		
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
cn ("cn", [str]) = str
commonName ldapEntry = cn $ first $ ldapAttrs ldapEntry

getName uid = do
	users <- lookupUID uid
	let user = first users
	let name = commonName user
	return name

