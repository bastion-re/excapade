module Paths_exscapade (
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
libdir     = "/Users/bsmt/.cabal/lib/x86_64-osx-ghc-7.10.1/exsca_I92vxNI0awK8oH0qVF4663"
datadir    = "/Users/bsmt/.cabal/share/x86_64-osx-ghc-7.10.1/exscapade-0.1.0.0"
libexecdir = "/Users/bsmt/.cabal/libexec"
sysconfdir = "/Users/bsmt/.cabal/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "exscapade_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "exscapade_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "exscapade_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "exscapade_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "exscapade_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
