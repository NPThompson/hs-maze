--maze.hs


import System.IO


--to find (x,y) index the outer list by y and then index this by x
ix x y = (!! x) . (!! y)

--the immediate neighbors of a point are the points located one unit
--above, below, and to either side
neighbors (x,y) = [(x+1,y),(x-1,y),(x,y+1),(x,y-1)]

--finds the index of the first occurence of e in a list
firstOf e []     = 0
firstOf e (x:xs) = if e == x then 0 else 1 + firstOf e xs

--by convention, the start to the maze is the first open space on the first row,
--the end is the first open space on the bottom row
start m = (firstOf '.' (m !! 0), 0)
end   m = (firstOf '.' (m !! (length m - 1)), length m - 1)

--a test to determine if a point is within certain bounds
inRect w h (x,y) = (x < w && y < h)
notIn es = \x -> not (x `elem` es)

--finds the shortest list
minlen :: [[a]] -> [a]
minlen [] = []
minlen ls = foldr1 (\s0 s1 -> if length s0 > length s1 then s1 else s0) ls

{-
This implementation uses what I like to call, 'the brute force approach'.
The idea is simple: at a point, test to see if it is the end point.
If not, recursively search every adjacent open space,
so long as that space isn't out of bounds and hasn't been visited already.
Filter the results of this recursive search for the shortest path which leads to the exit.
If it is the end point, or if no more paths can be found, we're done.
-}
solve :: [[Char]] -> [(Int,Int)]
solve m = let e = end m
              s             = start m
              width         = length (m !! 0)
              height        = length m
              soln p        = p /= [] && last p == e
              findSoln ls   = minlen (filter soln ls)
              valid h (x,y) = x >= 0 && y >= 0 && x < width && y < height && (not ((x,y) `elem` h)) && (ix x y m) /= '#'
              solve' h p
                  | p     ==  e = [p]
                  | ps    == [] = []
                  | otherwise   = p:ps
                  where ps = (findSoln (map (solve' (p:h)) $ filter (valid h) (neighbors p)))
              in
                  solve' [] s

--this function returns the original maze, replacing the points in the solution path by the character 'o'
showSoln :: [String] -> [(Int,Int)] -> [String]
showSoln m solns = showRows m 0 where
    showRows [] n        = []
    showRows (r:rs) n    = (showColumns r (0,n)) : showRows rs (n + 1)
    showColumns [] _     = []
    showColumns (c:cs) (x,y) = (if (x,y) `elem` solns then 'o' else c):(showColumns cs (x + 1, y))

--main will read a maze, find the solution, and then print the solution
main = do
    maze <- hGetContents stdin
    putStrLn $ unlines (showSoln (lines maze) (solve  $ lines maze))