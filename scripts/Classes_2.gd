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

	func aim():
		var goal = obj.card.obj.exam.get_goal()
		obj.pas.dot = Global.obj.ballroom.find_nearest_dot(goal)
		obj.card.obj.exam.obj.zone.set_vertexs()

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
		var delay = 0
		
		for content in Global.dict.effect.content:
			var input = {}
			input.value = null
			input.content = content
			input.subject = obj.dancer
			input.object = obj.dancer
			input.cast = "splash"
			var data = {}
			data.time = 0
			
			if content != "exam":
				input.value = obj.dancer.obj.feature.dict[content].current
			
			match content:
				"rest":
					data.time = input.value
				"rotate":
					if obj.pas.obj.dot != obj.dancer.obj.dot:
						obj.dancer.get_angle_by_target(obj.pas.obj.dot)
						
						if obj.dancer.num.angle.current != obj.dancer.num.angle.target:
							input.cast = "stream"
							data.time = obj.dancer.get_time_for_rotate()
				"move":
					if obj.pas.obj.dot != obj.dancer.obj.dot:
						input.cast = "stream"
						data.time = obj.dancer.get_time_for_move(obj.pas.obj.dot.vec.position)
				"exam":
					data.time = obj.exam.obj.challenge.num.preparation.max
				"rest":
					data.time = input.value
			
			if data.time > 0:
				data.dancer = obj.dancer
				data.card = self
				data.effect = Classes_3.Effect.new(input)
				data.delay = delay
				data.cord = "standart"
				Global.obj.timeflow.add_pause(data)
				delay += data.time
			
		var ends = []
		ends.append_array(Global.obj.ballroom.arr.end)
		Global.obj.ballroom.arr.end = []
		
		for end in ends:
			end.update_color()
			
		Global.current.dot = null

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
		var team = Global.current.dancer.obj.troupe.word.team
		fill_hand()

	func fill_hand():
		arr.hand = []
		
		var dancer = Global.current.dancer
		var team = dancer.obj.troupe.word.team
		var options = {}
		options.pas = []
		options.exam = []
		var n = 4
		
		if team == "mob":
			n = 1
		
		for _i in n:
			options.pas.append(Global.get_random_element(dancer.arr.pas))
			options.exam.append(Global.get_random_element(dancer.arr.exam))
		
		if team == "champion":
			var pas = null
			
			for pas_ in dancer.arr.pas:
				if pas_.num.layer == 12 && pas_.word.chesspiece == "king":
					pas = pas_
			
			if !options.pas.has(pas):
				options.pas.pop_front()
				options.pas.append(pas)
		
		for _i in n:
			var data = {}
			data.dancer = dancer
			data.temp = team == "mob"
			Global.rng.randomize()
			var index_r = Global.rng.randi_range(0, options.pas.size()-1)
			data.pas = options.pas.pop_at(index_r)
			Global.rng.randomize()
			index_r = Global.rng.randi_range(0, options.exam.size()-1)
			data.exam = options.exam.pop_at(index_r)
			add_card(data)
		
		if team == "champion":
			update_hand()
			Global.obj.timeflow.flag.stop = true
		else:
			discard_dinieds()
			var card = Global.get_random_element(arr.hand)
			card.obj.pas.obj.dot = dancer.obj.dot
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
