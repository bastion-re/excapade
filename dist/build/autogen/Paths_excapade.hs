module Paths_excapade (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/bsmt/.cabal/bin"
libdir     = "/Users/bsmt/.cabal/lib/x86_64-osx-ghc-7.10.1/excap_DC84XFdLKIf450Ulc1CfZ8"
datadir    = "/Users/bsmt/.cabal/share/x86_64-osx-ghc-7.10.1/excapade-0.1.0.0"
libexecdir = "/Users/bsmt/.cabal/libexec"
sysconfdir = "/Users/bsmt/.cabal/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "excapade_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "excapade_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "excapade_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "excapade_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "excapade_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
