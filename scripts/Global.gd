extends Node


var rng = RandomNumberGenerator.new()
var dict = {}
var num = {}
var arr = {}
var obj = {}
var node = {}
var flag = {}
var vec = {}
var color = {}
var scene = {}
var current = {}

func init_num():
	init_primary_key()
	
	num.ballroom = {}
	num.ballroom.n = 12
	num.ballroom.cols = num.ballroom.n
	num.ballroom.rows = num.ballroom.n
	num.ballroom.half = min(num.ballroom.cols,num.ballroom.rows)/2
	num.ballroom.l = min(dict.window_size.width,dict.window_size.height)*0.9
	num.ballroom.a = num.ballroom.l/min(num.ballroom.cols,num.ballroom.rows)
	num.ballroom.width = 1
	
	num.dot = {}
	num.dot.a = num.ballroom.a/6
	
	num.dancer = {}
	num.dancer.a = num.ballroom.a/6
	
	num.layer = {}
	num.layer.square = arr.n[2]
	
	num.easel = {}
	num.easel.offset = num.ballroom.a/2
	
	num.border = {}
	num.border.gap = num.ballroom.a/2
	
	num.pas = {}
	num.pas.offset = num.ballroom.a/4
	num.pas.label = num.ballroom.a/2*0.9
	
	num.space = {}
	num.space.l = dict.window_size.width-num.ballroom.cols*num.ballroom.a-num.border.gap*3
	
	num.dent = {}
	num.dent.width = 0.1
	num.dent.weight = 1
	num.dent.n = 10
	
	num.card = {}
	num.card.zoom = 1.2
	
	dict.r = {
		"circle": [num.ballroom.a]
	}
	
	dict.a = {}
	
	for n in Global.arr.n:
		dict.a[n] = num.ballroom.a/n

func init_primary_key():
	num.primary_key = {}
	num.primary_key.dot = 0

func init_dict():
	init_window_size()
	
	dict.windrose = {
		"N":  Vector2( 0, 1),
		"NE": Vector2(-1, 1),
		"E":  Vector2(-1, 0),
		"SE": Vector2(-1,-1),
		"S":  Vector2( 0,-1),
		"SW": Vector2( 1,-1),
		"W":  Vector2( 1, 0),
		"NW": Vector2( 1, 1)
	}
	
	dict.reflected_windrose = {}
	var n = dict.windrose.keys().size()
	
	for _i in n:
		var _j = (_i+n/2)%n
		dict.reflected_windrose[dict.windrose.keys()[_i]] = dict.windrose.keys()[_j]
	
	dict.eye = {}
	
	for windrose in dict.windrose.keys():
		var eye = dict.windrose[windrose]
		dict.eye[eye] = windrose
	
	dict.opponent = {
		"mob": "champion",
		"champion": "mob"
	}
	
	dict.effect = {}
	dict.effect.cast = ["stream","splash"]
	dict.effect.content = ["hitch","rotate","move","rotate","exam","rest"]
	dict.effect.exam = ["damage","heal","instigate","buff","debuff","summon"]
	
	dict.feature = {}
	dict.feature.base = {
		"champion": {
			"health": 100,
			"resource": 100,
			"rotate": 0.5,
			"move": 100,
			"irritant": 1,
			"hitch": 0,
			"rest": 1
		},
		"mob": {
			"health": 1000,
			"rotate": 1,
			"move": 1,
			"hitch": 0,
			"rest": 0#2
		}
	}
	
	dict.dancer = {}
	dict.dancer.exam = {
		"champion_0": ["exam_0"],
		"mob_0": ["exam_1000"]
	}
	
	dict.team = {}
	dict.team.name = {
		"champion" : ["champion_0"],
		"mob" : ["mob_0"]
	}
	dict.team.chesspiece = {
		"champion" : ["king","queen","rook","bishop","knight","pawn"],
		"mob" : ["cat"]
	}

func init_window_size():
	dict.window_size = {}
	dict.window_size.width = ProjectSettings.get_setting("display/window/size/width")
	dict.window_size.height = ProjectSettings.get_setting("display/window/size/height")
	dict.window_size.center = Vector2(dict.window_size.width/2, dict.window_size.height/2)
	
	OS.set_current_screen(1)

func init_arr():
	arr.sequence = {} 
	arr.sequence["A000040"] = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97]
	arr.sequence["A000045"] = [89, 55, 34, 21, 13, 8, 5, 3, 2, 1, 1]
	arr.sequence["A000124"] = [7, 11, 16] #, 22, 29, 37, 46, 56, 67, 79, 92, 106, 121, 137, 154, 172, 191, 211]
	arr.sequence["A001358"] = [4, 6, 9, 10, 14, 15, 21, 22, 25, 26]
	arr.diagonal = [
		Vector2( 1,-1),
		Vector2( 1, 1),
		Vector2(-1, 1),
		Vector2(-1,-1)
	]
	arr.neighbor = [
		Vector2( 0,-1),
		Vector2( 1, 0),
		Vector2( 0, 1),
		Vector2(-1, 0)
	]
	arr.square = [
		Vector2( 0, 0),
		Vector2( 1, 0),
		Vector2( 1, 1),
		Vector2( 0, 1)
	]
	
	arr.n = [1,2,3,4,12]
	arr.pas_layer = [2,3,4]
	arr.exam = ["classic exam 0"]
	arr.cord = ["slow","standart","fast"]
	
	arr.sprite = {}
	arr.sprite.card = ["Chesspiece","Layer","Exam","Border"]
	arr.sprite.act = ["Dancer","Effect","Narrow"]

