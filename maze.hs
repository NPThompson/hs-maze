--maze.hs


import System.IO



ix x y = (!! x) . (!! y)

neighbors (x,y) = [(x+1,y),(x-1,y),(x,y+1),(x,y-1)]

firstOf e []     = 0
firstOf e (x:xs) = if e == x then 0 else 1 + firstOf e xs

start m = (firstOf '.' (m !! 0), 0)
end   m = (firstOf '.' (m !! (length m - 1)), length m - 1)

inRect w h (x,y) = (x < w && y < h)
notIn es = \x -> not (x `elem` es)

minlen :: [[a]] -> [a]
minlen [] = []
minlen ls = foldr1 (\s0 s1 -> if length s0 > length s1 then s1 else s0) ls

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

showSoln :: [String] -> [(Int,Int)] -> [String]
showSoln m solns = showRows m 0 where
    showRows [] n        = []
    showRows (r:rs) n    = (showColumns r (0,n)) : showRows rs (n + 1)
    showColumns [] _     = []
    showColumns (c:cs) (x,y) = (if (x,y) `elem` solns then 'o' else c):(showColumns cs (x + 1, y))

main = do
    maze <- hGetContents stdin
    putStrLn $ unlines (showSoln (lines maze) (solve  $ lines maze))