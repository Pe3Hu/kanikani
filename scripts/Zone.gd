extends Area2D


func set_sprite(zone_):
	var sprite = get_node("Sprite")
	var path =  "res://assets/effects/zone/filled_"
	var name_ = zone_.word.type+".png"
	var texture = ImageTexture.new()
	var image = Image.new()
	image.load(path+name_)
	texture.create_from_image(image)
	sprite.texture = texture
	sprite.modulate = zone_.color.background
	var shape = get_node("CollisionShape2D")
	
	match zone_.word.type:
		"circle":
			shape.shape = CircleShape2D.new()
			shape.shape.radius = Global.vec.zone.size.x
		"rectangle":
			shape.shape = RectangleShape2D.new()
			shape.shape.extents = Global.vec.zone.size
	
