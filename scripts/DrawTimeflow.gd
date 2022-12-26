extends Node2D


func _draw():
	if Global.obj.keys().has("timeflow"):
		for key in Global.obj.timeflow.dict.cord.keys():
			var cord = Global.obj.timeflow.dict.cord[key]
			draw_polygon(cord.arr.vertex, PoolColorArray([cord.color.background]))
			draw_line(cord.arr.vertex[0],cord.arr.vertex[1],cord.color.line,cord.num.weight)
			draw_line(cord.arr.vertex[1],cord.arr.vertex[2],cord.color.line,cord.num.weight)
			draw_line(cord.arr.vertex[3],cord.arr.vertex[0],cord.color.line,cord.num.weight)
			
			if key == "slow":
				draw_line(cord.arr.vertex[2],cord.arr.vertex[3],cord.color.line,cord.num.weight)
		
		#for dent in Global.obj.timeflow.arr.dent:
		#	draw_line(dent.arr.vertex.front(),dent.arr.vertex.back(),dent.color.line,dent.num.weight)

func _process(delta_):
	update()
