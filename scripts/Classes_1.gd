extends Node


class Dot:
	var word = {}
	var num = {}
	var vec = {}
	var arr = {}
	var obj = {}
	var dict = {}
	var color = {}

	func _init(input_):
		num.index = Global.num.primary_key.dot
		Global.num.primary_key.dot += 1
		num.l = input_.l
		arr.n = input_.ns
		arr.layer = []
		arr.a = [Global.num.dot.a/arr.n.front()]
		vec.grid = input_.grid
		vec.position = input_.position
		obj.ballroom = input_.ballroom
		obj.ballroom.dict.position[vec.position] = self
		obj.dancer = null
		color.background = Color.yellow
		dict.neighbor = {}
		
		for n in Global.arr.n:
			dict.neighbor[n] = {}

	func update_color():
		if obj.ballroom.arr.end.has(self):
			color.current = Color.white
		else:
			color.background = Color.yellow
			
			for n in arr.n:
				if n < 0:
					color.background = Color.blue
					
			color.current = color.background

	func add_neighbor(layer_, windrose_, dot_):
		dict.neighbor[layer_][windrose_] = dot_
		dot_.dict.neighbor[layer_][Global.dict.reflected_windrose[windrose_]] = self

	func set_dancer(dancer_):
		obj.dancer = dancer_
		dancer_.obj.dot = self

class Square:
	var vec = {}
	var arr = {}
	var obj = {}
	var color = {}

	func _init(input_):
		vec.grid = input_.grid
		arr.n = input_.ns
		vec.center = Vector2()
		obj.ballroom = input_.ballroom
		arr.dot = input_.dots
		arr.vertex = []
		color.background = Color.gray
		
		for dot in arr.dot:
			arr.vertex.append(dot.vec.position)
			vec.center += dot.vec.position
		
		vec.center /= arr.vertex.size()
		
		var input = {}
		input.grid = vec.grid
		input.l = arr.dot.front().num.l
		input.position = vec.center
		
		if !obj.ballroom.dict.position.keys().has(input.position):
			input.ballroom = obj.ballroom
			input.ns = arr.n
			var dot = Classes_1.Dot.new(input)
			obj.ballroom.dict.dot[arr.n.front()][arr.dot.front().vec.grid.y].append(dot)
		else:
			obj.ballroom.dict.dot[arr.n.front()][arr.dot.front().vec.grid.y].append(obj.ballroom.dict.position[input.position])
			obj.ballroom.dict.position[input.position].arr.n.append(arr.n.front())

class Zone:
	var num = {}
	var word = {}
	var arr = {}
	var obj = {}
	var color = {}

	func _init(input_):
		num.r = input_.r
		word.type = input_.type
		word.target = input_.target
		arr.vertex = []
		obj.exam = input_.exam
		color.background = Color.black
		
		set_vertexs()

	func set_vertexs():
		match word.type:
			"circle":
				match word.target:
					"first":
						var position = obj.exam.arr.examinee.front().vec.position
						arr.vertex.append(position)

	func check_examine(examine_, type_):
		var inside = null
		
		match word.type:
			"circle":
				var d = arr.vertex.front().distance_to(examine_.vec.position)
				inside = d <= num.r
		
		match type_:
			"inside":
				return !inside
			"outside":
				return inside

class Penalty:
	var num = {}
	var word = {}
	var arr = {}
	var obj = {}

	func _init(input_):
		num.value = input_.value
		word.type = input_.type
		word.effect = input_.effect
		obj.exam = input_.exam
		arr.dancer = []

	func punishment():
		for dancer in arr.dancer:
			match word.effect:
				"instantaneous":
					match word.type:
						"percent":
							var damage = float(dancer.num.hp.max*num.value)/100
							dancer.get_damage(damage)
		
		arr.dancer = []

class Challenge:
	var num = {}
	var word = {}
	var obj = {}

	func _init(input_):
		num.time = {}
		num.time.max = input_.delay
		num.time.current = 0
		word.type = input_.type
		obj.exam = input_.exam

	func tick():
		num.time.current += 1
		
		if num.time.current >= num.time.max:
			num.time.current = 0
			check_examinees()
			obj.exam.obj.ballroom.arr.exam.erase(obj.exam)

	func check_examinees():
		for examinee in obj.exam.arr.examinee:
			for zone in obj.exam.arr.zone:
				if zone.check_examine(examinee,word.type):
					if !obj.exam.obj.penalty.arr.dancer.has(examinee):
						obj.exam.obj.penalty.arr.dancer.append(examinee)
		
		if obj.exam.obj.penalty.arr.dancer.size() > 0:
			obj.exam.obj.penalty.punishment()

