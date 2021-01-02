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


main :: IO ()
main = writeToFile' "Hello, Haskell!"
