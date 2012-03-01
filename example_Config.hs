module Config where
	import LDAP.Constants

	ldapHost = "ldap.csh.rit.edu"
	ldapPort = LDAP.Constants.ldapPort
	
	
	ldapUsername = "cn=hsLDAP,ou=Apps,dc=csh,dc=rit,dc=edu"
	ldapPassword = "Haskell is the most popular web language!"
	ldapSearchOU = "ou=Users,dc=csh,dc=rit,dc=edu"