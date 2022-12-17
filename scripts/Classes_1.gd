extends Node


class Dot:
	var num = {}
	var vec = {}
	var arr = {}
	var obj = {}
	var color = {}

	func _init(input_):
		num.l = input_.l
		arr.n = input_.ns
		arr.a = [Global.num.dot.a/arr.n.front()]
		vec.grid = input_.grid
		vec.position = input_.position
		obj.ballroom = input_.ballroom
		obj.ballroom.dict.position[vec.position] = self
		color.background = Color.yellow

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
		obj.exam = input_.exam
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
		obj.exam = input_.exam

	func tick():
		num.time.current += 1
		
		if num.time.current >= num.time.max:
			num.time.current = 0
			check_examinees()
			obj.exam.obj.ballroom.arr.exam.erase(obj.exam)

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
		set_examinees()
		set_challenge()
		set_zones()
		set_penalty()

	func set_examinees():
		var dancers = obj.ballroom.dict.troupe[Global.dict.opponent[obj.examiner.obj.troupe.word.team]].arr.dancer
		arr.examinee = []
		
		match word.name:
			"Classic exam 0":
				arr.examinee.append_array(dancers)

	func set_challenge():
		var input = {}
		input.exam = self
		
		match word.name:
			"Classic exam 0":
				input.delay = 1
				input.type = "outside"
		
		obj.challenge = Classes_1.Challenge.new(input)

	func set_zones():
		arr.zone = []
		
		var input = {}
		input.exam = self
		
		match word.name:
			"Classic exam 0":
				input.type = "circle"
				input.target = "first"
				input.r = Global.dict.r[input.type][0]
		
		var zone = Classes_1.Zone.new(input)
		arr.zone.append(zone)

	func set_penalty():
		var input = {}
		input.exam = self
		
		match word.name:
			"Classic exam 0":
				input.effect = "instantaneous"
				input.type = "percent"
				input.value = 100
		
		obj.penalty = Classes_1.Penalty.new(input)

	func end():
		obj.ballroom.arr.exam.erase(self)

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
		
		for exam in obj.troupe.obj.ballroom.arr.exam:
			exam.arr.examinee.erase(self)

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
		var dancer = Classes_1.Dancer.new(input)
		arr.dancer.append(dancer)
