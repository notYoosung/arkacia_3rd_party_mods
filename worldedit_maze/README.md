**Changes in Version 2.0:**

* patched crash
* added luacheck
* added github actions to run luacheck
* made game agnostic
* added worldedit command that takes three optional arguements
* renamed mod

yes, this is slightly overkill to fix a mod

**Changes in Version 1.1:**

* Nodes from third-party mods can now be used as maze materials (thanks MT_Dad)

I started this to implement a maze generation algorithm that I use when I draw mazes on paper. The result is not exactly this algorithm since computers are apparently too dumb for it, but it's worth to be shared anyway.

### Things you need to know about the mazes:

- Start at one corner and find your way to the opposite corner

- There is exactly one way

- Big mazes will drive you crazy

- Mazes do not have a floor or a top cover by default, add this using WorldEdit if you want.


### Generating a maze:

- Use WorldEdit to define 2 opposing corners. The maze is spawned between them and all walls are as high as the height difference between the two positions.

- Execute this chatcommand:

    /maze [any random number as seed]


Note: the maze always has odd dimensions, if the x/z distance between pos1 and pos2 is even, the dimension is just rounded down.


### Changing maze materials:

- On top of init.lua, you find some content id assignments. Change the node names in there.

- Alternatively, you can just replace the generated nodes with the WorldEdit //replace command.
