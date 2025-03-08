# MAC (Script Engine)

For Linux, two packages containing various files are used to set up scenes, scripts, etc.
The file format for these .pkg files is:
0..4: Four byte LE integer giving file count (FC)
4..4+12\*FC: FC-count of tuples indicating file information - (CRC32 of filename, offset from end of header, length of file)
4+12\*FC...:Files, concatenated with each other according to the header specifiers.

File names vary wildly and do not all appear in an easy fashion inside of the binary. Some examples in limbo_mac_boot.pkg:
-autorun.txt, init.txt, materials_list.txt, atlases.txt (from binary)
-data/texture/atlas/atlas_blur.txt (from atlases.txt)
-derived/mac/data/levels/limbo.scene.d (??? comes out of seemingly nowhere)

Current effort is toward finding all the file names and extracting them accordingly. While all the files can be currently retrieved without names, it is preferred they are retrieved with appropriate context.