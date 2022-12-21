extends Node2D



func set_color(color_):
	var sprite = get_node("Sprite")
	sprite.modulate = color_

func set_healt(dancer):
	var label = get_node("LabelHealth")
	label.text = str(dancer.obj.feature.dict["health"].current)
	var bar = get_node("BarHealth")
	bar.value = float(dancer.obj.feature.dict["health"].current)/dancer.obj.feature.dict["health"].max*bar.max_value
