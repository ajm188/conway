import           Control.Monad
import           Data.Matrix

type Cell = Bool

next :: Cell -> [Cell] -> Cell
next True cs
    | neighbors < 2 = False
    | neighbors == 2 || neighbors == 3 = True
    | otherwise = False
    where neighbors = liveCount cs
next False cs
    | liveCount cs == 3 = True
    | otherwise = False

liveCount :: ([Cell] -> Int)
liveCount = length . filter id

step :: Matrix Cell -> Matrix Cell
step world =
    foldl (\w r -> mapRow (\c cell -> next cell (neighborsOf r c)) r w) world [1..rmax]
    where rmax = nrows world
          cmax = ncols world
          allNeighborCoords r c = [ (r + r', c + c') | r' <- [-1..1], c' <- [-1..1] ]
          neighborsOf r c = map (\(x, y) -> getElem x y world) $ filter (okCoord r c) $ allNeighborCoords r c
          okCoord r c (x, y)
            | x == r && y == c = False
            | x < 1 || x > rmax = False
            | y < 1 || y > cmax = False
            | otherwise = True

convert :: (a -> b) -> Matrix a -> Matrix b
convert f m = fromList (nrows m) (ncols m) $ map f $ toList m

drawAndStep world = do
    print $ convert (\x -> if x then '.' else '_') world
    return $ step world

main = foldM (\w _ -> drawAndStep w) initialWorld iterations
    where initialWorld = fromList 9 9 $ cycle [True, True, False, True]
          iterations = [1..]
