{-# LANGUAGE LinearTypes #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE QualifiedDo #-}

module Main where

import qualified System.IO.Resource as Linear
import qualified Control.Functor.Linear as Control
import qualified Data.Text as Text
import Prelude.Linear
import qualified Prelude
import qualified System.IO
import Control.Monad (void)

id' :: a %1-> a
id' x = x

sum' :: Num a => a %1-> a %1-> a
sum' x y = x + y

reverse' :: [a] %1-> [a]
reverse' [] = []
reverse' (x:xs) = reverse' xs ++ [x]
-- reverse' (x:xs) = xs ++ reverse' xs ++ [x] fails to compile as xs is used twice


writeToFile' :: String -> IO ()
writeToFile' x = 
  Linear.run Prelude.$ Control.do 
    h1 <- Linear.openFile "tmp/test.txt" Linear.WriteMode
    h2 <- Linear.hPutStrLn h1 (Text.pack x)
    () <- Linear.hClose h2 -- this needs to exist because h2 needs to be consumed _exactly_ once
    -- () <- Linear.hClose h1 would fail to compile as h1 is already used once
    Control.return (Ur ())


---
-- Adapted from https://www.tweag.io/blog/2017-03-13-linear-types/ 
data S a -- Send capability
data R a -- Receive capability

newCaps :: (R a %1-> S a %1-> Linear.RIO ()) %1-> Linear.RIO ()
newCaps consume = undefined consume

send :: S a %1-> a %1-> Linear.RIO ()
send sendCapability msg = undefined sendCapability msg

receive :: R a %1-> (a %1-> Linear.RIO ()) %1-> Linear.RIO ()
receive receiveCapability f = 
  undefined receiveCapability f

type P = (Int, Int, Int %1-> Linear.RIO ())

server :: P %1-> Linear.RIO ()
server (n, p, k) = k (n + p)

client :: (P %1-> Linear.RIO ()) %1-> Linear.RIO ()
client sendToSrvr = newCaps $ \r s -> Control.do
  sendToSrvr (42, 57, send s)
  receive r (\n -> undefined n )

main :: IO ()
main = writeToFile' "Hello, Haskell!"
