# Mobile Profiles
A mobile-friendly webpage LDAP contacts viewer.

## Installation Instructions
Rename "example_Config.hs" to "Config.hs" and edit as necessary for your 
environment.

Install the dependencies:

* Latest version of the Haskell Platform
* Latest version of Cabal
* Latest version of LLVM 
 * Recommended, but unnecessary if you choose to compile to a non-LLVM target
* `cabal install LDAP scotty`
* Update the repository and submodules with `make update`

Run the application with either `runghc profiles` or use the included 
makefile to run as a binary (`make && ./profiles`)


Depending on how you want to set things up, you may want to use a Real 
Webserver (Apache, nginx, etc) for users to connect to, and then proxy them 
using application-specific rules to this application. Example configurations 
for this sort of application are widely available online, and vary wildly 
based on choice of web serving software.

