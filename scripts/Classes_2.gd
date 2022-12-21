extends Node


class Pas:
	var word = {}
	var arr = {}
	var obj = {}
	var color = {}
	var scene = {}

	func _init(input_):
		word.chesspiece = input_.chesspiece
		obj.easel = input_.easel
		obj.dot = null
		arr.vertex = []
		color.background = Color.gray
		
		for square in Global.arr.square:
			var vertex = Global.vec.pas.size/2*square
			arr.vertex.append(vertex)
		
		scene.card = null

	func get_ends():
		var dancer = Global.obj.ballroom.obj.current.dancer
		var ends = []
		
		if dancer != null:
			var start = dancer.obj.dot
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

	func use():
		var dancer = Global.obj.ballroom.obj.current.dancer
		dancer.get_angle_by_target(obj.dot)
		
		if dancer.num.angle.current != dancer.num.angle.target:
			var input = {}
			input.value = dancer.obj.feature.dict["rotate"].current
			input.cast = "stream"
			input.content = "rotate"
			input.subject = dancer
			input.object = dancer
			
			var data = {}
			data.dancer = dancer
			data.pas = self
			data.effect = Classes_3.Effect.new(input)
			data.time = dancer.get_time_for_rotate()
			data.delay = 0
			data.cord = "standart"
			Global.obj.timeflow.add_pause(data)
			
			input.value = dancer.obj.feature.dict["move"].current
			input.content = "move"
			data.effect = Classes_3.Effect.new(input)
			data.delay = data.time
			data.cord = "standart"
			data.time = dancer.get_time_for_move(obj.dot.vec.position)
			Global.obj.timeflow.add_pause(data)
			
			var ends = []
			ends.append_array(Global.obj.ballroom.arr.end)
			Global.obj.ballroom.arr.end = []
			
			for end in ends:
				end.update_color()
				
			Global.obj.ballroom.obj.current.dot =null

class Easel:
	var num = {}
	var arr = {}
	var vec = {}
	var flag = {}
	var dict = {}
	var obj = {}
	var color = {}

	func _init():
		obj.current = {}
		obj.current.pas = null
		init_pass()

	func init_pass():
		arr.pas = []
		arr.hand = []
		
		for chesspiece in Global.arr.chesspiece:
			var input = {}
			input.chesspiece = chesspiece
			input.easel = self
			var pas = Classes_2.Pas.new(input)
			arr.pas.append(pas)
		
		#apply_chesspiece()
		fill_hand()

	func apply_chesspiece():
		var dancer = dict.troupe["mob"].arr.dancer.front()
		var pas = arr.pas.front()
		arr.option = []

	func fill_hand():
		for pas in arr.pas:
			add_card(pas)
			
		update_hand()

	func update_hand():
		var card_gap = Global.vec.card.size.x+Global.vec.card.size.x*0.1
		var position = Global.vec.hand.offset
		position.x -= float(arr.hand.size())/2*card_gap
		
		for pas in arr.hand:
			pas.scene.card.rect_position = position
			position.x += card_gap

	func add_card(pas_):
		arr.hand.append(pas_)
		pas_.scene.card = Global.scene.card.instance()
		pas_.scene.card.set_name(pas_)
		Global.node.Hand.add_child(pas_.scene.card)

	func use_card():
		if obj.current.pas != null:
			if obj.current.pas.obj.dot != null:
				obj.current.pas.use()
