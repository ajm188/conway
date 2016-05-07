# Conway

[Conway's Game of Life](https://en.wikipedia.org/wiki/Conway's_Game_of_Life)
implementation in Haskell.

## Running the Code

You'll need a package from [cabal](https://www.haskell.org/cabal/), so you
should start by installing cabal if you haven't already. Then, just `cabal
install matrix`.

After that, you have two options:

1. Obtain a binary with `ghc Conway.hs`. Then run it with `./Conway`.
1. Load the module into ghci (`ghci Conway.hs`). Then invoke the `main`
   function.

## Walking Through the Code

All of the Game of Life logic is contained within the `next` and `step`
functions.

`next` is responsible for returning the next state of a cell, given its
neighbors. This has all the "if a cell is alive and has x living neighbors..."
stuff.

`step` is responsible for tessalating the `next` function across the matrix. It
also has to do some shenanigans with the various functions defined in the
`Data.Matrix` module. There's a whole bunch of definitions in the `where`
clause, which make it much harder to follow and make the single-line `foldl`
invocation seem much more magical. I probably shouldn't have done that.

The rest of the functions are there solely for support.

- `neighborCount` should be fairly straightforward.
- `convert` converts a matrix from one type to another, given a conversion
  function.
    - It does this lazily (not in the "strict vs lazy evaluation" sense, but in
      the "[first virtue of a
      programmer](http://c2.com/cgi/wiki?LazinessImpatienceHubris)" sense), by
      first converting the matrix into a flat list, mapping the function over
      the list, and then creating a matrix from the resulting list with the
      same dimensions as the original matrix. Likely horribly inefficient
      (fingers crossed for compiler optimization), but it works and is easy to
      understand.
- `drawAndStep` and `main` deal with the evils of IO.
    - Note that `main` has two definitions in its `where` clause, namely
      `initialWorld` and `iterations`. These alone determine the results of the
      simulation, so feel free to tweak them to your liking.
