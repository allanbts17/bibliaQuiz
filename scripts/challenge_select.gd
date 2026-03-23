class_name ChallengeSelect
extends Control


func _ready() -> void:
	var buttonContainer = $MarginContainer/VBoxContainer/HBoxContainer2
	#GameData.load_game()
	var level_data = GlobalData.level
	var categories: Array = GameData.data.categories
	var challenges: Array = level_data.challenges as Array
	var count = 0
	for ch in challenges:
		var button = Button.new()
		button.text = "Reto " + str(count+1)
		#button.size = Vector2(238,104)
		button.add_theme_font_size_override("font_size", 50)
		button.pressed.connect(_on_btn_pressed.bind(count))
		buttonContainer.add_child(button)
		count += 1
	
func _on_btn_pressed(challenge: int):
	GlobalData.challenge = challenge
	get_tree().change_scene_to_file("res://scenes/game.tscn")
