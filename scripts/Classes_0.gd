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
	var word = {}
	var arr = {}
	var obj = {}
	
	func _init(input_):
		word.type = input_.type
		arr.vertex = input_.vertexs
		obj.pas = input_.pas

class Penalty:
	var word = {}
	var obj = {}
	
	func _init(input_):
		word.type = input_.type
		obj.pas = input_.pas

class Challenge:
	var num = {}
	var word = {}
	var obj = {}
	
	func _init(input_):
		num.delay = input_.delay
		word.type = input_.type
		obj.pas = input_.pas

	func set_zones():
		pass

class Pas:
	var word = {}
	var arr = {}
	var obj = {}

	func _init(input_):
		word.name = input_.name
		obj.examiner = input_.examiner
		arr.examinee = input_.examinees
		set_challenge()
		set_penalty()

	func set_challenge():
		obj.challenge = null

	func set_penalty():
		obj.penalty = null

class Dancer:
	var num = {}
	var vec = {}
	var obj = {}
	var color = {}

	func _init(input_):
		num.a = Global.num.dancer.a
		vec.position = Vector2(Global.vec.ballroom.x,Global.vec.ballroom.y)
		obj.troupe = input_.troupe
		
		set_color()

	func set_color():
		match obj.troupe.word.team:
			"Mob":
				color.background = Color.red
			"Champion":
				color.background = Color.green

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
						
						if check_grid_(grid,n):
							input.dots.append(dict.dot[n][grid.y][grid.x])
					
					if input.dots.size() == Global.arr.square.size():
						input.ballroom = self
						var square = Classes_0.Square.new(input)
						dict.square[n][_i].append(square)
				
				if dict.square[n][_i].size() == 0:
					dict.square[n].remove(_i)

	func init_troupes():
		dict.troupe = {}
		var input = {}
		input.team = "Mob" 
		input.ballroom = self
		var troupe = Classes_0.Troupe.new(input)
		dict.troupe[input.team] = troupe
		
		input.team = "Champion" 
		input.ballroom = self
		troupe = Classes_0.Troupe.new(input)
		dict.troupe[input.team] = troupe
		
		spread_troupes()

	func spread_troupes():
		var n = 3
		var half = n/2
		var achors = {}
		achors["Mob"] = dict.square[n][half][dict.square[n][half].size()-1].vec.center
		achors["Champion"] = dict.square[n][half][0].vec.center
		
		for team in dict.troupe.keys():
			var troupe = dict.troupe[team]
			var achor = achors[team]
			
			for dancer in troupe.arr.dancer:
				dancer.vec.position = achor

	func check_grid_(grid_,n_):
		return grid_.x >= 0 && grid_.x <= n_ && grid_.y >= 0 && grid_.y <= n_
