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

class Examinee:
	var dict = {}
	var obj = {}

	func _init(input_):
		obj.exam = input_.exam
		var team = obj.exam.obj.examiner.obj.troupe.word.team
		var ballroom = obj.exam.obj.examiner.obj.troupe.obj.ballroom
		var dancers = ballroom.dict.troupe[Global.dict.opponent[team]].arr.dancer
		
		for key in input_.description.keys():
			dict[key] = []
			var data = input_.description[key]
			var arr_ = find_dancers(dancers,data)
			dict[key].append_array(arr_)

	func find_dancers(dancers_,key_):
		var dancers = []
		
		match key_:
			"all":
				return dancers_
			"max health":
				var datas = []
				
				for dancer in dancers_:
					var data = {}
					data.dancer = dancer
					data.value = dancer.get_health()
					datas.append(data)
				
				datas.sort_custom(Classes_0.Sorter, "sort_descending")
				dancers.append(datas.front().dancer)
		
		return dancers

	func get_goal():
		var goal = Vector2()
		
		for main in dict.main:
			goal += main.vec.position
		
		goal /= dict.main.size()
		return goal

class Zone:
	var word = {}
	var arr = {}
	var vec = {}
	var obj = {}
	var color = {}

	func _init(input_):
		vec.distance = input_.description.distance
		vec.size = input_.description.vector
		word.type = input_.description.type
		arr.vertex = []
		obj.exam = input_.exam
		color.background = Color.black

	func set_vertexs():
		match word.type:
			"circle":
				var position = obj.exam.obj.card.obj.pas.obj.dot.vec.position
				arr.vertex.append(position)

	func check_examine(examine_,type_):
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
		num.value = input_.description.value
		word.type = input_.description.type
		word.effect = input_.description.effect
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
	var flag = {}
	var obj = {}

	func _init(input_):
		num.preparation = {}
		num.preparation.max = input_.description.preparation
		num.preparation.current = 0
		num.hitch = input_.description.hitch
		num.rest = input_.description.rest
		word.type = input_.description.type
		flag.aim = input_.description.aim
		flag.convergence = input_.description.convergence
		obj.exam = input_.exam

	func check_examinees():
		for secondary in obj.exam.obj.examinee.dict.secondary:
			if obj.exam.obj.zone.check_examine(secondary,word.type):
				if !obj.exam.obj.penalty.arr.dancer.has(secondary):
					obj.exam.obj.penalty.arr.dancer.append(secondary)
		
		print(obj.exam.obj.examinee.dict.secondary,obj.exam.obj.penalty.arr.dancer)
		if obj.exam.obj.penalty.arr.dancer.size() > 0:
			obj.exam.obj.penalty.punishment()

class Exam:
	var word = {}
	var obj = {}

	func _init(input_):
		word.name = input_.name
		obj.examiner = input_.examiner
		obj.ballroom = obj.examiner.obj.troupe.obj.ballroom
		obj.card = null

	func set_descriptions():
		var description = Global.dict.exam.description[word.name]
		
		for key in description.keys():
			var input = {}
			input.exam = self
			input.description = description[key]
			
			match key:
				"examinee":
					obj.examinee = Classes_1.Examinee.new(input)
				"challenge":
					obj.challenge = Classes_1.Challenge.new(input)
				"zone":
					obj.zone = Classes_1.Zone.new(input)
				"penalty":
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

class Croupier:
	var num = {}
	var obj = {}
	var dict = {}
	var flag = {}
	
	func _init(input_):
		num.draw = {}
		num.draw.pas = input_.draw.pas
		num.draw.exam = input_.draw.exam
		num.n = min(num.draw.pas,num.draw.exam)
		obj.dancer = input_.dancer
		flag.empty = {}
		
		for name_ in num.draw.keys():
			dict[name_] = {}
			flag.empty[name_] = false
			
			for key in Global.arr.croupier:
				dict[name_][key] = []

	func add_part(name_,part_):
		dict[name_].discard.append(part_)

	func fill_hand():
		for name_ in dict.keys():
			while dict[name_].hand.size() < num.draw[name_] && !flag.empty[name_]:
				draw_part(name_)
		
		check_12_king()
		mix_parts()

	func draw_part(name_):
		if dict[name_].deck.size() > 0:
			dict[name_].option.append(dict[name_].deck.pop_front())
		else:
			regain_discard(name_)
			
			if dict[name_].deck.size() == 0:
				flag.empty[name_] = true
			else:
				dict[name_].option.append(dict[name_].deck.pop_front())

	func regain_discard(name_):
		print("#")
		while dict[name_].discard.size() > 0:
			dict[name_].deck.append(dict[name_].discard.pop_front())

	func check_12_king():
		if obj.dancer.obj.troupe.word.team == "champion":
			var data = {}
			data.name = "pas"
			data.layer = 12
			data.chesspiece = "king"
			data = get_part(data)
			
			if data.part != null:
				if data.key != "option":
					dict[data.name][data.key].erase(data.part)
					dict[data.name].option.append(data.part)

	func get_part(data_):
		data_.key = null
		data_.part = null
		
		for key in Global.arr.croupier: 
			for part in dict[data_.name][key]:
				match data_.part:
					"pas":
						if part.num.layer == data_.layer && part.word.chesspiece == data_.chesspiece:
							data_.part = part
							data_.key = key
							return data_
		
		return data_

	func mix_parts():
		for name_ in dict.keys():
			dict[name_].option.shuffle()
		
		for _i in num.n:
			var data = {}
			data.dancer = obj.dancer
			data.temp = obj.dancer.obj.troupe.word.team == "mob"
			
			for name_ in dict.keys(): 
				data[name_] = dict[name_].option.pop_front()
			
			Global.obj.easel.add_card(data)

	func discard_hand():
		for name_ in dict.keys():
			while dict[name_].hand.size() > 0:
				dict[name_].discard.append(dict[name_].hand.pop_front())
			while dict[name_].option.size() > 0:
				dict[name_].discard.append(dict[name_].option.pop_front())

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
		inin_croupier()
		set_color()
		vec.eye = Vector2(1,0)
		num.angle = {}
		num.angle.current = 0
		num.angle.target = 0
		num.time = {}
		num.time.hitch = 0
		num.time.rest = 0

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
		var team = obj.troupe.word.team
		
		for chesspiece in Global.dict.team.chesspiece[team]:
			var input = {}
			input.chesspiece = chesspiece
			input.layer = Global.get_random_element(Global.arr.pas_layer)
			input.easel = self
			var pas = Classes_2.Pas.new(input)
			arr.pas.append(pas)
		
		if team == "champion":
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

	func inin_croupier():
		var input = {}
		input.draw = {}
		input.draw.pas = obj.feature.dict["pas draw"].current
		input.draw.exam = obj.feature.dict["exam draw"].current
		input.dancer = self
		obj.croupier = Classes_1.Croupier.new(input)
		
		for name_ in arr.keys():
			for part in arr[name_]:
				obj.croupier.add_part(name_,part)

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

	func get_health():
		return obj.feature.dict["health"].current

	func die():
		obj.troupe.arr.dancer.erase(self)
		
		for exam in obj.troupe.obj.ballroom.arr.exam:
			exam.arr.secondary.erase(self)
		
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
