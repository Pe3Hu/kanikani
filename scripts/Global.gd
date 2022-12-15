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

func init_num():
	init_primary_key()
	
	num.ballroom = {}
	num.ballroom.n = 10
	num.ballroom.cols = num.ballroom.n
	num.ballroom.rows = num.ballroom.n
	num.ballroom.half = min(num.ballroom.cols,num.ballroom.rows)/2
	num.ballroom.l = min(dict.window_size.width,dict.window_size.height)*0.9
	num.ballroom.a = num.ballroom.l/min(num.ballroom.cols,num.ballroom.rows)
	num.ballroom.width = 1
	
	num.dot = {}
	num.dot.a = num.ballroom.a/3
	
	num.dancer = {}
	num.dancer.a = num.ballroom.a/6
	
	num.layer = {}
	num.layer.square = arr.n[2]

func init_primary_key():
	num.primary_key = {}
	num.primary_key.null = 0

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

func init_node():
	node.TimeBar = get_node("/root/Game/TimeBar") 
	node.Game = get_node("/root/Game") 

func init_flag():
	flag.click = false
	flag.stop = false

func init_vec():
	vec.ballroom = dict.window_size.center-Vector2(num.ballroom.cols,num.ballroom.rows)*num.ballroom.a/2

func init_color():
	color.essence = {
		"Aqua": Color.from_hsv(230.0/360.0,1,1),
		"Wind": Color.from_hsv(150.0/360.0,0.8,1),
		"Fire": Color.from_hsv(0.0/360.0,1,1),
		"Earth": Color.from_hsv(60.0/360.0,1,1),
		"Ice": Color.from_hsv(185.0/360.0,1,1),
		"Storm": Color.from_hsv(270.0/360.0,1,1),
		"Lava": Color.from_hsv(300.0/360.0,0.8,1),
		"Plant": Color.from_hsv(120.0/360.0,1,0.6)
	}
	color.region = {
		"North": Color.from_hsv(185.0/360.0,1,1),
		"East": Color.from_hsv(60.0/360.0,1,1),
		"South": Color.from_hsv(230.0/360.0,1,1),
		"West": Color.from_hsv(0.0/360.0,1,1),
		"Center": Color.from_hsv(120.0/360.0,1,0.6)
	}

func _ready():
	init_dict()
	init_arr()
	init_num()
	init_node()
	init_flag()
	init_vec()
	init_color()

func next_square_layer():
	var index = (arr.n.find(num.layer.square)+1)%arr.n.size()
	num.layer.square = arr.n[index]

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
