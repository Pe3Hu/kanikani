extends Node2D


func _draw():
	if Global.obj.keys().has("easel"):
		pass

func _process(delta):
	update()
