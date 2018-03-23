# LuaBinaryLib
Library of code for handling binary values from within lua, primarily intended for file i/o.

Contains functionality for saving/loading `byte`, `short`, and `int`, as well as a library that will create floating point values from 32 bit integers (via the binary, of course). Saving/loading floating point isn't built in but could easily be done through the writeInt() function since floats and ints are 32 bits. (You would have to get the NumberToBase function and copy/paste it out of one of the two lua files, then use that on your integer value). To do: Write float -> int
