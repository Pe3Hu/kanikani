extends Node2D


func _draw():
	if Global.obj.keys().has("ballroom"):
		for squares in Global.obj.ballroom.dict.square[Global.num.layer.square]:
			for square in squares:
				draw_polygon(square.arr.vertex, PoolColorArray([square.color.background]))
				draw_circle(square.vec.center, Global.dict.a[Global.num.layer.square], Color.blue)
#		for key in Global.obj.ballroom.dict.position.keys():
#				draw_circle(key, 10, Color.black)
#
#		for _i in Global.obj.ballroom.dict.dot[Global.num.layer.square].size():
#			var _j = (_i+1)%Global.obj.ballroom.dict.dot[Global.num.layer.square].size()
#			draw_line(Global.obj.ballroom.dict.dot[Global.num.layer.square][_i], Global.obj.ballroom.dict.dot[Global.num.layer.square][_j], Color.black, Global.num.ballroom.width)
		
		for dots in Global.obj.ballroom.dict.dot[Global.num.layer.square]:
			for dot in dots:
				draw_circle(dot.vec.position, Global.dict.a[Global.num.layer.square], dot.color.background)
		
		for exam in Global.obj.ballroom.arr.exam:
			for zone in exam.arr.zone:
				match zone.word.type:
					"circle":
						draw_circle(zone.arr.vertex.front(), zone.num.r, zone.color.background)
		
		for team in Global.obj.ballroom.dict.troupe.keys():
			var troupe = Global.obj.ballroom.dict.troupe[team]
			
			for dancer in troupe.arr.dancer:
				draw_circle(dancer.vec.position, dancer.num.a, dancer.color.background)
		
		for position in Global.obj.ballroom.dict.position.keys():
			var dot = Global.obj.ballroom.dict.position[position]
			
			if dot == Global.obj.ballroom.obj.current.dot:
				for windrose in dot.dict.neighbor[Global.num.layer.square].keys():
					var neighbor = dot.dict.neighbor[Global.num.layer.square][windrose]
					draw_circle(neighbor.vec.position, Global.dict.a[Global.num.layer.square], Color.white)

func _process(delta):
	update()
