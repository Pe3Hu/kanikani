extends Node


func _ready(): 
	Global.dict.exam = {}
	Global.dict.exam.description = {
		"exam_0": {
			"examinee": {
				"main": "max health",
				"secondary": ""
			},
			"challenge": {
				"convergence": true,
				"aim": true,
				"hitch": 0,
				"rest": 0,#3
				"preparation": 1,
				"type": "claim 0",
			},
			"zone": {
				"type": "homing",
				"vector": Vector2(0,0),
				"distance": Vector2(2,20),
			},
			"penalty": {
				"effect": "instantaneous",
				"type": "fixed value",
				"value": 10,
			}
		},
		"exam_1000": {
			"examinee": {
				"main": "max health",
				"secondary": "all"
			},
			"challenge": {
				"convergence": false,
				"aim": false,
				"hitch": 0,
				"rest": 2,
				"preparation": 3,
				"type": "outside",
			},
			"zone": {
				"type": "circle",
				"vector": Vector2(Global.num.ballroom.a,0),
				"distance": Vector2(0,22),
			},
			"penalty": {
				"effect": "instantaneous",
				"type": "max percent",
				"value": 25,
			}
		}
	}
