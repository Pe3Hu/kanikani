extends Node


func _ready(): 
	Global.dict.exam = {}
	Global.dict.exam.description = {
		"exam_0": {
			"examinees": {
				"target": "boss"
			},
			"challenge": {
				"delay": 1,
				"type": "claim 0",
			},
			"zone": {
				"type": "homing",
				"target": "max health",
				"vector": Vector2(0,0),
				"min distance": 2,
				"max distance": 20,
			},
			"penalty": {
				"effect": "instantaneous",
				"type": "fixed value",
				"value": 10,
			}
		},
		"exam_1000": {
			"examinees": {
				"target": "all"
			},
			"challenge": {
				"delay": 3,
				"type": "outside",
			},
			"zone": {
				"type": "circle",
				"target": "max health",
				"vector": Vector2(Global.num.ballroom.a,0),
				"min distance": 0,
				"max distance": 22,
			},
			"penalty": {
				"effect": "instantaneous",
				"type": "max percent",
				"value": 25,
			}
		}
	}
