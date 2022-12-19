extends Node2D


func _draw():
	if Global.obj.keys().has("ballroom"):
		for squares in Global.obj.ballroom.dict.square[Global.num.layer.square]:
			for square in squares:
				draw_polygon(square.arr.vertex, PoolColorArray([square.color.background]))
		
		for position in Global.obj.ballroom.dict.position.keys():
			var dot = Global.obj.ballroom.dict.position[position]
			
			if dot.arr.layer.has(Global.num.layer.square):
				draw_circle(dot.vec.position, Global.dict.a[Global.num.layer.square], dot.color.current)

		for exam in Global.obj.ballroom.arr.exam:
			for zone in exam.arr.zone:
				match zone.word.type:
					"circle":
						draw_circle(zone.arr.vertex.front(), zone.num.r, zone.color.background)

func _process(delta):
	update()
