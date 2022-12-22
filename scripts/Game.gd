extends Node


func _ready():
#	datas.sort_custom(Sorter, "sort_ascending")
	Global.obj.ballroom = Classes_0.Ballroom.new()
	Global.obj.easel = Classes_2.Easel.new()
	Global.obj.timeflow = Classes_3.Timeflow.new()

func _input(event):
	if event is InputEventMouseButton:
		if Global.flag.click:
			if Global.obj.keys().has("ballroom"):
				if Global.obj.keys().has("easel"):
					if Global.obj.easel.obj.current.pas != null:
						if Global.obj.ballroom.obj.current.dancer != null:
							var position = get_viewport().get_mouse_position()
							Global.obj.ballroom.obj.current.dancer.set_target_dot(position)
				
			Global.flag.click = !Global.flag.click
		else:
			Global.flag.click = !Global.flag.click
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_D:
			var team = "champion"
			var step = Vector2(5,0)
			Global.obj.ballroom.shift_troupe(team,step)
		if event.pressed and event.scancode == KEY_A:
			var team = "champion"
			var step = Vector2(-5,0)
			Global.obj.ballroom.shift_troupe(team,step)
		if event.pressed and event.scancode == KEY_S:
			Global.obj.ballroom.find_nearest_dot(get_viewport().get_mouse_position())
		if event.pressed and event.scancode == KEY_W:
			Global.next_square_layer()
		if event.pressed and event.scancode == KEY_Q:
			Global.flag.timeflow = !Global.flag.timeflow
		if event.pressed and event.scancode == KEY_E:
			 Global.obj.easel.use_card()
			
		if event.pressed and event.scancode == KEY_1:
			Global.node.Hand.visible = !Global.node.Hand.visible

func _process(delta):
	
	if Global.flag.timeflow:
		Global.obj.timeflow.tick(delta)
		
		if Global.obj.keys().has("ballroom"):
			for exam in Global.obj.ballroom.arr.exam:
				exam.obj.challenge.tick()
	#print(delta,"FPS " + String(Engine.get_frames_per_second()))

func _on_Timer_timeout():
	if Global.flag.timeflow:
		Global.node.TimeBar.value += 1
		
		if Global.node.TimeBar.value >= Global.node.TimeBar.max_value:
			Global.node.TimeBar.value -= Global.node.TimeBar.max_value
			
