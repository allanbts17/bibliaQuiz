extends Control
var challenge
var question
var category

var chose_best_option = preload("res://scenes/categories/elrc.tscn")

func _ready() -> void:
	var level_data = GameData.level_1
	challenge = level_data.challenges[0]
	question = challenge.questions[0]
	print(question.question)
	add_category_scene()
	#match level_data.
	
#func _process(delta: float) -> void:
	#pass
	
func add_category_scene():
	match question.categoria:
		"elrc":
			category = chose_best_option.instantiate()
	add_child(category)
		
	
	

	
