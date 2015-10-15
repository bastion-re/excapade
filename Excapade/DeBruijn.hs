module Excapade.DeBruijn (deBruijn, deBruijnLookup) where

import Control.Monad
import Control.Monad.ST
import Data.List (nub, sort)
import Data.STRef
import qualified Data.Vector as Vec
import qualified Data.Vector.Mutable as VecM

deBruijnLookup :: [Char] -> [Char] -> Int -> Maybe Int
deBruijnLookup needle haystack sublen = _lookup needle haystack sublen 0 where
  _lookup needle haystack sublen n
    | length haystack < sublen = Nothing
    | otherwise = case (take sublen haystack) == needle of
                       True -> Just n
                       False -> _lookup needle (tail haystack) sublen (n + 1)

-- Thanks https://github.com/vpeurala/DeBruijn
deBruijn :: [Char] -> Int -> [Char]
deBruijn alphabet sublen = calculateDeBruijn (nub $ sort alphabet) sublen

-- surely there's a better way
gen1 :: (Ord a) =>
        STRef s (VecM.MVector s a)
        -> VecM.MVector s a
        -> [a]
        -> Int
        -> Int
        -> Int
        -> ST s ()
gen1 seq workingArray alphabet sublen t period =
  if t > sublen
  then
    when (sublen `mod` period == 0) $ do
      seq' <- readSTRef seq
      let appendable = VecM.drop (sublen - period + 1) workingArray
      let firstWritableIndex = VecM.length seq'
      let appendableLength = VecM.length appendable
      grown <- VecM.grow seq' appendableLength
      forM_ [0..(appendableLength - 1)] (\i -> do
        item <- VecM.read appendable i
        VecM.write grown (firstWritableIndex + i) item)
      writeSTRef seq grown
  else do
    valueAtTMinusPeriod <- VecM.read workingArray (t - period)
    VecM.write workingArray t valueAtTMinusPeriod
    gen1 seq workingArray alphabet sublen (t + 1) period
    forM_ (successors alphabet valueAtTMinusPeriod) (\j -> do
      VecM.write workingArray t j
      gen1 seq workingArray alphabet sublen (t + 1) t)

successors :: (Ord a) => [a] -> a -> [a]
successors alphabet letter = dropWhile (<= letter) alphabet

calculateDeBruijn :: (Ord a) => [a] -> Int -> [a]
calculateDeBruijn [] _ = []
calculateDeBruijn alphabet sublen = runST $ do
  seqWorking <- Vec.thaw $ Vec.fromList []
  seqRef <- newSTRef seqWorking
  workingArray <- VecM.replicate (sublen + 1) (minimum alphabet)
  gen1 seqRef workingArray alphabet sublen 1 1
  seqFinal <- readSTRef seqRef
  seqFrozen <- Vec.freeze seqFinal
  let seqWithoutCycling = Vec.toList seqFrozen
  let seqWithCycling = seqWithoutCycling ++ take (sublen - 1) seqWithoutCycling
  return seqWithCycling
