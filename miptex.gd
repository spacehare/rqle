extends Resource
class_name MipTex

# width and height should be divisble by 16
var width: int:
	get:
		return mipmaps[0].width
var height: int:
	get:
		return mipmaps[0].height
var texture_name: String: # max 16 characters
	set(val):
		if len(val) <= 16:
			texture_name = val
var mipmap_offsets: Array[int] = []
var mipmaps: Array[MipMap] = [] # max 4, each mipmap is half size of the one before it

static func from_file(file: FileAccess, entry: Entry, pos: int) -> MipTex:
	var mt = MipTex.new()

	mt.texture_name = file.get_buffer(16).get_string_from_ascii()
	var w := file.get_32()
	var h := file.get_32()

	for i in range(4):
		mt.mipmap_offsets.append(file.get_32())

	for i in range(4):
		# this godot-tools version fucking breaks formatting when doing 4 ** i to 4 * * i so pow() for now...
		file.seek(entry.offset + mt.mipmap_offsets[i])
		var mipsize = (w * h) / pow(4, i)
		var mm := MipMap.new()

		mm.data = file.get_buffer(mipsize)
		mm.width = w / pow(2, i)
		mm.height = h / pow(2, i)

		mt.mipmaps.append(mm)

	return mt