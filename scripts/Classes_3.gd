extends Node


class Act:
	var num = {}
	var word = {}
	var vec = {}
	var arr = {}
	var obj = {}
	var color = {}
	var flag = {}

	func _init(input_):
		word.cord = input_.cord
		word.phase = input_.phase
		word.content = input_.content
		obj.dancer = input_.dancer
		obj.etude = obj.dancer.obj.etude
		num.step = {}
		num.step.current = 0
		set_step_max()
		num.time = {}
		num.time.current = 0
		num.time.max = 0
		num.time.begin = 0
		num.time.end = 0
		#init_scenes()
		set_stages()

	func set_step_max():
		if obj.dancer.obj.feature.dict.keys().has(word.content):
			num.step.max = obj.dancer.obj.feature.dict[word.content].current
		else:
			if obj.dancer.obj.feature.dict.keys().has(word.phase):
				num.step.max = obj.dancer.obj.feature.dict[word.phase].current

	func set_stages():
		num.stage = {}
		num.stage.current = 0
		arr.stage = []
		arr.stage.append_array(Global.dict.effect.stage[word.content])
		num.stage.max = arr.stage.size()

	func calc_time():
		match word.content:
			"rotate":
				num.time.max = obj.dancer.get_time_for_rotate()
			"move":
				num.time.max = obj.dancer.get_time_for_move()
			"preparation":
				num.time.max = obj.etude.obj.exam.obj.challenge.num.preparation.max
			"wait":
				num.time.max = num.step.max

	func perform_stage():
		update_value()
		
		match arr.stage[num.stage.current]:
			"prelude":
				prelude()
			"rise":
				rise()
			"finale":
				finale()

	func prelude():
		match word.content:
			"wait":
				match word.phase:
					"hitch":
						num.time.begin = Global.timeflow.num.time.current
			"find dot":
				match word.phase:
					"target processing":
						obj.dancer.set_pas_target_dot()
			"move":
				obj.dancer.obj.dot.obj.dancer = null
				obj.dancer.obj.dot = null
				obj.dancer.obj.etude.obj.pas.obj.dot.obj.dancer = obj.dancer
			"preparation":
				pass
		
		next_stage()

	func rise():
		match word.content:
			"rotate":
				var angle = obj.dancer.num.angle.target-obj.dancer.num.angle.current
				var step = float(min(num.step.current,abs(angle)))*sign(angle)
				obj.dancer.rotate_by(step)
			"move":
				var d = obj.dancer.vec.position.distance_to(obj.act.obj.card.obj.pas.obj.dot.vec.position)
				var step = float(min(num.step.current,d))
				obj.dancer.move_by(step)
			"preparation":
				var zone = obj.etude.obj.exam.obj.zone
				var d = zone.vec.scale.max.x-zone.vec.scale.current.x
				var step = float(min(num.step.current,d))
				zone.rise_scale(step)
			"wait":
				pass
		
		check_time()

	func finale():
		match word.content:
			"move":
				obj.dancer.obj.dot = obj.dancer.obj.etude.obj.pas.obj.dot
			"preparation":
				obj.exam.obj.challenge.check_examinees()
		
		next_stage()

	func next_stage():
		num.stage.current += 1 
		
		if num.stage.current >= num.stage.max:
			end()

	func check_time():
		num.time.current += Global.obj.timeflow.num.delta
		
		if num.time.current >= num.time.max:
			next_stage()

	func update_max(value_):
		num.step.max = value_
		
		match word.content:
			"preparation":
				num.step.max = obj.etude.obj.exam.obj.zone.vec.scale.max.x/obj.act.num.time

	func update_value():
		num.step.current = Global.obj.timeflow.num.delta*num.step.max

	func end():
		obj.etude.arr.act.pop_front()

class Cord:
	var word = {}
	var num = {}
	var arr = {}
	var dict = {}
	var obj = {}
	var color = {}

	func _init(input_):
		word.name = input_.cord
		obj.timeflow = input_.timeflow
		color.background = Global.color.cord[word.name]
		arr.vertex = input_.vertexs
		arr.etude = []
		obj.temp = null
		num.weight = Global.num.dent.weight
		color.line = Color.black
		set_vertexs()

	func set_vertexs():
		for shift in Global.arr.square:
			var vertex = Vector2(arr.vertex.front().x,arr.vertex.front().y)
			vertex += shift*Global.vec.cord.size
			
			if vertex != arr.vertex.front():
				arr.vertex.append(vertex)
		
		num.y = (arr.vertex.front().y+arr.vertex.back().y)/2

	func fix_temp():
		arr.etude.append(obj.temp)
		var data = {}
		data.value = obj.timeflow.num.time.current + obj.temp.arr.act.front().num.time.max
		data.etude = obj.temp 
		obj.timeflow.arr.timeline.append(data)
		print(obj.temp.obj.cord)
		obj.temp = null

	func perform():
		for etude in arr.etude:
			etude.perform()

	func clean_etude(etude_):
		arr.etude.erase(etude_)
		
		for timeline in obj.timeflow.arr.timeline:
			if timeline.etude == etude_:
				obj.timeflow.arr.timeline.erase(timeline)

