extends Node
class_name WAD
 
var entries: Array[Entry] = []
var textures: Array[MipTex] = []
var id # aka "magic"
@export_file('*.wad') var wad_file_path: String

func _ready():
	if wad_file_path:
		var w = WAD.from_wad_file(wad_file_path)
		entries = w.entries
		textures = w.textures
		id = w.id

static func from_wad_file(path) -> WAD:
	var file = FileAccess.open(path, FileAccess.READ)
	var new_wad = WAD.new()
	new_wad.id = file.get_buffer(4).get_string_from_ascii()
	var num_entries = file.get_32()
	var dir_offset = file.get_32()

	if new_wad.id != 'WAD2':
		return

	file.seek(dir_offset)
	for _i in range(num_entries):
		var orig_cursor = file.get_position()

		# entry data
		var entry := Entry.from_lump(file.get_buffer(32))
		new_wad.entries.append(entry)

		# texture data
		file.seek(entry.offset)
		# var tex = MipTex.new().from_lump(file.get_buffer(40))
		var tex := MipTex.from_file(file, entry)

		new_wad.textures.append(tex)
		file.seek(orig_cursor + 32)

	return new_wad
