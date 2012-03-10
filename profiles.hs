-- For Scotty
{-# LANGUAGE OverloadedStrings #-}
import Web.Scotty

-- For Me
import Control.Monad.Trans
import Data.Text.Lazy

-- Project-Internal
import Config
import HTMLGen
import Backend

import Network.Wai.Handler.Warp

settings = defaultSettings { settingsPort = (fromInteger listenPort), settingsHost = Host listenAddress }

-- | Run a scotty application using the warp server, but with settings rather than port.
-- | I might push this to xich's repo, it'd likely be useful for other people.
scottySettings :: Settings -> ScottyM () -> IO ()
scottySettings settings scotty = putStrLn "Setting phasers to kill... (ctrl-c to quit)" >> (runSettings settings =<< scottyApp scotty)

main = scottySettings settings $ do
	get "/" $ do
		html $ pack $ indexPage
		
	get "/search/:search" $ do
		search <- param "search"
		people <- liftIO $ sortedPeople $ unpack search
		html $ pack $ listPage people
		
	get "/uid/:uid" $ do
		uid <- param "uid"
		info <- liftIO $ getInfo $ unpack uid
		html $ pack $ contactPage info
		
	-- It's worth noting that these are protected from unwanted
	-- directory traversal attacks (a la handle="../../../../foo")
	-- by the library above me, so it needn't be handled here.
	get "/iui/t/default/:handle" $ do --TODO: Add theming support for android
		handle <- param "handle"
		file $ "iui/t/default/" ++ (unpack handle)
	get "/iui/:handle" $ do
		handle <- param "handle"
		file $ "iui/" ++ (unpack handle)
