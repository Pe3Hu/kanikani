extends Node


class Dot:
	var num = {}
	var vec = {}
	var obj = {}
	var color = {}

	func _init(input_):
		num.n = input_.n
		num.l = input_.l
		num.a = Global.num.dot.a/input_.n
		vec.grid = input_.grid
		vec.position = input_.grid*num.l+Global.vec.ballroom
		obj.ballroom = input_.ballroom
		color.background = Color.yellow

class Square:
	var vec = {}
	var arr = {}
	var obj = {}
	var color = {}

	func _init(input_):
		vec.grid = input_.grid
		vec.center = Vector2()
		obj.ballroom = input_.ballroom
		arr.dot = input_.dots
		arr.vertex = []
		color.background = Color.gray
		
		for dot in arr.dot:
			arr.vertex.append(dot.vec.position)
			vec.center += dot.vec.position
		
		vec.center /= arr.vertex.size()

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
		obj.pas = input_.pas
		color.background = Color.black
		
		set_vertexs()

	func set_vertexs():
		match word.type:
			"circle":
				match word.target:
					"first":
						var position = obj.pas.arr.examinee.front().vec.position
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
		obj.pas = input_.pas
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
		obj.pas = input_.pas

	func tick():
		num.time.current += 1
		
		if num.time.current >= num.time.max:
			num.time.current = 0
			check_examinees()

	func check_examinees():
		for examinee in obj.pas.arr.examinee:
			for zone in obj.pas.arr.zone:
				if zone.check_examine(examinee,word.type):
					if !obj.pas.obj.penalty.arr.dancer.has(examinee):
						obj.pas.obj.penalty.arr.dancer.append(examinee)
		
		if obj.pas.obj.penalty.arr.dancer.size() > 0:
			obj.pas.obj.penalty.punishment()

class Pas:
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
			"Classic pas 0":
				arr.examinee.append_array(dancers)

	func set_challenge():
		var input = {}
		input.pas = self
		
		match word.name:
			"Classic pas 0":
				input.delay = 3
				input.type = "outside"
		
		obj.challenge = Classes_0.Challenge.new(input)

	func set_zones():
		arr.zone = []
		
		var input = {}
		input.pas = self
		
		match word.name:
			"Classic pas 0":
				input.type = "circle"
				input.target = "first"
				input.r = Global.dict.r[input.type][0]
		
		var zone = Classes_0.Zone.new(input)
		arr.zone.append(zone)

	func set_penalty():
		var input = {}
		input.pas = self
		
		match word.name:
			"Classic pas 0":
				input.effect = "instantaneous"
				input.type = "percent"
				input.value = 25
		
		obj.penalty = Classes_0.Penalty.new(input)

	func end():
		obj.ballroom.arr.pas.erase(self)

class Dancer:
	var num = {}
	var vec = {}
	var obj = {}
	var color = {}

	func _init(input_):
		num.hp = {}
		num.hp.max = input_.hp
		num.hp.current = num.hp.max
		num.a = Global.num.dancer.a
		vec.position = Vector2(Global.vec.ballroom.x,Global.vec.ballroom.y)
		obj.troupe = input_.troupe
		
		set_color()

	func set_color():
		match obj.troupe.word.team:
			"mob":
				color.background = Color.red
			"champion":
				color.background = Color.green

	func shift(step_):
		vec.position = obj.troupe.obj.ballroom.limit_step(vec.position,step_)

	func get_damage(damage_):
		num.hp.current -= damage_
		print(num.hp.current)
		
		if num.hp.current <= 0:
			die()

	func die():
		obj.troupe.arr.dancer.erase(self)
		
		for pas in obj.troupe.obj.ballroom.arr.pas:
			pas.arr.examinee.erase(self)

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
		var dancer = Classes_0.Dancer.new(input)
		arr.dancer.append(dancer)

class Ballroom:
	var num = {}
	var arr = {}
	var vec = {}
	var flag = {}
	var dict = {}
	var color = {}

	func _init():
		arr.pas = []
		init_dots()
		init_squares()
		init_troupes()
		
		color.background = Color.gray

	func init_dots():
		dict.dot = {}
		
		for n in Global.arr.n:
			dict.dot[n] = []
			var l = Global.num.ballroom.l/n
			
			for _i in n+1:
				dict.dot[n].append([])
				
				for _j in n+1:
					var input = {}
					input.grid = Vector2(_j,_i)
					input.ballroom = self
					input.n = n
					input.l = l
					var dot = Classes_0.Dot.new(input)
					dict.dot[n][_i].append(dot)

	func init_squares():
		dict.square = {}
		
		for n in dict.dot.keys():
			dict.square[n] = []
			
			for _i in dict.dot[n].size():
				dict.square[n].append([])
			
				for _j in dict.dot[n][_i].size():
					var input = {}
					input.grid = Vector2(_j,_i)
					input.dots = []
					
					for square in Global.arr.square:
						var grid = input.grid+square
						
						if check_grid(grid,n):
							input.dots.append(dict.dot[n][grid.y][grid.x])
					
					if input.dots.size() == Global.arr.square.size():
						input.ballroom = self
						var square = Classes_0.Square.new(input)
						dict.square[n][_i].append(square)
				
				if dict.square[n][_i].size() == 0:
					dict.square[n].remove(_i)

	func init_troupes():
		dict.troupe = {}
		
		for team in Global.dict.opponent.keys():
			var input = {}
			input.team = team
			input.ballroom = self
			var troupe = Classes_0.Troupe.new(input)
			dict.troupe[input.team] = troupe
		
		spread_troupes()
		add_pas("mob")

	func spread_troupes():
		var n = 3
		var half = n/2
		var achors = {}
		achors["mob"] = dict.square[n][half][dict.square[n][half].size()-1].vec.center
		achors["champion"] = dict.square[n][half][0].vec.center
		
		for team in dict.troupe.keys():
			var troupe = dict.troupe[team]
			var achor = achors[team]
			
			for dancer in troupe.arr.dancer:
				dancer.vec.position = achor

	func add_pas(team_):
		var input = {}
		input.examiner = dict.troupe[team_].arr.dancer.front()
		input.name = Global.arr.pas.front()
		var pas = Classes_0.Pas.new(input)
		arr.pas.append(pas)

	func shift_troupe(team_,step_):
		for dancer in dict.troupe[team_].arr.dancer:
			dancer.shift(step_)

	func check_grid(grid_,n_):
		return grid_.x >= 0 && grid_.x <= n_ && grid_.y >= 0 && grid_.y <= n_

	func limit_step(position_,step_):
		var limit = dict.dot[1].back().back().vec.position
		var vec_ = position_+step_
		var x = vec_.x
		var y = vec_.y
		
		if vec_.x < 0:
			x = 0
		if vec_.x >= limit.x:
			x = limit.x
		if vec_.y < 0:
			y = 0
		if vec_.y >= limit.y:
			y = limit.y
		
		return Vector2(x,y)
