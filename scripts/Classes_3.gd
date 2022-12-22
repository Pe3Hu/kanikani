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
		
		match word.content:
			"rotate":
				num.value *= Global.obj.timeflow.num.delta
			"move":
				num.value *= Global.obj.timeflow.num.delta
				obj.object.obj.dot.obj.dancer = null
				obj.object.obj.dot = null
				pass

	func apply():
#		dict.effect.cast = ["stream","splash"]
#		dict.effect.content = ["rotate","move","damage","heal","instigate","buff","debuff"]
		match word.content:
			"rotate":
				var angle = obj.object.num.angle.target-obj.object.num.angle.current
				var step = float(min(num.value,abs(angle)))*sign(angle)
				obj.object.rotate_by(step)
			"move":
				var d = obj.object.vec.position.distance_to(obj.act.obj.pas.obj.dot.vec.position)
				var step = float(min(num.value,d))
				obj.object.move_by(step)

class Act:
	var num = {}
	var vec = {}
	var obj = {}
	var color = {}
	var scene = {}

	func _init(input_):
		obj.cord = input_.cord
		obj.dancer = input_.dancer
		obj.effect = input_.effect
		obj.effect.obj.act = self
		obj.effect.num.time = input_.time
		obj.timeflow = Global.obj.timeflow
		obj.pas = input_.pas
		num.begin = input_.begin
		num.end = input_.end
		num.time = input_.time
		vec.position = input_.position
		num.r = Global.num.ballroom.a/4
		color.current = Color.white
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
		if obj.effect.word.cast == "splash":
			obj.effect.apply()
		
		if obj.effect.word.content == "move":
			obj.dancer.vec.position = obj.pas.obj.dot.vec.position
			obj.dancer.set_dot()
		#print(obj.dancer.vec.eye)
		var pause = obj.cord.dict.pause[num.end]
		pause.erase(self)
		#Global.node.Acts.queue_free(scene.act)
		scene.act.queue_free()

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
		data_.position = Vector2(x,num.y)#
		data_.cord = self
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

	func _init():
		num.time = {}
		num.time.current = 0
		num.shift = Global.num.dent.x
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

	func tick(delta_):
		num.delta = delta_
		var timeskip = delta_
		
		if arr.timeline.size() > 0:
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
						arr.timeline.erase(timeline)
		else:
			Global.flag.timeline = false

	func get_closest_act():
		arr.timeline.sort_custom(Classes_0.Sorter, "sort_ascending")
		var act = arr.timeline.front()
		return act

	func add_pause(data_):
		#print("new pause ",data_.time)
		data_.begin = num.time.current+data_.delay
		data_.end = num.time.current+data_.time+data_.delay
		dict.cord[data_.cord].add_act(data_)
