module Excapade.Interact where

import Data.Maybe

import System.Process
import GHC.IO.Handle

-- | Opens a process and returns functions for writing to stdin and reading from stdout.
process :: FilePath -> [String] -> IO ((String -> IO ()), (IO String), ProcessHandle)
process path args = do
  (stdin, stdout, stderr, procHandle) <- createProcess (proc path args)
  let write = hPutStr (fromJust stdin)
  let recv = hGetLine (fromJust stdout)
  return (write, recv, procHandle)
