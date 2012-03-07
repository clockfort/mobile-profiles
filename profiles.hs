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

main = scotty (fromInteger listenPort) $ do
	get "/" $ do
		people <- liftIO $ sortedPeople
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
