extends Node

const YAML_PATH = "res://data/challenges.yaml"

var yaml_data = {}

func _ready():
	GameData.load_game()
	print(GameData.level_1)
	# print(data["levels"][0])
	pass


func _on_options_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/options.tscn")


func _on_start_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levelSelect.tscn")
