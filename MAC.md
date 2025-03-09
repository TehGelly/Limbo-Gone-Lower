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

## File Formats

Any file that ends with a .d prefix can be assumed to be compressed using zlib (unknown settings, but python's **zlib** library can easily uncompress files using **zlib.decompressobj().decompress(data)**)
Each field is in little endian format unless specified otherwise.
The first field of every file is an Int32 field indicating what type of resource it is:

###  1: TextResource (.txt)

0..4: Identifier (0x1)
4..8: Count (number of strings in file)
COUNT times:
    0..4:     Length of string
	4..4+LEN: String (NOT null-terminated)
	
Text resources appear to have been useful for the Xbox and nothing else, as all other text in the game is rendered ahead of time as texture buffers.

###  7: Animation (.anim)

0..4: Identifier(0x7)
4..8: Bone count
8..12: Frame count
BONE_COUNT times:
	0..4: Bone name length
	4..4+LEN: Bone name as a string
	4+LEN..4+LEN+12: Three floats, indicating start x_pos, y_pos, and z_rot ("I-frame")
	4+LEN+12..4+LEN+15: Three ubytes, indicating precision of following deltas, in byte width (XW,YW,ZW)
	FRAME_COUNT-1 times: ("P-frames")
		0..XW: x_delta (signed int)
		XW..XW+YW: y_delta (signed int)
		XW+YW..XW+YW+ZW: z_delta (signed int)
		
To find the position of a given frame number N, take the N-1th p_frame, scalar multiply it by 0.001, and add it to frame number 0. (not cumulative)
There are two formats of animation files offered by the binary - anims, which are the binary packed format above, and source format, which are human readable strings.
The .anim files provided in this repository are currently not that format, but is similar.

### 13: TextureBuffer (.png)

These are not pngs.

0..4: Identifier(0xd)
4..8: UNKNOWN_A  (int32)
8..12: UNKNOWN_B (int32)
12..13: Length of path name (not exact matches, see limbo_mac_runtime/UNKNOWN)
13..13+LEN: Path name as a string
13+LEN...: TextureBuffer
	0..4: Identifier(0x9)
	4..5: UNKNOWN_C (byte)
	5..6: UNKNOWN_D (byte)
	6..8: RenderBuffer_Width
	8..10: RenderBuffer_Height
	10..12: UNKNOWN_E (ushort)
	12..14: UNKNOWN_F (ushort)
	14..15: UNKNOWN_G (byte) (unidentified OpenGL field)
	15..16: OpenGL_Texture_Max_Level
	16..17: OpenGL_Filter_Flags(??)
	17..18: Internal PixelFormatType (0xa is the only recorded value, which indicates L8A8 "LUMINANCE 8, ALPHA 8" (b&w w/ alpha))
	18...: Image (for L8A8, two-byte pixels, of size RenderBuffer_Width\*RenderBuffer_Height\*4//3) (the extra quarter at the end has currently unknown purpose.)
	
Many details above are irrelevant to get at least a working PNG rendered, and so are currently left unknown. The images rendered are imperfect, but sufficient to understand what the image is.

### 21: Branch (.branch)

### XX: Effects (.fx)

Breaking the mold, .fx files are pure text without the above header that are some form of OpenGL C file skullduggerey with currently unknown motives.
The inclusion of these files is unclear, as it seems like they do not get loaded in standard gameplay. The paths for these files, then, are also unknown, and currently dumped in the limbo_mac_boot/UNKNOWN directory.