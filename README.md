# Unorthodox Sudoku solver

I've experimented with implementing it in an almost pure-functional way, generating a new board for every combination. I've realized it was going to be slow, but I didn't expect it to be that slow.

It solves the following Sudoku in about half a second on my machine:

```
6, 0, 8, 3, 4, 2, 9, 0, 0,
3, 0, 9, 1, 0, 0, 7, 0, 0,
4, 5, 1, 0, 6, 0, 8, 0, 3,
5, 0, 6, 4, 7, 3, 2, 0, 0,
0, 3, 7, 0, 2, 0, 4, 1, 0,
9, 0, 2, 8, 5, 1, 6, 0, 0,
7, 6, 0, 0, 0, 0, 0, 0, 8,
0, 9, 4, 5, 0, 8, 1, 7, 6,
0, 0, 3, 6, 9, 7, 5, 4, 0
```
And anything harder than that is just too slow to wait for a result.

There may be a way to make it faster, but I don't see it at the moment, pull requests are welcome.
