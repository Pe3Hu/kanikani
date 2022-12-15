extends Node2D


func _draw():
	if Global.obj.keys().has("ballroom"):
		for squares in Global.obj.ballroom.dict.square[Global.num.layer.square]:
			for square in squares:
				draw_polygon(square.arr.vertex, PoolColorArray([square.color.background]))
				draw_circle(square.vec.center, square.arr.dot.front().num.a, Color.blue)
#
#		for _i in Global.obj.ballroom.dict.dot[Global.num.layer.square].size():
#			var _j = (_i+1)%Global.obj.ballroom.dict.dot[Global.num.layer.square].size()
#			draw_line(Global.obj.ballroom.dict.dot[Global.num.layer.square][_i], Global.obj.ballroom.dict.dot[Global.num.layer.square][_j], Color.black, Global.num.ballroom.width)
		
		for dots in Global.obj.ballroom.dict.dot[Global.num.layer.square]:
			for dot in dots:
				draw_circle(dot.vec.position, dot.num.a, dot.color.background)
		
		for pas in Global.obj.ballroom.arr.pas:
			for zone in pas.arr.zone:
				match zone.word.type:
					"circle":
						draw_circle(zone.arr.vertex.front(), zone.num.r, zone.color.background)
		
		for team in Global.obj.ballroom.dict.troupe.keys():
			var troupe = Global.obj.ballroom.dict.troupe[team]
			
			for dancer in troupe.arr.dancer:
				draw_circle(dancer.vec.position, dancer.num.a, dancer.color.background)
#		for cells in Global.obj.ballroom.arr.cell:
#			for cell in cells:
#				draw_polygon(cell.arr.point, PoolColorArray([cell.color.background]))
		pass

func _process(delta):
	update()