class Dent:
	var num = {}
	var arr = {}
	var color = {}

	func _init(input_):
		arr.vertex = []
		arr.vertex.append(Vector2(input_.vertexs.front().x,input_.vertexs.front().y))
		arr.vertex.append(Vector2(input_.vertexs.back().x,input_.vertexs.back().y))
		num.weight = Global.num.dent.weight
		color.line = Color.black

	func shift(vec_):
		for _i in arr.vertex.size():
			arr.vertex[_i].x += vec_.x
			
			if arr.vertex[_i].x <= Global.obj.timeflow.num.x.left:
				arr.vertex[_i].x = Global.obj.timeflow.num.x.right-(Global.obj.timeflow.num.x.left-arr.vertex[_i].x)

class Timeflow:
	var num = {}
	var dict = {}
	var arr = {}
	var obj = {}
	var flag = {}

	func _init():
		num.time = {}
		num.time.current = 0
		num.shift = Global.num.dent.x
		num.x = {}
		arr.timeline = []
		flag.narrow = true
		flag.stop = false
		init_cords()
		init_dents()
		launch_mobs()

	func init_cords():
		dict.cord = {}
		var vertex = Global.vec.timeflow.offset
		
		for _i in Global.arr.cord.size():
			vertex.y -= Global.vec.cord.size.y 
			var input = {}
			input.timeflow = self
			input.cord = Global.arr.cord[_i]
			input.vertexs = [vertex]
			dict.cord[input.cord] = Classes_3.Cord.new(input)

	func init_dents():
		arr.dent = []
		var x = Global.num.space.l/Global.num.dent.n
		var input = {}
		input.vertexs = []
		var vertex = Global.vec.timeflow.offset
		input.vertexs.append(vertex)
		vertex.y -= Global.vec.cord.size.y*Global.arr.cord.size()
		input.vertexs.append(vertex)
		num.x.left = vertex.x
		
		for _i in Global.num.dent.n:
			var dent = Classes_3.Dent.new(input)
			arr.dent.append(dent)
			
			for _j in input.vertexs.size():
				input.vertexs[_j].x += x
		
		num.x.right = input.vertexs.front().x

	func tick(delta_):
		num.delta = delta_
		var timeskip = delta_
		
		if arr.timeline.size() > 0 && !flag.stop:
			var time = get_closest_act().value
			
			if time < delta_+num.time.current:
				timeskip = time-num.time.current
			
			num.time.current += timeskip
			var shift = Vector2(-num.shift*timeskip,0)
			
			for dent in arr.dent:
				dent.shift(shift)
			
			for timeline in arr.timeline:
				timeline.etude.shift(shift)
				timeline.etude.perform()
		else:
			Global.flag.timeline = false

	func get_closest_act():
		arr.timeline.sort_custom(Classes_0.Sorter, "sort_ascending")
		var etude = arr.timeline.front()
		return etude

	func shift_act_sprites():
		flag.narrow = !flag.narrow
		
		for cord in dict.cord.keys():
			cord.switch_narrow()
			cord.reposition()

	func launch_mobs():
		for team in Global.obj.ballroom.dict.troupe.keys():
			for dancer in Global.obj.ballroom.dict.troupe[team].arr.dancer:
				var cord = "standart"
				var data = {}
				data.dancer = dancer
				data.cord = dict.cord[cord]
				data.pas = null
				data.exam = null
				dancer.obj.etude.set_parts(data)
				
				data.phase = "rest"
				data.content = "wait"
				dancer.obj.etude.add_act(data)
				add_temp(dancer)
		
		fix_temp()

	func add_temp(dancer_):
		var cord = dancer_.obj.etude.obj.cord
		cord.obj.temp = dancer_.obj.etude
		#dancer_.obj.etude.obj.cord = cord
		dancer_.obj.etude.calc_total_time()

	func fix_temp():
		for key in dict.cord.keys():
			if dict.cord[key].obj.temp != null:
				dict.cord[key].fix_temp()

	func clean_temp():
		for key in dict.cord.keys():
			if dict.cord[key].obj.temp != null:
				dict.cord[key].obj.temp.reset()
				dict.cord[key].obj.temp = null
