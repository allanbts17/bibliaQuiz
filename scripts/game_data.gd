extends Node

var save_path = "user://saves/game_data.cfg"  # Ruta segura en Android
var game_data = {
	"name":"Jugador",
	"points": 0,
	"range": "Discípulo",
	"achievements": [],
	"levels_passed": []
}
var challenges_data = {
	"levels":[],
	"categories":[]
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
	_get_challenges_data()
		
		
func _get_challenges_data():
	challenges_data = _load_json("res://data/challenges.json")
	
	
func _load_json(ruta: String) -> Variant:
	var archivo = FileAccess.open(ruta, FileAccess.READ)
	if archivo == null:
		print("No se pudo abrir el archivo: ", ruta)
		return null
	var contenido = archivo.get_as_text()
	archivo.close()
	var json = JSON.new()
	var resultado = json.parse(contenido)
	if resultado != OK:
		print("Error al parsear JSON: ", json.get_error_message())
		return null
	return json.data
