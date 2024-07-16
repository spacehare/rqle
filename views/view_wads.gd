extends Control

@export var wads: Array[WAD]
@onready var filter_regex: Button = %ButtonRegex
@onready var sort_group: Button = %ButtonGroup
@onready var filters: Array[Button]:
	get:
		return [filter_regex]
@onready var search: LineEdit = %Search
@onready var wad_container: Container = %WadContainer
var preview: PackedScene = load('res://views/view_wad_texture.tscn')
var selected: ViewWadTexture
var textures: Array[MipTex]:
	get:
		var all: Array[MipTex] = []
		for wad in wads:
			all += wad.textures
		return all
var blocks:
	get:
		return wad_container.get_children()

func _ready():
	for filter in filters:
		filter.pressed.connect(func(): search_and_filter(search.text))

	search.text_changed.connect(search_and_filter)

	for wad in wads:
		for tex in wad.textures:
			var texture_block: ViewWadTexture = preview.instantiate()
			wad_container.add_child(texture_block)
			texture_block.load_miptex(tex)
			texture_block.btn.pressed.connect(select.bind(texture_block))

func select(block: ViewWadTexture):
	if selected:
		selected.btn.button_pressed = false
	User.current_texture = block.texture
	selected = block

func search_and_filter(text: String):
	var a: String = text.to_lower()
	var pattern: RegEx

	if filter_regex.button_pressed:
		pattern = RegEx.create_from_string(a)

	for block in blocks:
		var b: String = block.texture.texture_name.to_lower()

		if filter_regex.button_pressed:
			var re_match := pattern.search(b)

			block.visible = re_match != null
		else:
			var split := text.split(' ')
			for group in split:
				a = group

				block.visible = not (a != '' and a not in b)
