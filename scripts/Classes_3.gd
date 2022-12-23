extends Node


class Effect:
	var num = {}
	var word = {}
	var obj = {}

	func _init(input_):
		num.value = {}
		num.value.max = input_.value
		num.value.current = input_.value
		word.cast = input_.cast
		word.content = input_.content
		obj.subject = input_.subject
		obj.object = input_.object

	func update_value():
		match word.content:
			"rotate":
				num.value.current = Global.obj.timeflow.num.delta*num.value.max
			"move":
				num.value.current = Global.obj.timeflow.num.delta*num.value.max
				
				if obj.object.obj.dot != null:
					obj.object.obj.dot.obj.dancer = null
					obj.object.obj.dot = null

	func apply():
		update_value()
#		dict.effect.cast = ["stream","splash"]
#		dict.effect.content = ["rotate","move","damage","heal","instigate","buff","debuff"]
		match word.content:
			"rotate":
				var angle = obj.object.num.angle.target-obj.object.num.angle.current
				var step = float(min(num.value.current,abs(angle)))*sign(angle)
				obj.object.rotate_by(step)
			"move":
				var d = obj.object.vec.position.distance_to(obj.act.obj.pas.obj.dot.vec.position)
				var step = float(min(num.value.current,d))
				obj.object.move_by(step)
			"exam":
				obj.subject.check_examinees()
			"rest":
				Global.current.dancer = obj.subject
				Global.obj.easel.next_action()

class Act:
	var num = {}
	var vec = {}
	var obj = {}
	var color = {}
	var scene = {}
	var flag = {}

	func _init(input_):
		obj.cord = input_.cord
		obj.dancer = input_.dancer
		obj.effect = input_.effect
		obj.effect.obj.act = self
		obj.effect.num.time = input_.time
		obj.timeflow = input_.timeflow
		obj.card = input_.card
		num.begin = input_.begin
		num.end = input_.end
		num.time = input_.time
		vec.position = input_.position
		num.r = Global.num.ballroom.a/4
		color.current = Color.white
		flag.temp = true
		init_scenes()

	func init_scenes():
		scene.act = Global.scene.act.instance()
		Global.node.Acts.add_child(scene.act)
		scene.act.position = vec.position
		scene.act.set_sprites(self)

	func shift(vec_):
		vec.position.x += vec_.x
		
		if vec.position.x <= obj.timeflow.num.begin:
			vec.position.x = obj.timeflow.num.begin
		
		scene.act.position = vec.position

	func die():
		if !flag.temp:
			if obj.effect.word.cast == "splash":
				obj.effect.apply()
		
			if obj.effect.word.content == "move":
				obj.dancer.vec.position = obj.pas.obj.dot.vec.position
				obj.dancer.set_dot()
		
		obj.cord.dict.pause[num.end].erase(self)
		
		if scene.act != null:
			scene.act.queue_free()
			scene.act = null
		
		for _i in Global.obj.timeflow.arr.timeline.size():
			if Global.obj.timeflow.arr.timeline[_i].act == self:
				Global.obj.timeflow.arr.timeline.pop_at(_i)
				break
		
		if Global.obj.timeflow.arr.timeline.size() == 0:
			Global.obj.timeflow.flag.stop = true

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
		num.weight = Global.num.dent.weight
		color.line = Color.black
		dict.pause = {}
		
		set_vertexs()

	func set_vertexs():
		for shift in Global.arr.square:
			var vertex = Vector2(arr.vertex.front().x,arr.vertex.front().y)
			vertex += shift*Global.vec.cord.size
			
			if vertex != arr.vertex.front():
				arr.vertex.append(vertex)
		
		num.y = (arr.vertex.front().y+arr.vertex.back().y)/2

	func add_act(data_):
		if !dict.pause.keys().has(data_.end):
			dict.pause[data_.end] = []
		
		var end = data_.end-obj.timeflow.num.time.current
		var x = obj.timeflow.num.begin+end*Global.num.dent.x
		data_.position = Vector2(x,num.y)
		data_.cord = self
		data_.timeflow = obj.timeflow
		var act = Classes_3.Act.new(data_)
		dict.pause[data_.end].append(act)
		var data = {}
		data.value = data_.end
		data.act = act
		obj.timeflow.arr.timeline.append(data)

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
			
			if arr.vertex[_i].x <= Global.obj.timeflow.num.begin:
				arr.vertex[_i].x = Global.obj.timeflow.num.end-(Global.obj.timeflow.num.begin-arr.vertex[_i].x)

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
		arr.timeline = []
		flag.narrow = false
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
		num.begin = vertex.x
		
		for _i in Global.num.dent.n:
			var dent = Classes_3.Dent.new(input)
			arr.dent.append(dent)
			
			for _j in input.vertexs.size():
				input.vertexs[_j].x += x
		
		num.end = input.vertexs.front().x

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
				timeline.act.shift(shift)
			
			for timeline in arr.timeline:
				if timeline.act.obj.effect.word.cast == "stream" && timeline.act.num.begin <= num.time.current:
					timeline.act.obj.effect.apply()
			
			if time == num.time.current:
				for timeline in arr.timeline:
					if timeline.value == time:
						timeline.act.die()
		else:
			Global.flag.timeline = false

	func get_closest_act():
		arr.timeline.sort_custom(Classes_0.Sorter, "sort_ascending")
		var act = arr.timeline.front()
		return act

	func add_pause(data_):
		data_.begin = num.time.current+data_.delay
		data_.end = num.time.current+data_.time+data_.delay
		dict.cord[data_.cord].add_act(data_)

	func shift_act_sprites():
		flag.narrow = !flag.narrow
		
		for timeline in arr.timeline:
			if flag.narrow:
				timeline.act.switch_narrow()

	func clean_temp():
		for timeline in arr.timeline:
			if timeline.act.flag.temp:
				timeline.act.die()

	func fix_temp():
		for timeline in arr.timeline:
			if timeline.act.flag.temp:
				timeline.act.flag.temp = false

	func launch_mobs():
		for team in Global.obj.ballroom.dict.troupe.keys():
			for dancer in Global.obj.ballroom.dict.troupe[team].arr.dancer:
				var input = {}
				input.value = null
				input.cast = "splash"
				input.content = "rest"
				input.subject = dancer
				input.object = dancer
				
				var data = {}
				data.dancer = dancer
				data.card = null
				data.effect = Classes_3.Effect.new(input)
				data.time = dancer.obj.feature.dict["rest"].current
				data.delay = 0
				data.cord = "standart"
				add_pause(data)
		
		fix_temp()

	func mob_choise():
		var team = "mob"
		var dancer = Global.obj.ballroom.dict.troupe[team].arr.dancer.front()
		dancer.get_exam()
