extends Node2D


func _draw():
	if Global.obj.keys().has("timeflow"):
		for key in Global.obj.timeflow.dict.cord.keys():
			var cord = Global.obj.timeflow.dict.cord[key]
			draw_polygon(cord.arr.vertex, PoolColorArray([cord.color.background]))
			#vec.timeflow.offset

func _process(delta):
	update()
