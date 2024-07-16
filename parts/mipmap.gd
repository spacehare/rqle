extends Resource
class_name MipMap

var width: int
var height: int
var data: PackedByteArray

func to_image():
	var bytes = PackedByteArray()
	for index in data:
		var rgb = Palette.QUAKE_RGB[index]
		bytes.append(rgb[0])
		bytes.append(rgb[1])
		bytes.append(rgb[2])
		bytes.append(255 if index != 255 else 0) # TODO: make this only happen on { prefix

	var img = Image.create_from_data(width, height, false, Image.FORMAT_RGBA8, bytes)

	return img

func to_image_texture() -> ImageTexture:
	return ImageTexture.create_from_image(to_image())