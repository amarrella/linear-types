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

writeToFile' :: String -> IO ()
writeToFile' x = 
  Linear.run Prelude.$ Control.do 
    h1 <- Linear.openFile "tmp/test.txt" Linear.WriteMode
    h2 <- Linear.hPutStrLn h1 (Text.pack x)
    () <- Linear.hClose h2
    Control.return (Ur ())


main :: IO ()
main = writeToFile' "Hello, Haskell!"
