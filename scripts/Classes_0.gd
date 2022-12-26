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
			var dot = Classes_0.Dot.new(input)
			obj.ballroom.dict.dot[arr.n.front()][arr.dot.front().vec.grid.y].append(dot)
		else:
			obj.ballroom.dict.dot[arr.n.front()][arr.dot.front().vec.grid.y].append(obj.ballroom.dict.position[input.position])
			obj.ballroom.dict.position[input.position].arr.n.append(arr.n.front())

class Ballroom:
	var num = {}
	var arr = {}
	var vec = {}
	var flag = {}
	var dict = {}
	var color = {}

	func _init():
		arr.exam = []
		arr.end = []
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
					input.position = input.grid*input.l+Global.vec.ballroom.offset
					
					if !dict.position.keys().has(input.position):
						input.ballroom = self
						input.ns = [n]
						var dot = Classes_0.Dot.new(input)
						dict.dot[n][_i].append(dot)
					else:
						dict.dot[n][_i].append(dict.position[input.position])
						dict.position[input.position].arr.n.append(n)

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
						var square = Classes_0.Square.new(input)
						dict.square[n][_i].append(square)
				
				if dict.square[n][_i].size() == 0:
					dict.square[n].remove(_i)
		
		set_dot_neighbors()

	func set_dot_neighbors():
		for position in dict.position.keys():
			var dot = dict.position[position]
			
			for n in dot.arr.n:
				var layer = n
				
				if n < 0:
					layer = abs(n)-1
				
				dot.arr.layer.append(layer)
			
			for windrose in Global.dict.windrose.keys():
				for layer in dot.arr.layer:
					var l = Global.num.ballroom.l/layer
					
					if windrose.length() == 2:
						l /= 2
					
					var shift = Global.dict.windrose[windrose]*l
					shift += dot.vec.position
					
					if dict.position.keys().has(shift):
						var dot_ = dict.position[shift]
						dot.add_neighbor(layer, windrose, dot_)
		
		for n in Global.arr.n:
			for squares in dict.square[n]:
				for square in squares:
					var dot = dict.position[square.vec.center]
					dot.arr.center.append(n)
		
		update_dot_colors()

	func update_dot_colors():
		for position in dict.position.keys():
			var dot = dict.position[position]
			dot.update_color()

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
		set_exams()

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
				dancer.set_position(achor)
				dancer.set_dot()
		
		for team in dict.troupe.keys():
			var troupe = dict.troupe[team]
			
			for dancer in troupe.arr.dancer:
				var enemy = dancer.find_enemy()
				dancer.look_at_dot(enemy.obj.dot)

	func set_exams():
		for team in dict.troupe.keys():
			for dancer in dict.troupe[team].arr.dancer:
				for exam in dancer.arr.exam:
					exam.set_descriptions()

	func shift_troupe(team_,step_):
		for dancer in dict.troupe[team_].arr.dancer:
			dancer.shift(step_)
		
		# dict.Global.num.layer.square]

	func get_dots_by_pas():
		var pas = Global.current.pas
		
		if pas != null:
			var dots = []
			dots.append_array(arr.end)
			arr.end = []
			
			for end in dots:
				end.update_color()
				
			var ends = pas.get_ends()
			arr.end.append_array(ends)
			
			for end in arr.end:
				end.update_color()

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

	func find_nearest_dot(vec_):
		Global.current.dot = null
		var datas = []
		
		for position in dict.position.keys():
			var data = {}
			data.dot = dict.position[position]
			
			if data.dot.arr.layer.has(Global.num.layer.square):
				data.value = position.distance_to(vec_)
				datas.append(data)
		
		datas.sort_custom(Classes_0.Sorter, "sort_ascending")
		Global.current.dot = datas.front().dot

	func check_borderline(mouse_):
		var offset = Global.vec.ballroom.offset
		var x = offset.x <= mouse_.x && offset.x+Global.num.ballroom.l >= mouse_.x
		var y = offset.y <= mouse_.y && offset.y+Global.num.ballroom.l >= mouse_.y
		return x && y

class Sorter:
	static func sort_ascending(a, b):
		if a.value < b.value:
			return true
		return false

	static func sort_descending(a, b):
		if a.value > b.value:
			return true
		return false
