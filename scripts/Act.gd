extends Node2D


func set_sprites(act_):
	for key in Global.arr.sprite.act:
		var sprite = get_node(key)
		var path = ""
		var name_ = ".png"
		
		match key:
			"Dancer":
				path = "res://assets/dancers/"
				name_ = act_.obj.dancer.obj.troupe.word.team+"_icon"+name_
				sprite.modulate = act_.obj.dancer.color.background
			"Narrow":
				path = "res://assets/timeflow/"
				name_ = key.to_lower()+name_
				sprite.modulate = act_.obj.dancer.color.background
			"Effect":
				path = "res://assets/effects/"
				
				match act_.obj.effect.word.content:
					"rotate":
						name_ = act_.obj.effect.word.content+name_
					"move":
						path += act_.obj.effect.word.content+"/"
						name_ = act_.obj.card.obj.pas.word.chesspiece+name_
		
		var texture = ImageTexture.new()
		var image = Image.new()
		image.load(path+name_)
		texture.create_from_image(image)
		sprite.texture = texture

func switch_narrow():
	for key in Global.arr.sprite.act:
		var sprite = get_node(key)
		sprite.visible = !sprite.visible
