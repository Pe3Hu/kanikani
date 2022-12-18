extends Node


class Pas:
	var word = {}
	var arr = {}
	var obj = {}
	var color = {}
	var node = {}

	func _init(input_):
		word.chesspiece = input_.chesspiece
		obj.easel = input_.easel
		arr.vertex = []
		color.background = Color.gray
		
		for square in Global.arr.square:
			var vertex = Global.vec.pas.size/2*square
			arr.vertex.append(vertex)
		
		node.label = Label.new()
		node.label.rect_position = Vector2(0,0)
		node.label.text = word.chesspiece
		#node.label.align = "Center"
		node.label.add_font_override("font", Global.dict.font["Sabandija"])
		Global.node.Game.get_node("Easel/Labels").add_child(node.label)

class Easel:
	var num = {}
	var arr = {}
	var vec = {}
	var flag = {}
	var dict = {}
	var obj = {}
	var color = {}

	func _init():
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
		
		arr.hand.append_array(arr.pas)
		#apply_chesspiece()

	func apply_chesspiece():
		var dancer = dict.troupe["mob"].arr.dancer.front()
		var pas = arr.pas.front()
		arr.option = []
