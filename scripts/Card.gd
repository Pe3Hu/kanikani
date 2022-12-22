extends Node2D


var obj = {}

func set_spirtes(pas_):
	obj.pas = pas_
	
	for key in Global.arr.card:
		var sprite = get_node(key)
		var path = "res://assets/"
		var name_ = ".png"
		
		match key:
			"Chesspiece":
				path = path+"effects/move/"
				name_ = pas_.word.chesspiece+name_
			"Layer":
				path = path+"layers/square/"
				name_ = str(pas_.num.layer)+name_
			"Skill":
				pass
			"Border":
				path = path+"cards/"
				name_ = pas_.word.border+name_
				print(path,name_)
		
		var texture = ImageTexture.new()
		var image = Image.new()
		image.load(path+name_)
		texture.create_from_image(image)
		sprite.texture = texture

func get_size():
	var size = get_node("TextureButton").rect_size*scale
	return size

func _on_TextureButton_pressed():
	if obj.pas.word.border == "access":
		Global.obj.easel.obj.current.pas = obj.pas
		Global.set_square_layer(obj.pas.num.layer)
		Global.obj.ballroom.get_dots_by_pas()
		Global.obj.ballroom.obj.current.dot = null
