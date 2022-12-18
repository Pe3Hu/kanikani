extends Node2D


func _draw():
	if Global.obj.keys().has("easel"):
		var offset = Global.vec.easel.offset
		
		for pas in Global.obj.easel.arr.hand:
			var vertexs = []
			
			for vertex in pas.arr.vertex:
				var vec = vertex+offset
				vertexs.append(vec)
				draw_polygon(vertexs, PoolColorArray([pas.color.background]))
				
			pas.node.label.rect_position = offset
			
			offset += Global.vec.pas.offset

func _process(delta):
	update()
