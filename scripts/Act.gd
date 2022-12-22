extends Node2D


func set_sprites(act_):
	for key in Global.arr.sprite.act:
		var sprite = get_node(key)
		
		match key:
			"Dancer":
				sprite.modulate = act_.obj.dancer.color.background
			"Narrow":
				sprite.modulate = act_.obj.dancer.color.background
			"Effect":
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

func switch_narrow():
	for key in Global.arr.sprite.act:
		var sprite = get_node(key)
		sprite.visible = !sprite.visible
