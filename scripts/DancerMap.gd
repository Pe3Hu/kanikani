extends Area2D


func set_sprite(team_,color_):
	var sprite = get_node("Sprite")
	var path = "res://assets/dancers/"
	var name_ = team_+"_arrow.png"
	var texture = ImageTexture.new()
	var image = Image.new()
	image.load(path+name_)
	texture.create_from_image(image)
	sprite.texture = texture
	sprite.modulate = color_

func rotate(angle_):
	rotation_degrees = 180/PI*angle_