func init_scene():
	scene.dancer = {}
	scene.dancer.map = preload("res://scenes/DancerMap.tscn")
	scene.dancer.ui = preload("res://scenes/DancerUI.tscn")
	scene.card = preload("res://scenes/Card.tscn")
	scene.act = preload("res://scenes/Act.tscn")

func init_node():
	node.Timer = get_node("/root/Game/Timer") 
	node.TimeBar = get_node("/root/Game/TimeBar") 
	node.Game = get_node("/root/Game") 
	node.Hand = get_node("/root/Game/Easel/Hand") 
	node.MapDancers = get_node("/root/Game/Ballroom/MapDancers") 
	node.UIDancers = get_node("/root/Game/UIDancers") 
	node.Acts = get_node("/root/Game/Timeflow/Acts") 

func init_flag():
	flag.click = false
	flag.stop = false

func init_vec():
	vec.ballroom = {}
	vec.ballroom.offset = Vector2(dict.window_size.width-num.border.gap, dict.window_size.height/2)
	vec.ballroom.offset -= Vector2(num.ballroom.cols, float(num.ballroom.rows)/2)*num.ballroom.a
	
	vec.easel = {}
	vec.easel.offset = vec.ballroom.offset+Vector2(num.ballroom.cols,0)*num.ballroom.a
	vec.easel.offset.x += num.border.gap
	
	vec.pas = {}
	vec.pas.size = Vector2(num.ballroom.a*3,num.ballroom.a)
	vec.pas.offset = Vector2(0,num.pas.offset+vec.pas.size.y/2)
	
	vec.hand = {}
	vec.hand.offset = Vector2(num.border.gap+num.space.l/2, dict.window_size.height-num.border.gap)
	
	vec.timeflow = {}
	vec.timeflow.offset = Vector2(num.border.gap, dict.window_size.height-num.border.gap*2)
	
	var temp_card = scene.card.instance()
	vec.card = {}
	vec.card.size = temp_card.get_size()
	vec.hand.offset.y -= vec.card.size.y/2*Global.num.card.zoom
	vec.hand.offset.x += vec.card.size.x/2*Global.num.card.zoom
	vec.timeflow.offset.y -= vec.card.size.y*Global.num.card.zoom
	temp_card.queue_free()
	
	vec.cord = {}
	vec.cord.size = Vector2(num.space.l,num.ballroom.a)
	num.dent.x = vec.cord.size.x/num.dent.n
	
	vec.dancer = {}
	vec.dancer.ui = Vector2(200,35)
	
	vec.champion = {}
	vec.champion.offset = Vector2(num.border.gap+node.TimeBar.rect_size.x*node.TimeBar.rect_scale.x,num.border.gap)
	vec.champion.current = vec.champion.offset
	
	vec.mob = {}
	vec.mob.offset = Vector2(vec.ballroom.offset.x-vec.dancer.ui.x+num.border.gap,num.border.gap)
	vec.mob.current = vec.mob.offset
	
	vec.sprite = {}
	vec.sprite.size = Vector2(32,32)
	

func init_color():
	color.cord = {
		"fast": Color.from_hsv(120.0/360.0,0.5,1),
		"standart": Color.from_hsv(240.0/360,0.5,1),
		"slow": Color.from_hsv(360.0/360.0,0.5,1)
	}

func init_font():
	var names = ["ALBA____","ELEPHNT","Marlboro","Sabandija"]
	dict.font = {}
	
	for name in names:
		dict.font[name] = DynamicFont.new()
		var path = "res://assets/fonts/"+name+".TTF"
		dict.font[name].font_data = load(path)
		dict.font[name].size = num.pas.label

func init_current():
	current.dot = null
	current.dancer = null
	current.pas = null

func _ready():
	init_dict()
	init_arr()
	init_num()
	init_node()
	init_scene()
	init_flag()
	init_vec()
	init_color()
	init_font()
	init_current()

func set_square_layer(layer_):
	if layer_ == null:
		var index = (arr.n.find(num.layer.square)+1)%arr.n.size()
		num.layer.square = arr.n[index]
	else:
		num.layer.square = layer_
	
	Global.obj.ballroom.update_dot_colors()
	Global.obj.ballroom.get_dots_by_pas()

func custom_log(value_,base_): 
	return log(value_)/log(base_)

func cross(x1_,y1_,x2_,y2_,x3_,y3_,x4_,y4_):
	var n = -1
	
	if y2_-y1_ != 0:
		var q = (x2_-x1_)/(y1_-y2_)
		var sn = (x3_-x4_)+(y3_-y4_)*q
		if !sn:
			return false
		var fn = (x3_-x1_)+(y3_-y1_)*q
		n = fn/sn
	else:
		if !(y3_-y4_):
			return false
		n = (y3_-y1_)/(y3_-y4_)
		
	var x = x3_+(x4_-x3_)*n
	var y = y3_+(y4_-y3_)*n
	
	var first = min(x1_,x2_) <= x && x <= max(x1_,x2_) && min(y1_,y2_) <= y && y <= max(y1_,y2_)
	var second = min(x3_,x4_) <= x && x <= max(x3_,x4_) && min(y3_,y4_) <= y && y <= max(y3_,y4_)
	return first && second

func get_random_element(arr_):
	rng.randomize()
	var index_r = rng.randi_range(0, arr_.size()-1)
	return arr_[index_r]

func spread(value_,n_):
	var arr_ = []
	
	for _i in n_:
		arr_.append(1)
	
	for _i in value_-n_:
		rng.randomize()
		var index_r = rng.randi_range(0, arr_.size()-1)
		arr_[index_r] += 1
	
	return arr_
