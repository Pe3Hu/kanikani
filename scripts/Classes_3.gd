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
				#rint("!",num.value.max)
			"move":
				num.value.current = Global.obj.timeflow.num.delta*num.value.max
				
				if obj.object.obj.dot != null:
					obj.object.obj.dot.obj.dancer = null
					obj.object.obj.dot = null
			"preparation":
				update_max(null)
				num.value.current = Global.obj.timeflow.num.delta*num.value.max

	func apply():
		update_value()
		
#		dict.effect.cast = ["stream","splash"]
#		dict.effect.content = ["rotate","move","damage","heal","instigate","buff","debuff"]
		match word.content:
			"rotate":
				var angle = obj.object.num.angle.target-obj.object.num.angle.current
				var step = float(min(num.value.current,abs(angle)))*sign(angle)
				#rint("@", word.content, angle, " ", step)
				obj.object.rotate_by(step)
			"move":
				var d = obj.object.vec.position.distance_to(obj.act.obj.card.obj.pas.obj.dot.vec.position)
				var step = float(min(num.value.current,d))
				#int("@", word.content, " ", d, " ", step)
				obj.object.move_by(step)
			"aim":
				if obj.act.obj.dancer.obj.troupe.word.team == "champion":
					print("#",obj.act.obj.card.obj.pas.obj.dot)
				obj.act.obj.card.obj.pas.aim()
				if obj.act.obj.dancer.obj.troupe.word.team == "champion":
					print("##",obj.act.obj.card.obj.pas.obj.dot)
					print("#####",obj.act.obj.dancer.num.angle.target)
				update_max(obj.act.obj.dancer.num.angle.target)
			"preparation":
				var zone = obj.act.obj.card.obj.exam.obj.zone
				var d = zone.vec.scale.max.x-zone.vec.scale.current.x
				var step = float(min(num.value.current,d))
				zone.rise_scale(step)
			"exam":
				obj.act.obj.card.obj.exam.obj.challenge.check_examinees()
			"rest":
				Global.current.dancer = obj.subject
				Global.obj.easel.next_action()

	func update_max(value_):
		num.value.max = value_
		
		match word.content:
			"rotate":
				var data = {}
				data.old = obj.act.num.end
				obj.act.num.time = obj.dancer.get_time_for_rotate()
				obj.act.num.end = obj.act.num.begin+obj.act.num.time
				data.new = obj.act.num.end
				data.dancer = obj.act.obj.dancer
				obj.act.obj.cord.update_pauses(data)
			"preparation":
				num.value.max = obj.act.obj.card.obj.exam.obj.zone.vec.scale.max.x/obj.act.num.time

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
		vec.bias = input_.position
		num.r = Global.num.ballroom.a/4
		color.current = Color.white
		flag.temp = true
		init_scenes()

	func init_scenes():
		scene.act = Global.scene.act.instance()
		Global.node.Acts.add_child(scene.act)
		scene.act.position = vec.position
		scene.act.set_sprites(self)
		
		if !obj.timeflow.flag.narrow:
			scene.act.switch_narrow()
		
		if obj.effect.word.content == "exam":
			scene.act.effect_reposition()

	func shift(vec_):
		vec.position.x += vec_.x
		vec.bias.x += vec_.x
		
		if vec.position.x <= obj.timeflow.num.begin:
			vec.position.x = obj.timeflow.num.begin
		
		if obj.timeflow.flag.narrow:
			scene.act.position = vec.position
		else:
			scene.act.position = vec.bias

	func die():
		if !flag.temp:
			if obj.effect.word.cast == "splash":
				obj.effect.apply()
			
			match obj.effect.word.content:
				"move":
					obj.dancer.vec.position = obj.card.obj.pas.obj.dot.vec.position
					obj.dancer.set_dot()
				"preparetion":
					obj.card.obj.exam.obj.zone.scene.vec.scale.current = Vector2()
		
		obj.cord.dict.pause[num.end].erase(self)
		
		if scene.act != null:
			scene.act.queue_free()
			scene.act = null
		
		for _i in range(Global.obj.timeflow.arr.timeline.size()-1,-1,-1):
			if Global.obj.timeflow.arr.timeline[_i].act == self:
				Global.obj.timeflow.arr.timeline.pop_at(_i)
		
		obj.cord.reposition()
		
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
		reposition()

	func switch_narrow():
		for pause in dict.pause.keys():
			for act in dict.pause[pause]:
				act.scene.act.switch_narrow()

	func reposition():
		update_bias()
		
		for pause in dict.pause.keys():
			for act in dict.pause[pause]:
				if obj.timeflow.flag.narrow:
					act.scene.act.position = act.vec.position
				else:
					act.scene.act.position = act.vec.bias

	func update_bias():
		var datas = []
		var x = Global.vec.sprite.size.x
		
		for pause in dict.pause.keys():
			for act in dict.pause[pause]:
				var data = {}
				data.act = act
				data.x = act.vec.position.x
				data.bias = 2*x
				data.value = data.x
				
				if data.act.obj.effect.word.content == "exam":
					data.bias += x
				
				datas.append(data)
		
		datas.sort_custom(Classes_0.Sorter, "sort_ascending")
		
		for _i in range(1,datas.size(),1):
			var _j = _i-1
			
			if datas[_i].x-datas[_j].x < datas[_i].bias:
				datas[_i].x = datas[_j].x+datas[_j].bias
			
		for data in datas:
			data.act.vec.bias = Vector2(data.x,data.act.vec.position.y)

	func update_pauses(data_):
		var shift = data_.new-data_.old
		var acts = []
		
		for time in dict.pause.keys():
			for act in dict.pause[time]:
				if act.obj.dacner == data_.dacner && act.num.begin >= data_.old:
					acts.append(act)
					dict.pause[time].erase(act)
					var data = {}
					data.value = act.num.end
					data.act = act
					obj.timeflow.arr.timeline.erase(data)
		
		for act in acts:
			act.num.begin += shift
			act.num.end += shift
			var data = {}
			data.value = act.num.end
			data.act = act
			obj.timeflow.arr.timeline.append(data)
			
			if !dict.pause.keys().has(act.num.end):
				dict.pause[act.num.end] = []
			
			dict.pause[act.num.end].append(act)
		
		update_positions()
		
	func update_positions():
		pass

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
		
		for kye in dict.cord.keys():
			var cord = dict.cord[kye]
			cord.switch_narrow()
			cord.reposition()

	func clean_temp():
		for _i in range(arr.timeline.size()-1,-1,-1):
			var act = arr.timeline[_i].act
			
			if act.flag.temp:
				act.die()

	func fix_temp():
		Global.obj.easel.clean_hand()
		
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

