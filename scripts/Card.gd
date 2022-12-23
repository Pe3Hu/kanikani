extends Area2D


var obj = {}

func _ready() -> void:
	self.connect("mouse_entered", self, "_on_Card_mouse_entered")

func set_spirtes(data_):
	obj.card = data_
	obj.pas = data_.obj.pas 
	obj.exam = data_.obj.exam 
	
	for key in Global.arr.sprite.card:
		var sprite = get_node(key)
		var path = "res://assets/"
		var name_ = ".png"
		
		match key:
			"Chesspiece":
				path = path+"effects/move/"
				name_ = obj.pas.word.chesspiece+name_
			"Layer":
				path = path+"layers/square/"
				name_ = str(obj.pas.num.layer)+name_
			"Exam":
				var team = obj.card.obj.dancer.obj.troupe.word.team
				path = path+"effects/exam/"+team+"/"
				name_ = obj.exam.word.name+name_
			"Border":
				path = path+"cards/"
				name_ = obj.card.word.border+name_
		
		var texture = ImageTexture.new()
		var image = Image.new()
		image.load(path+name_)
		texture.create_from_image(image)
		sprite.texture = texture

func get_size():
	#var size = get_node("CollisionShape2D").position*2*scale
	var shape = get_node("CollisionShape2D").get_shape()
	var size = shape.extents*2
	print(size)
	return size

func _on_Card_mouse_entered():
	if obj.card.word.border == "access":
		scale = Vector2(Global.num.card.zoom,Global.num.card.zoom)

func _on_Card_mouse_exited():
	if obj.card.word.border == "access":
		scale = Vector2(1,1)

func _on_Card_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		if obj.card.word.border == "access":
			Global.current.pas = obj.pas
			Global.set_square_layer(obj.pas.num.layer)
			Global.obj.ballroom.get_dots_by_pas()
			Global.current.dot = null
