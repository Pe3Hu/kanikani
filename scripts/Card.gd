extends MarginContainer


var obj = {}

func _ready():
	pass 

func set_name(pas_):
	var label = get_node("Bars/TopBar/Name/CenterContainer/Label")
	label.text = pas_.word.chesspiece
	obj.pas = pas_

func _on_TextureButton_pressed():
	Global.obj.easel.obj.current.pas = obj.pas
	Global.obj.ballroom.get_dots_by_pas()
	Global.obj.ballroom.obj.current.dot = null
