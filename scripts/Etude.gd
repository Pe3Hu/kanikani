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
		
		sprite.texture = load(path+name_)

func set_act(act_):
		var sprite = get_node("Act")
		var path = "res://assets/effects/"
		var name_ = ".png"
		
		match act_.word.content:
			"rotate":
				name_ = act_.obj.effect.word.content+name_
			"move":
				path += act_.obj.effect.word.content+"/"
				name_ = act_.obj.card.obj.pas.word.chesspiece+name_
			"preparation":
				var team = act_.obj.dancer.obj.troupe.word.team
				path += act_.obj.effect.word.content+"/"+team+"/"
				name_ = act_.obj.card.obj.exam.word.name+name_
		match act_.word.phase:
			"hitch":
				name_ = act_.obj.effect.word.content+name_
			"rest":
				name_ = act_.obj.effect.word.content+name_
		
		var texture = ImageTexture.new()
		var image = Image.new()
		image.load(path+name_)
		texture.create_from_image(image)
		sprite.texture = texture

func switch_narrow():
	for key in Global.arr.sprite.act:
		var sprite = get_node(key)
		sprite.visible = !sprite.visible

func effect_reposition():
		var sprite = get_node("Effect")
		sprite.position.x = Global.vec.sprite.size.x/2
	
