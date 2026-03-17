extends MarginContainer

class_name Category

var id: String
var category_name: String
var default_time: int
var dificulty: int
var max_points: int
var points_for_sucess: int
var default_question_points: int
var question: String
var game_scene: Game

func on_success(points: int):
	game_scene.question_step(true,points,30)


func on_failed():
	game_scene.question_step(false,0,30)
