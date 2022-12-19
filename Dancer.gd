extends Area2D


var obj = {}

func _ready():
	pass 

func set_color(color_):
	var sprite = get_node("Sprite")
	sprite.modulate = color_

func rotate(angle_):
	rotation_degrees = 180/PI*angle_
