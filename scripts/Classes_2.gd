extends Node


class Pas:
	var num = {}
	var word = {}
	var arr = {}
	var obj = {}
	var color = {}
	var scene = {}
	var flag = {}

	func _init(input_):
		num.layer = input_.layer
		word.chesspiece = input_.chesspiece
		obj.easel = input_.easel
		obj.dot = null
		obj.card = null
		arr.vertex = []
		color.background = Color.gray
		
		for square in Global.arr.square:
			var vertex = Global.vec.pas.size/2*square
			arr.vertex.append(vertex)

	func get_ends():
		var dancer = Global.current.dancer
		var start = dancer.obj.dot
		var ends = [start]
		
		if dancer != null:
			var windroses = start.dict.neighbor[Global.num.layer.square]
			#rint(eye,dancer.num.angle.current,windroses)
			
			if windroses.size() > 0:
				match word.chesspiece:
					"pawn":
						if Global.dict.eye.keys().has(dancer.vec.eye):
							var eye = Global.dict.eye[dancer.vec.eye]
							var dot = windroses[eye]
							
							if dot.obj.dancer == null:
								ends.append(dot)
					"rook":
						for windrose in windroses:
							if windrose.length() == 1:
								var dots = get_dots_line(start,windrose)
								ends.append_array(dots)
					"bishop":
						for windrose in windroses:
							if windrose.length() == 2:
								var dots = get_dots_line(start,windrose)
								ends.append_array(dots)
					"queen":
						for windrose in windroses:
							var dots = get_dots_line(start,windrose)
							ends.append_array(dots)
					"king":
						for windrose in windroses:
							var dot = windroses[windrose]
						
							if dot.obj.dancer == null:
								ends.append(dot)
					"knight":
						for windrose in windroses:
							if windrose.length() == 2:
								var dots = get_dots_knight(start,windrose)
								ends.append_array(dots)
					"cat":
						for dots in Global.obj.ballroom.arr.dot:
							for dot in dots:
								if dot.obj.dancer == null:
									ends.append(dot)
								
		return ends

	func get_dots_line(start_,windrose_):
		var dot = start_
		var dots = []
		
		while dot.dict.neighbor[Global.num.layer.square].keys().has(windrose_):
			dot = dot.dict.neighbor[Global.num.layer.square][windrose_]
			
			if dot.obj.dancer == null:
				dots.append(dot)
			else:
				return dots
		
		return dots

	func get_dots_knight(start_,windrose_):
		var size = 2
		var dot = start_
		var dots = []
		
		while dot.dict.neighbor[Global.num.layer.square].keys().has(windrose_) && dots.size() < size:
			dot = dot.dict.neighbor[Global.num.layer.square][windrose_]
			dots.append(dot)
		
		if dots.size() == size:
			var end = dots.back()
			dots = []
			
			for windrose in Global.dict.windrose:
				if windrose.length() == windrose_.length():
					if windrose != windrose_ && windrose != Global.dict.reflected_windrose[windrose_]:
						if end.dict.neighbor[Global.num.layer.square].keys().has(windrose):
							dot = end.dict.neighbor[Global.num.layer.square][windrose]
							
							if dot.obj.dancer == null:
								dots.append(dot)
			
			return dots
		else:
			return []

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
		#var dancer = Global.obj.ballroom.dict.position[goal].obj.dancer
		#rint(goal, Global.obj.ballroom.dict.position[goal], dancer)
		return goal

