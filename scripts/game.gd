class_name Game
extends Control
var challenge
var question
var category
var question_index = 0
var challenge_index = 1

var chose_best_option = preload("res://scenes/categories/chose_best_answer.tscn")
var true_or_false = preload("res://scenes/categories/true_or_false.tscn")

func _ready() -> void:
	var level_data = GlobalData.level
	var categories: Array = GameData.data.categories
	challenge = level_data.challenges[GlobalData.challenge]
	question = challenge.questions[0]
	update_challenge()
	
#func _process(delta: float) -> void:
	#pass
func update_challenge():
	var level_data = GameData.level_1
	challenge = level_data.challenges[GlobalData.challenge]
	question = challenge.questions[question_index]
	add_category_scene()
	question_index += 1
	
func add_category_scene():
	match question.category:
		"elrc","qd","elcc","elp","qs":
			category = chose_best_option.instantiate() as ChoseBestOption
			category.game_scene = self
			category.setup(
				question.options,
				question.question,
				challenge.dificulty,
				challenge.max_points,
				challenge.points_for_success,
				challenge.default_question_points,
				question.answer_code,
				question.answer_label,
				GlobalData.get_category_by_id(question.category).id,
				GlobalData.get_category_by_id(question.category).name
			)
		"vof":
			category = true_or_false.instantiate() as TrueOrFalse
			category.game_scene = self
			category.setup(
				question.question,
				challenge.dificulty,
				challenge.max_points,
				challenge.points_for_success,
				challenge.default_question_points,
				question.answer_code,
				GlobalData.get_category_by_id(question.category).id,
				GlobalData.get_category_by_id(question.category).name
			)
	add_child(category)
		
func question_step(success: bool, points: int, time: int):
	print("stepped",success,points)
	if success:
		category.queue_free()
		update_challenge()
	

	

	
