extends Resource
class_name Entry

var offset: int
var disk_size: int
var mem_size: int
var entry_type: String
var compression
var entry_name: String

static func from_lump(lump: PackedByteArray) -> Entry:
	var e = Entry.new()
	e.offset = lump.decode_u32(0)
	e.disk_size = lump.decode_u32(4)
	e.mem_size = lump.decode_u32(8)
	e.entry_type = char(lump.decode_s8(12))
	e.compression = lump.decode_s8(14)
	e.entry_name = lump.slice(16).get_string_from_ascii()

	# "entry_type" can be 4 possible chars:
	# @ = palette
	# B = status bar
	# D = miptex
	# E = console picture
	# we want it to be D

	return e