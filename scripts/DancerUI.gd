extends Node2D



func set_sprite(team_,color_):
	var sprite = get_node("Sprite")
	var path = "res://assets/dancers/"
	var name_ = team_+"_icon.png"
	var texture = ImageTexture.new()
	var image = Image.new()
	image.load(path+name_)
	texture.create_from_image(image)
	sprite.texture = texture
	sprite.modulate = color_

func set_healt(dancer):
	var label = get_node("LabelHealth")
	label.text = str(dancer.obj.feature.dict["health"].current)
	var bar = get_node("BarHealth")
	bar.value = float(dancer.obj.feature.dict["health"].current)/dancer.obj.feature.dict["health"].max*bar.max_value
