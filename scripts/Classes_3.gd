extends Node


class Effect:
	var num = {}
	var word = {}
	var obj = {}

	func _init(input_):
		num.value = input_.value
		word.cast = input_.cast
		word.content = input_.content
		obj.subject = input_.subject
		obj.object = input_.object

	func apply():
#		dict.effect.cast = ["stream","splash"]
#		dict.effect.content = ["rotate","move","damage","heal","instigate","buff","debuff"]
		match obj.content:
			"rotate":
				var angle = obj.object.num.angle.target-obj.object.num.angle.current
				var step = min(angle,obj.object.obj.feature["rotate"].current)*sign(angle)
				obj.object.rotate_by(step)

class Act:
	var num = {}
	var vec = {}
	var obj = {}
	var color = {}

	func _init(input_):
		obj.cord = input_.cord
		obj.dacner = input_.dacner
		obj.effect = input_.effect
		obj.timeflow = Global.obj.timeflow
		num.time = input_.time
		num.pause = input_.pause
		vec.position = input_.position
		num.r = Global.num.ballroom.a/4
		color.current = Color.white

	func shift(vec_):
		vec.position.x += vec_.x
		
		if vec.position.x <= obj.timeflow.num.begin:
			vec.position.x = obj.timeflow.num.begin

	func die():
		if obj.effect.word.cast == "splash":
			obj.effect.apply()
		
		var pause = obj.cord.dict.pause[num.pause]
		pause.erase(self)

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
		if !dict.pause.keys().has(data_.pause):
			dict.pause[data_.pause] = []
		
		var time = data_.time
		var x = time*Global.num.dent.x
		data_.position = Vector2(obj.timeflow.num.begin+x,num.y)
		data_.cord = self
		var act = Classes_3.Act.new(data_)
		dict.pause[data_.pause].append(act)
		var data = {}
		data.value = data_.pause
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

	func _init():
		num.time = {}
		num.time.current = 0
		num.tick = Global.node.Timer.wait_time#*Global.node.TimeBar.max_value
		num.shift = Global.num.dent.x*num.tick
		print(num.shift)
		arr.timeline = []
		init_cords()
		init_dents()

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

	func tick(repeats_):
		var timeskip = num.tick*repeats_
		if arr.timeline.size() > 0:
			var time = get_closest_act().value
			
			if time < timeskip + num.time.current:
				timeskip = time-num.time.current
			
			num.time.current += timeskip
			var shift = Vector2(-num.shift*timeskip/num.tick,0)
			print(num.time.current)
			
			for dent in arr.dent:
				dent.shift(shift)
			
			for timeline in arr.timeline:
				timeline.act.shift(shift)
				
			if time == num.time.current:
				for timeline in arr.timeline:
					if timeline.value == time:
						timeline.act.die()
						arr.timeline.erase(timeline)
		else:
			Global.flag.timeline = false

	func get_closest_act():
		arr.timeline.sort_custom(Classes_0.Sorter, "sort_ascending")
		var act = arr.timeline.front()
		return act

	func add_pause(data_):
		print(data_.time)
		data_.pause = num.time.current+data_.time
		dict.cord[data_.cord].add_act(data_)
