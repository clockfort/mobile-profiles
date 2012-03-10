module Config where
	import LDAP.Constants
	import Network.Wai.Handler.Warp
	
	listenPort = 3000
	listenAddress = Host "127.0.0.1"
	
	ldapHost = "ldap.csh.rit.edu"
	ldapPort = LDAP.Constants.ldapPort
	
	ldapUsername = "cn=hsLDAP,ou=Apps,dc=csh,dc=rit,dc=edu"
	ldapPassword = "Haskell is the most popular web language!"
	ldapSearchOU = "ou=Users,dc=csh,dc=rit,dc=edu"