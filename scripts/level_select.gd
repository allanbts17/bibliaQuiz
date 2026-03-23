extends Control


func _on_return_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_leve_1_btn_pressed() -> void:
	GlobalData.level = GameData.level_1
	get_tree().change_scene_to_file("res://scenes/challengeSelect.tscn")
