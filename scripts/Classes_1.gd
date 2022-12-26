extends Node


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
		discard_hand()
		
		for name_ in dict.keys():
			while dict[name_].hand.size() < num.draw[name_] && !flag.empty[name_]:
				draw_part(name_)
		
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
				if data.key != "hand":
					dict[data.name][data.key].append(dict[data.name].hand.pop_back())
					dict[data.name][data.key].erase(data.part)
					dict[data.name].hand.append(data.part)

	func get_part(data_):
		data_.key = null
		data_.part = null
		
		for key in Global.arr.croupier: 
			for part in dict[data_.name][key]:
				match data_.name:
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
			for name_ in dict.keys(): 
				dict[name_].hand.append(dict[name_].option.pop_front()) 
		
		check_12_king()
		
		for _i in num.n:
			var data = {}
			data.dancer = obj.dancer
			data.temp = obj.dancer.obj.troupe.word.team == "mob"
			
			for name_ in dict.keys(): 
				data[name_] = dict[name_].hand[_i]
			
			Global.obj.easel.add_card(data)

	func discard_hand():
		for name_ in dict.keys():
			while dict[name_].hand.size() > 0:
				var hand = dict[name_].hand.pop_front()
				dict[name_].discard.append(hand)
				hand.obj.card.obj[name_].obj.card = null
				
			while dict[name_].option.size() > 0:
				dict[name_].discard.append(dict[name_].option.pop_front())
			
			flag.empty[name_] = false

class Etude:
	var num = {}
	var word = {}
	var arr = {}
	var obj = {}
	var dict = {}

	func _init(input_):
		obj.dancer = input_.dancer
		arr.act = []
		reset()

	func reset():
		num.time = 0
		word.cord = ""
		obj.pas =  null
		obj.exam = null

	func set_parts(data_):
		word.cord = data_.cord
		obj.pas = data_.pas
		obj.exam = data_.exam

	func add_act(data_):
		var act = Classes_3.Act.new(data_)
		arr.act.append(act)

	func calc_total_time():
		for act in arr.act:
			act.calc_time()
			num.time += act.num.time.max

	func perform():
		if arr.act.size() > 0:
			arr.act.front().perform_stage()
		else:
			Global.current.dancer = self
			reset()
			Global.obj.easel.next_action()

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
		init_croupier()
		init_etude()
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

	func init_croupier():
		var input = {}
		input.draw = {}
		input.draw.pas = obj.feature.dict["pas draw"].current
		input.draw.exam = obj.feature.dict["exam draw"].current
		input.dancer = self
		obj.croupier = Classes_1.Croupier.new(input)
		
		for name_ in arr.keys():
			for part in arr[name_]:
				obj.croupier.add_part(name_,part)

	func init_etude():
		var input = {}
		input.dancer = self
		obj.etude = Classes_1.Etude.new(input)

	func add_exam(name_):
		var input = {}
		input.examiner = self
		input.name = name_
		var exam = Classes_2.Exam.new(input)
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
		if obj.troupe.word.team == "champion":
			print(vec.eye,vec.eye.angle_to(vector))
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

	func set_pas_place_dot(position_):
		Global.obj.timeflow.clean_temp()
		obj.ballroom.find_nearest_dot(position_)
		
		if Global.current.dot != null:
			if obj.ballroom.arr.end.has(Global.current.dot):
				Global.current.pas.obj.dot = Global.current.dot
				get_angle_by_target(Global.current.dot)
				Global.obj.easel.preuse_card()
			else:
				Global.current.dot = null

	func set_pas_target_dot(position_):
		var goal = obj.etude.obj.exam.obj.examinee.get_goal()
		obj.ballroom.find_nearest_dot(position_)
		
		if Global.current.dot != null:
			Global.current.pas.obj.dot = Global.current.dot
			obj.etude.obj.exam.obj.zone.set_position()
			get_angle_by_target(Global.current.dot)

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