class Zone:
	var word = {}
	var arr = {}
	var vec = {}
	var obj = {}
	var color = {}
	var scene = {}

	func _init(input_):
		vec.distance = input_.description.distance
		vec.size = input_.description.vector
		vec.position = Vector2()
		word.type = input_.description.type
		obj.exam = input_.exam
		color.background = Color.black
		
		init_scene()

	func init_scene():
		scene.zone = Global.scene.zone.instance()
		scene.zone.set_sprite(self)
		
		vec.scale = {}
		vec.scale.max = Vector2()
		vec.scale.max += vec.size
		vec.scale.max /= Global.vec.zone.size
		vec.scale.current = Vector2()

	func set_position():
		match word.type:
			"circle":
				vec.position = obj.exam.obj.card.obj.pas.obj.dot.vec.position
				scene.zone.position = vec.position
		
		#get_angle_by_target"zone",arr.vertex)

	func check_examine(examine_,type_):
		var inside = null
		
		match word.type:
			"circle":
				var d = vec.position.distance_to(examine_.vec.position)
				inside = d <= vec.size.x
		
		match type_:
			"inside":
				return !inside
			"outside":
				return inside

	func rise_scale(value_):
		#rint(vec.scale.current.x)
		vec.scale.current += Vector2(value_,value_)
		scene.zone.scale = vec.scale.current

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
						"max healt percent":
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
					obj.examinee = Classes_2.Examinee.new(input)
				"challenge":
					obj.challenge = Classes_2.Challenge.new(input)
				"zone":
					obj.zone = Classes_2.Zone.new(input)
				"penalty":
					obj.penalty = Classes_2.Penalty.new(input)

	func check_content(data_):
		var check = true
		
		match data_.phase:
			"hitch":
				check = obj.challenge.num.hitch != 0
			"place processing":
				if obj.challenge.flag.convergence || obj.card.obj.pas.obj.dot == obj.examiner.obj.dot:
					match data_.content:
						"find dot":
							check = false
						"rotate":
							check = false
						"move":
							check = false
			"target processing":
				if obj.challenge.flag.convergence:
					match data_.content:
						"rotate":
							check = false
			"rest":
				check = obj.challenge.num.rest != 0
		
		return check

	func end():
		obj.ballroom.arr.exam.erase(self)

class Card:
	var obj = {}
	var scene = {}
	var word = {}

	func _init(input_):
		word.border = ""
		scene.card = null
		obj.dancer = input_.dancer
		obj.exam = input_.exam
		obj.exam.obj.card = self
		obj.pas = input_.pas
		
		if obj.pas != null:
			obj.pas.obj.card = self

	func preuse():
		check_no_move()
		var cord = "standart"
		var data = {}
		data.cord = Global.obj.timeflow.dict.cord[cord]
		data.pas = obj.pas
		data.exam = obj.exam
		obj.dancer.obj.etude.set_parts(data)
		
		for phase in Global.dict.effect.phase.keys():
			for content in Global.dict.effect.phase[phase]:
				data.phase = phase
				data.content = content
				
				if obj.exam.check_content(data):
					data.dancer = obj.dancer
					obj.dancer.obj.etude.add_act(data)
		
		Global.obj.timeflow.add_temp(obj.dancer)
		var ends = []
		ends.append_array(Global.obj.ballroom.arr.end)
		Global.obj.ballroom.arr.end = []
		
		for end in ends:
			end.update_color()
		
		Global.current.dot = null

	func check_no_move():
		if obj.pas.obj.dot == null:
			obj.pas.obj.dot = obj.dancer.obj.dot

	func check_access():
		var team =  obj.dancer.obj.troupe.word.team
		
		match team:
			"champion":
				if obj.dancer.obj.dot.arr.layer.has(obj.pas.num.layer):
					word.border = "access"
				else:
					word.border = "denied"
			"mob":
				word.border = "access"

class Easel:
	var num = {}
	var arr = {}
	var vec = {}
	var flag = {}
	var dict = {}
	var color = {}

	func _init():
		arr.hand = []

	func next_action():
		arr.hand = []
		var team = Global.current.dancer.obj.troupe.word.team
		Global.current.dancer.obj.croupier.fill_hand()
		print("next_action", team)
		match team:
			"champion":
				update_hand()
				Global.obj.timeflow.flag.stop = true
			"mob":
				discard_dinieds()
				var card = Global.get_random_element(arr.hand)
				#card.obj.pas.obj.dot = Global.current.dancer.obj.dot
				card.preuse()
				Global.obj.timeflow.fix_temp()

	func update_hand():
		var card_gap = Global.vec.card.size.x*Global.num.card.zoom
		var position = Global.vec.hand.offset
		position.x -= float(arr.hand.size())/2*card_gap
		
		for pas in arr.hand:
			pas.scene.card.position = position
			position.x += card_gap

	func add_card(data_):
		var card = Classes_2.Card.new(data_)
		arr.hand.append(card)
		card.scene.card = Global.scene.card.instance()
		card.check_access()
		
		if !data_.temp:
			card.scene.card.set_spirtes(card)
			Global.node.Hand.add_child(card.scene.card)

	func preuse_card():
		if Global.current.pas != null:
			if Global.current.pas.obj.dot != null:
				Global.current.pas.obj.card.preuse()

	func discard_dinieds():
		for card in arr.hand:
			if card.word.border == "denied":
				arr.hand.erase(card)

	func clean_hand():
		var childs = Global.node.Hand.get_children()
		
		for child in childs:
			child.queue_free()
