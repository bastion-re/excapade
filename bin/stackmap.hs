{-# LANGUAGE QuasiQuotes #-}
module Main where

import Data.Binary
import Data.ByteString.Char8 (unpack)
import Data.ByteString.Lazy.Char8 (toStrict)
import Data.Char
import Data.List
import System.Environment
import System.IO

import Excapade.DeBruijn

alphabet = "abcdef"
window_size = 4
mkpattern = deBruijn alphabet window_size

halp = do
  name <- getProgName
  let usage = "usage:\n\nstackmap <length>\nstackmap lookup <substring>"
  hPutStrLn stderr usage

generate len = do
  let pattern = take len $ mkpattern
  case length pattern < len of
   True -> hPutStrLn stderr "error: could not generate a de bruijn sequence long enough"
   False -> hPutStr stdout pattern

lookup str = do
  let index = deBruijnLookup str mkpattern window_size
  case index of
   Just x -> hPutStrLn stdout (show x)
   Nothing -> hPutStrLn stderr $ "error: found 0 occurances of " ++ str

main = do
  args <- getArgs
  case args of
   ["-h"] -> do
     halp
   ["--help"] -> do
     halp
   [len] -> do
     let length = read len :: Int
     generate length
   ["lookup", substr] -> do
     case (map toLower $ take 2 substr) of
      "0x" -> do
        let str = (dropWhile (== '\x00') . unpack . toStrict . encode) (read substr :: Int)
        Main.lookup str
      otherwise -> Main.lookup substr
   otherwise ->
     halp
