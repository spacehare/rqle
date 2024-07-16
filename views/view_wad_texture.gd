@tool
extends Control
class_name ViewWadTexture

@onready var rect: TextureRect = %TextureRect
@onready var label: Label = %Label
@onready var btn: Button = %Button
var texture

func load_miptex(tex: MipTex):
	texture = tex
	rect.texture = texture.mipmaps[0].to_image_texture()
	label.text = texture.texture_name
