extends Node


class Ballroom:
	var num = {}
	var arr = {}
	var vec = {}
	var flag = {}
	var dict = {}
	var color = {}

	func _init():
		arr.exam = []
		init_dots()
		init_squares()
		init_rombs()
		init_troupes()
		color.background = Color.gray

	func init_dots():
		dict.position = {}
		dict.dot = {}
		
		for n in Global.arr.n:
			dict.dot[n] = []
			var l = Global.num.ballroom.l/n
			
			for _i in n+1:
				dict.dot[n].append([])
				
				for _j in n+1:
					var input = {}
					input.grid = Vector2(_j,_i)
					input.l = l
					input.position = input.grid*input.l+Global.vec.ballroom
					
					if !dict.position.keys().has(input.position):
						input.ballroom = self
						input.ns = [n]
						var dot = Classes_1.Dot.new(input)
						dict.dot[n][_i].append(dot)
					else:
						dict.dot[n][_i].append(dict.position[input.position])
						dict.position[input.position].arr.n.append(n)
			
			print(dict.position.keys().size())

	func init_squares():
		dict.square = {}
		
		for n in dict.dot.keys():
			dict.dot[-n-1] = []
			dict.square[n] = []
			
			for _i in dict.dot[n].size():
				dict.dot[-n-1].append([])
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
						input.ns = [-n-1]
						input.ballroom = self
						var square = Classes_1.Square.new(input)
						dict.square[n][_i].append(square)
				
				if dict.square[n][_i].size() == 0:
					dict.square[n].remove(_i)

	func init_rombs():
		dict.romb = {}
		
		for n in dict.square.keys():
			dict.romb[n] = []
			
			for _i in dict.square[n].size():
				dict.romb[n].append([])
				
				for _j in dict.square[n][_i].size():
					var square = dict.square[n][_i][_j]
					var input = {}
					input.grid = Vector2(_j,_i)
					input.windrose = {}
					input.windrose["N"] = square.vec
					input.windrose["E"] = square.arr.vertex[0]
					input.windrose["W"] = square.arr.vertex[1]

	func init_troupes():
		dict.troupe = {}
		
		for team in Global.dict.opponent.keys():
			var input = {}
			input.team = team
			input.ballroom = self
			var troupe = Classes_1.Troupe.new(input)
			dict.troupe[input.team] = troupe
		
		spread_troupes()
		add_exam("mob")

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

	func add_exam(team_):
		var input = {}
		input.examiner = dict.troupe[team_].arr.dancer.front()
		input.name = Global.arr.exam.front()
		var exam = Classes_1.Exam.new(input)
		arr.exam.append(exam)

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
