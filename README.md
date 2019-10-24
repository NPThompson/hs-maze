hsmaze

A haskell program for solving mazes. I wrote it to better learn Haskell. In terms of efficiency, it's not. It does work, however. A typical way to use it is like so:

```bash
> ghc maze.hs

> cat maze1
##########.#######
#................#
#.##############.#
#......#.........#
######...#########
#......#.........#
#.##############.#
#.#..............#
#.################

> ./maze < maze1
##########o#######
#oooooooooo......#
#o##############.#
#oooooo#.........#
######o..#########
#oooooo#.........#
#o##############.#
#o#..............#
#o################

```