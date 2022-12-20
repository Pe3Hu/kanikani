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
	var obj = {}

	func _init(input_):
		obj.dacner = input_.dacner
		obj.effect = input_.effect
		num.time = input_.time
		num.pause = input_.pause
		print(num)

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
		dict.pause = {}
		
		set_vertexs()

	func set_vertexs():
		for shift in Global.arr.square:
			var vertex = Vector2(arr.vertex.front().x,arr.vertex.front().y)
			vertex += shift*Global.vec.cord.size
			
			if vertex != arr.vertex.front():
				arr.vertex.append(vertex)
			

	func add_act(data_):
		if !dict.pause.keys().has(data_.pause):
			dict.pause[data_.pause] = []
		
		var act = Classes_3.Act.new(data_)
		dict.pause[data_.pause].append(act)

class Timeflow:
	var num = {}
	var dict = {}
	var obj = {}

	func _init():
		num.value = {}
		num.value.current = 0
		dict.cord = {}
		
		var vertex = Global.vec.timeflow.offset
		
		
		for _i in Global.arr.cord.size():
			vertex.y -= Global.vec.cord.size.y 
			var input = {}
			input.timeflow = self
			input.cord = Global.arr.cord[_i]
			input.vertexs = [vertex]
			dict.cord[input.cord] = Classes_3.Cord.new(input)

	func add_pause(data_):
		data_.pause = num.value.current+data_.time
		dict.cord[data_.cord].add_act(data_)
