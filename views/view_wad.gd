extends Control

var p = r'I:\Quake\Dev\wad\rabbit_june.wad'

@onready var wad_container: Container = %WadContainer
var preview: PackedScene = load('res://views/view_wad_texture.tscn')

func _ready():
	var w := WAD.from_wad_file(p)

	for i in w.textures:
		var pv: ViewWadTexture = preview.instantiate()
		wad_container.add_child(pv)
		pv.load_miptex(i)
	
# 	# var rect = TextureRect.new()
# 	# rect.texture = image_texture
# 	# rect.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
# 	# rect.custom_minimum_size = Vector2(64, 64)
# 	# rect.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
# 	# rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
