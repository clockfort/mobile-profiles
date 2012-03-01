import LDAP
import LDAP.Constants
import Control.Monad.Trans

lookupUID uid = 
	do	
		cshLDAP <- ldapInit "ldap.csh.rit.edu" LDAP.Constants.ldapPort
		ldapSimpleBind cshLDAP "cn=hsLDAP,ou=Apps,dc=csh,dc=rit,dc=edu" ""
		let users = ldapSearch cshLDAP (Just "ou=Users,dc=csh,dc=rit,dc=edu") LdapScopeSubtree (Just ("uid=" ++ uid))  (LDAPAttrList ["cn"]) False
		users



first ldapEntries = ldapEntries !! 0
ldapAttrs (LDAPEntry {leattrs = attrs}) = attrs
cn ("cn", [str]) = str
commonName ldapEntry = cn $ ldapAttrs ldapEntry !! 0

getName uid = do
	users <- lookupUID uid
	let user = users !! 0
	let name = commonName user
	return name
