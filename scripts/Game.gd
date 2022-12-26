extends Node


func _ready():
	#datas.sort_custom(Classes_0.Sorter, "sort_ascending")
	Global.obj.ballroom = Classes_0.Ballroom.new()
	Global.obj.easel = Classes_2.Easel.new()
	Global.obj.timeflow = Classes_3.Timeflow.new()
	#Global.obj.timeflow.shift_act_sprites()

func _input(event):
	if event is InputEventMouseButton:
		if Global.flag.click:
			if Global.obj.keys().has("ballroom"):
				var mouse = get_viewport().get_mouse_position()
				
				if Global.obj.ballroom.check_borderline(mouse):
					if Global.current.dancer != null:
						Global.current.dancer.set_target_dot(mouse)
				
			Global.flag.click = !Global.flag.click
		else:
			Global.flag.click = !Global.flag.click
	
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_S:
			Global.obj.ballroom.find_nearest_dot(get_viewport().get_mouse_position())
		if event.pressed and event.scancode == KEY_W:
			Global.set_square_layer(null)
		if event.pressed and event.scancode == KEY_Q:
			Global.obj.timeflow.flag.stop = !Global.obj.timeflow.flag.stop
		if event.pressed and event.scancode == KEY_A:
			Global.obj.timeflow.fix_temp()
			Global.obj.timeflow.flag.stop = false
			
		if event.pressed and event.scancode == KEY_1:
			Global.node.Hand.visible = !Global.node.Hand.visible
		if event.pressed and event.scancode == KEY_2:
			Global.obj.timeflow.shift_act_sprites()

func _process(delta):
	if Global.obj.keys().has("timeflow"):
		if !Global.obj.timeflow.flag.stop:
			Global.obj.timeflow.tick(delta)
	#print(delta,"FPS " + String(Engine.get_frames_per_second()))

func _on_Timer_timeout():
	if Global.obj.keys().has("timeflow"):
		if !Global.obj.timeflow.flag.stop:
			Global.node.TimeBar.value += 1
			
			if Global.node.TimeBar.value >= Global.node.TimeBar.max_value:
				Global.node.TimeBar.value -= Global.node.TimeBar.max_value
