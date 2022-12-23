extends Node2D


func _draw():
	if Global.obj.keys().has("ballroom"):
		for squares in Global.obj.ballroom.dict.square[Global.num.layer.square]:
			for square in squares:
				draw_polygon(square.arr.vertex, PoolColorArray([square.color.background]))
		
		for position in Global.obj.ballroom.dict.position.keys():
			var dot = Global.obj.ballroom.dict.position[position]
			
			if dot.arr.layer.has(Global.num.layer.square):
				draw_circle(dot.vec.position, Global.num.dot.a, dot.color.current)
	
#		for exam in Global.obj.ballroom.arr.exam:
#			for zone in exam.arr.zone:
#				match zone.word.type:
#					"circle":
#						draw_circle(zone.arr.vertex.front(), zone.num.r, zone.color.background)
		
		if Global.current.dot:
			draw_circle_arc(Global.current.dot.vec.position, Global.num.dot.a*1.5, 0, 360, Color.black)
			

func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = []

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color)

func _process(delta):
	update()
