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
		arr.center = []
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
			
			if arr.center.has(Global.num.layer.square):
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
	var word = {}
	var arr = {}
	var vec = {}
	var obj = {}
	var color = {}

	func _init(input_):
		vec.size = input_.vector
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
				inside = d <= vec.size.x
		
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
							var damage = float(dancer.obj.feature.dict["health"].max*num.value)/100
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
		obj.card = null

	func set_descriptions():
		var description = Global.dict.exam.description[word.name]
		
		for key in description.keys():
			var data = description[key]
			
			match key:
				"examinees":
					set_examinees(data)
				"challenge":
					set_challenge(data)
				"zone":
					set_zones(data)
				"penalty":
					set_penalty(data)

	func set_examinees(data_):
		var team = obj.examiner.obj.troupe.word.team
		var opponent = obj.ballroom.dict.troupe[Global.dict.opponent[team]].arr.dancer
		arr.examinee = []
		
		match data_["target"]:
			"all":
				arr.examinee.append_array(opponent)

	func set_challenge(data_):
		var input = {}
		input.exam = self
		
		for key in data_.keys():
			input[key] = data_[key]
		
		obj.challenge = Classes_1.Challenge.new(input)

	func set_zones(data_):
		arr.zone = []
		var input = {}
		input.exam = self
		
		for key in data_.keys():
			input[key] = data_[key]
		
		var zone = Classes_1.Zone.new(input)
		arr.zone.append(zone)

	func set_penalty(data_):
		var input = {}
		input.exam = self
		
		for key in data_.keys():
			input[key] = data_[key]
		
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
	var word = {}
	var vec = {}
	var obj = {}
	var arr = {}
	var color = {}
	var scene = {}

	func _init(input_):
		num.a = Global.num.dancer.a
		word.name = input_.name
		obj.troupe = input_.troupe
		obj.ballroom = obj.troupe.obj.ballroom
		init_feature()
		init_scenes()
		init_exams()
		init_pass()
		set_color()
		vec.eye = Vector2(1,0)
		num.angle = {}
		num.angle.current = 0
		num.angle.target = 0
		num.angle.target = 0

	func init_scenes():
		scene.dancer = {}
		scene.dancer.ui = Global.scene.dancer.ui.instance()
		Global.node.UIDancers.add_child(scene.dancer.ui)
		scene.dancer.ui.position = Global.vec[obj.troupe.word.team].current
		Global.vec[obj.troupe.word.team].current.y += Global.vec.dancer.ui.y
		update_health()
		
		scene.dancer.map = Global.scene.dancer.map.instance()
		Global.node.MapDancers.add_child(scene.dancer.map)
		set_position(Vector2(Global.vec.ballroom.offset.x,Global.vec.ballroom.offset.y))

	func init_feature():
		var input = {}
		input.dancer = self
		obj.feature = Classes_1.Feature.new(input)

	func set_color():
		match obj.troupe.word.team:
			"mob":
				color.background = Color.purple
			"champion":
				color.background = Color.green
		
		scene.dancer.map.set_sprite(obj.troupe.word.team,color.background)
		scene.dancer.ui.set_sprite(obj.troupe.word.team,color.background)

	func set_position(position_):
		vec.position = position_
		scene.dancer.map.position = vec.position

	func init_pass():
		arr.pas = []
		
		for chesspiece in Global.arr.chesspiece:
			var input = {}
			input.chesspiece = chesspiece
			input.layer = Global.get_random_element(Global.arr.pas_layer)
			input.easel = self
			var pas = Classes_2.Pas.new(input)
			arr.pas.append(pas)
		
		var input = {}
		input.chesspiece = "king"
		input.layer = 12
		input.easel = self
		var pas = Classes_2.Pas.new(input)
		arr.pas.append(pas)

	func init_exams():
		arr.exam = []
	
		for name_ in Global.dict.dancer.exam[word.name]:
			add_exam(name_)

	func add_exam(name_):
		var input = {}
		input.examiner = self
		input.name = name_
		var exam = Classes_1.Exam.new(input)
		arr.exam.append(exam)

	func shift(step_):
		set_position(obj.troupe.obj.ballroom.limit_step(vec.position,step_))

	func look_at_dot(dot_):
		var vector = dot_.vec.position-vec.position
		num.angle.target = vec.eye.angle_to(vector)
		rotate_by(num.angle.target)

	func update_eye():
		
#		if vec.eye.x != 0:
#			vec.eye.x = vec.eye.x/abs(vec.eye.x)
#		if vec.eye.y != 0:
#			vec.eye.y = vec.eye.y/abs(vec.eye.y)
		vec.eye = Vector2(1,0).rotated(num.angle.current)

	func get_angle_by_target(dot_):
		var vector = dot_.vec.position-vec.position
		num.angle.target = vec.eye.angle_to(vector)+num.angle.current

	func rotate_by(angle_):
		num.angle.current += angle_
		scene.dancer.map.rotate(num.angle.current)
		update_eye()

	func get_time_for_rotate():
		var time = float(abs(num.angle.current-num.angle.target))/obj.feature.dict["rotate"].current
		return time

	func move_by(d_):
		var step = Vector2(vec.eye.x*d_,vec.eye.y*d_)
		vec.position += step
		scene.dancer.map.position = vec.position

	func get_time_for_move(position_):
		var time = vec.position.distance_to(position_)/obj.feature.dict["move"].current
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
		Global.obj.timeflow.clean_temp()
		obj.ballroom.find_nearest_dot(position_)
		
		if Global.current.dot != null:
			if obj.ballroom.arr.end.has(Global.current.dot):
				Global.current.pas.obj.dot = Global.current.dot
				Global.obj.easel.preuse_card()
			else:
				Global.current.dot = null

	func get_damage(damage_):
		obj.feature.dict["health"].current -= damage_
		update_health()
		
		if obj.feature.dict["health"].current <= 0:
			die()

	func update_health():
		scene.dancer.ui.set_healt(self)

	func die():
		obj.troupe.arr.dancer.erase(self)
		
		for exam in obj.troupe.obj.ballroom.arr.exam:
			exam.arr.examinee.erase(self)
		
		scene.dancer.map.queue_free()

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
		input.name = Global.get_random_element(Global.dict.team.name[word.team])
		input.troupe = self
		var dancer = Classes_1.Dancer.new(input)
		arr.dancer.append(dancer)