class Exam:
	var word = {}
	var arr = {}
	var obj = {}

	func _init(input_):
		word.name = input_.name
		obj.examiner = input_.examiner
		obj.ballroom = obj.examiner.obj.troupe.obj.ballroom
		set_examinees()
		set_challenge()
		set_zones()
		set_penalty()

	func set_examinees():
		var dancers = obj.ballroom.dict.troupe[Global.dict.opponent[obj.examiner.obj.troupe.word.team]].arr.dancer
		arr.examinee = []
		
		match word.name:
			"classic exam 0":
				arr.examinee.append_array(dancers)

	func set_challenge():
		var input = {}
		input.exam = self
		
		match word.name:
			"classic exam 0":
				input.delay = 1
				input.type = "outside"
		
		obj.challenge = Classes_1.Challenge.new(input)

	func set_zones():
		arr.zone = []
		
		var input = {}
		input.exam = self
		
		match word.name:
			"classic exam 0":
				input.type = "circle"
				input.target = "first"
				input.r = Global.dict.r[input.type][0]
		
		var zone = Classes_1.Zone.new(input)
		arr.zone.append(zone)

	func set_penalty():
		var input = {}
		input.exam = self
		
		match word.name:
			"classic exam 0":
				input.effect = "instantaneous"
				input.type = "percent"
				input.value = 100
		
		obj.penalty = Classes_1.Penalty.new(input)

	func end():
		obj.ballroom.arr.exam.erase(self)

class Feature:
	var obj = {}
	var dict = {}
	
	func _init(input_):
		obj.dancer = input_.dancer
		
		for name in Global.dict.feature.base[obj.dancer.obj.troupe.word.team].keys():
			dict[name] = {}
			dict[name].max = Global.dict.feature.base[obj.dancer.obj.troupe.word.team][name]
			dict[name].current = dict[name].max

class Dancer:
	var num = {}
	var vec = {}
	var obj = {}
	var color = {}
	var scene = {}

	func _init(input_):
		num.a = Global.num.dancer.a
		obj.troupe = input_.troupe
		obj.ballroom = obj.troupe.obj.ballroom
		scene.dancer = Global.scene.dancer.instance()
		Global.node.Dancers.add_child(scene.dancer)
		set_position(Vector2(Global.vec.ballroom.offset.x,Global.vec.ballroom.offset.y))
		set_color()
		vec.eye = Vector2(1,0)
		num.angle = {}
		num.angle.current = 0
		num.angle.target = 0
		init_feature()

	func init_feature():
		var input = {}
		input.dancer = self
		obj.feature = Classes_1.Feature.new(input)

	func set_color():
		match obj.troupe.word.team:
			"mob":
				color.background = Color.red
			"champion":
				color.background = Color.green
		
		scene.dancer.set_color(color.background)

	func set_position(position_):
		vec.position = position_
		scene.dancer.position = vec.position

	func shift(step_):
		set_position(obj.troupe.obj.ballroom.limit_step(vec.position,step_))

	func look_at_dot(dot_):
		var vector = dot_.vec.position-vec.position
		num.angle.target = vec.eye.angle_to(vector)
		rotate_by(num.angle.target)

	func update_eye():
		vec.eye = Vector2(1,0).rotated(num.angle.current)
		
		if vec.eye.x != 0:
			vec.eye.x = vec.eye.x/abs(vec.eye.x)
		if vec.eye.y != 0:
			vec.eye.y = vec.eye.y/abs(vec.eye.y)

	func get_angle_by_target(dot_):
		var vector = dot_.vec.position-vec.position
		num.angle.target = vec.eye.angle_to(vector)

	func rotate_by(angle_):
		num.angle.current += angle_
		scene.dancer.rotate(num.angle.current)
		update_eye()

	func get_time_for_rotate():
		var time = float(abs(num.angle.current-num.angle.target))/obj.feature.dict["rotate"].current
		return time

	func find_enemy():
		var enemy = obj.ballroom.dict.troupe[Global.dict.opponent[obj.troupe.word.team]].arr.dancer.front()
		return enemy

	func set_dot():
		for position in obj.ballroom.dict.position.keys():
			if position == vec.position:
				obj.ballroom.dict.position[position].set_dancer(self)
				return

	func set_target_dot(position_):
		obj.ballroom.find_nearest_dot(position_)
		
		if obj.ballroom.obj.current.dot != null:
			if obj.ballroom.arr.end.has(obj.ballroom.obj.current.dot):
				Global.obj.easel.obj.current.pas.obj.dot = obj.ballroom.obj.current.dot
			else:
				obj.ballroom.obj.current.dot = null

	func get_damage(damage_):
		num.hp.current -= damage_
		print(num.hp.current)
		
		if num.hp.current <= 0:
			die()

	func die():
		obj.troupe.arr.dancer.erase(self)
		
		for exam in obj.troupe.obj.ballroom.arr.exam:
			exam.arr.examinee.erase(self)
			
		scene.dancer.queue_free()
		#Global.node.Dancers

class Troupe:
	var word = {}
	var arr = {}
	var obj = {}

	func _init(input_):
		word.team = input_.team
		obj.ballroom = input_.ballroom
		init_dancers()

	func init_dancers():
		arr.dancer = []
		
		var input = {}
		input.hp = 100
		input.troupe = self
		var dancer = Classes_1.Dancer.new(input)
		arr.dancer.append(dancer)
