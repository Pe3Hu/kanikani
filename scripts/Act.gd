extends Node2D


func set_sprites(act_):
	set_dancer(act_.obj.dancer)
	set_effect(act_)

func set_dancer(dancer_):
	var sprite = get_node("Dancer")
	sprite.modulate = dancer_.color.background

func set_effect(act_):
	var sprite = get_node("Effect")
	var path = "res://assets/effects/"
	var name_ = ".png"
	
	match act_.obj.effect.word.content:
		"rotate":
			name_ = act_.obj.effect.word.content+name_
		"move":
			path += act_.obj.effect.word.content+"/"
			name_ = act_.obj.pas.word.chesspiece+name_
	
	var texture = ImageTexture.new()
	var image = Image.new()
	image.load(path+name_)
	texture.create_from_image(image)
	sprite.texture = texture
	
