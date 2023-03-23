-- ListEx.hs
-- Copyright (C) 2012 Liu Xinyu (liuxinyu95@gmail.com)
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.

module ListEx where

import Data.List
import Test.QuickCheck -- for verification purpose only

atR :: [a] -> Int -> a
atR xs i = get xs (drop i xs) where
  get (x:_) [_] = x
  get (_:xs) (_:ys) = get xs ys

-- lastAt with zip
lastAt k xs = (fst . last) $ zip xs  (drop k xs)

insertAt :: [a] -> Int -> a -> [a]
insertAt xs 0 y = y:xs
insertAt [] i y = [y]
insertAt (x:xs) i y = x : insertAt xs (i-1) y

permutation xs n r=  if length xs  <=  n - r
        then [[]]
        else [x:ys | x  <-  xs, ys  <-  permutation (delete x xs) n r]

-- Given a list of n elements, pick r from it to for permutation.
perm xs r | r == 0 || length xs < r = [[]]
          | otherwise = [ x:ys | x <-xs, ys <- perm (delete x xs) (r-1)]

-- Given a list of n elements, pick r from it to form combination.
comb _  0 = []
comb xs 1 = [[x] | x <- xs]
comb xs@(x:xs') r | length xs < r = []
                  | otherwise = [x:ys | ys <- comb xs' (r-1)] ++ comb xs' r

-- speakInt n = map speak (reverse $ zip ds ["", "thousand", "million", "billion"]) where
--   ds = reverse (digits n)
--   words = ["", "one", "two", "three", "four"]
--   speak (n, unit) | n < 20

digits = dec [] where
  dec ds n | n == 0 = ds
           | otherwise = dec ((n `mod` 1000) : ds) (n `div` 1000)

safeTake n [] = []
safeTake n (x:xs) | n <= 0 = []
                  | otherwise = x : safeTake (n - 1) xs

safeDrop n [] = []
safeDrop n (x:xs) | n <= 0 = x:xs
                  | otherwise = drop (n - 1) xs

sublist from cnt = take cnt . drop (from - 1)

slice from to = drop (from - 1) . take to

suffixes [] = [[]]
suffixes xs@(_:ys) =  xs : suffixes ys

concats [] = []
concats ([]:xss) = concat xss
concats ((x:xs):xss) = x : concat (xs:xss)

prop_rindex :: [Int] -> Bool
prop_rindex xs = xs == (map (atR xs) $ reverse [0..length xs -1])

prop_insertAt :: [Int] -> Int -> Int -> Property
prop_insertAt xs i x = (0 <= i) ==> (insertAt xs i x) == (let (as, bs) = splitAt i xs in as ++ x:bs)

prop_concat :: [[Int]] -> Bool
prop_concat xss = concat xss == concats xss

prop_tails :: [Int] -> Bool
prop_tails xs = suffixes xs == tails xs
