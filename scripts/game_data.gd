extends Node

var save_path = "user://game_data.cfg"  # Ruta segura en Android
var game_data = {
	"name":"Jugador",
	"points": 0,
	"range": "Discípulo",
	"achievements": [],
	"levels_passed": []
}

var config = ConfigFile.new()

func save_game():
	config.set_value("player", "name", game_data["name"])
	config.set_value("player", "points", game_data["points"])
	config.set_value("player", "range", game_data["range"])
	config.set_value("player", "achievements", game_data["achievements"])
	config.set_value("player", "levels_passed", game_data["levels_passed"])
	config.save(save_path)
	print("Progreso guardado en", save_path)

func load_game():
	if config.load(save_path) == OK:
		for key in config.get_section_keys("player"):
			game_data[key] = config.get_value("player",key)
		print("Progreso cargado exitosamente.")
	else:
		print("No se encontró archivo de guardado. Se usará el progreso por defecto.")
