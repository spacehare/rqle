@tool
extends Control
class_name ViewWadTexture

@onready var rect: TextureRect = %TextureRect
@onready var label: Label = %Label

func load_miptex(tex: MipTex):
	rect.texture = tex.mipmaps[0].to_image_texture()
	label.text = tex.texture_name