class_name Game
extends Control
var challenge
var question
var category
var question_index = 0
var challenge_index = 0

var chose_best_option = preload("res://scenes/categories/elrc.tscn")

func _ready() -> void:
	var level_data = GameData.level_1
	challenge = level_data.challenges[0]
	question = challenge.questions[0]
	update_challenge()

	
#func _process(delta: float) -> void:
	#pass
func update_challenge():
	var level_data = GameData.level_1
	challenge = level_data.challenges[challenge_index]
	question = challenge.questions[question_index]
	add_category_scene()
	question_index += 1
	
func add_category_scene():
	match question.category:
		"elrc":
			category = chose_best_option.instantiate()
			print(question)
			category.game_scene = self
			category.setup(
				GlobalData.to_typed_string_array(question.options),
				question.question,
				challenge.dificulty,
				challenge.max_points,
				challenge.points_for_success,
				challenge.default_question_points,
				question.answer_code,
				question.answer_label
			)
	add_child(category)
		
func question_step(success: bool, points: int, time: int):
	print("stepped",success,points)
	if success:
		category.queue_free()
		update_challenge()
	

	

	
