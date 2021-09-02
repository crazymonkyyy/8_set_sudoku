##s set sudoku

rules:

	every column and row must contain the digits 1-8, every 2 by 2 box must be colored and contain the set of number corresponding to the color.

| color | numbers | name
|---|---|---
| red | 1,2,3,4 | low
|yellow| 5,6,7,8 | high
|green| 1,3,5,7 | odd
|blue| 2,4,6,8 |even

## super dupper prealpha

1. generator in ineffent, incorrect and may outright fail
2. messy
3. may crash
4. uses zenity
5. doesnt mantain if a digit was set by user of by the computer at all