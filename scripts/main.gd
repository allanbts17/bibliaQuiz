extends Node

const YAML_PATH = "res://data/challenges.yaml"

var yaml_data = {}
var parser = YamlParser.new()

func _ready():
	pass
	#parser.parse_yaml(YAML_PATH)
	#yaml_data = parse_yaml(YAML_PATH)
	#print(yaml_data)

# ------------------------------------------
# Cargar y Parsear YAML
# ------------------------------------------
func parse_yaml(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		print("No se encontró el archivo YAML en:", path)
		return {}

	var file = FileAccess.open(path, FileAccess.READ)
	var yaml_text = file.get_as_text()
	file.close()

	return process_yaml_lines(yaml_text)

# ------------------------------------------
# Procesar cada línea del YAML
# ------------------------------------------
func process_yaml_lines(yaml_text: String) -> Dictionary:
	var result = {}
	var stack = [result]
	var indent_levels = [0]
	var count = 0
	for line in yaml_text.split("\n"):
		count += 1
		print(count,line)
		line = line.rstrip(" \t\r\n")

		# Ignorar líneas vacías o comentarios
		if line == "" or line.begins_with("#"):
			continue

		var indent = line.length() - line.lstrip(" ").length()
		line = line.strip_edges()

		# Ajustar el stack según el nivel de indentación
		while indent < indent_levels[-1]:
			stack.pop_back()
			indent_levels.pop_back()

		# Detectar listas
		if line.begins_with("- "):
			var item = line.substr(2).strip_edges()
			var value = parse_value(item)

			if typeof(stack[-1]) != TYPE_ARRAY:
				stack[-1] = []
			stack[-1].append(value)

			# Si el elemento es un diccionario vacío, ajusta el stack
			if value is Dictionary:
				stack.append(value)
				indent_levels.append(indent)

		# Detectar claves y valores
		elif ":" in line:
			var parts = line.split(":", true, 1)
			var key = clean_string(parts[0])
			var value = clean_string(parts[1])

			# Si no tiene valor, es un diccionario anidado
			if value == "":
				stack[-1][key] = {}
				stack.append(stack[-1][key])
				indent_levels.append(indent)
			else:
				stack[-1][key] = parse_value(value)

	return result

# ------------------------------------------
# Limpiar y Procesar Valores Simples
# ------------------------------------------
func parse_value(value: String):
	value = clean_string(value)

	if value.is_valid_float():
		return float(value)
	elif value.is_valid_int():
		return int(value)
	elif value == "true":
		return true
	elif value == "false":
		return false
	elif value.begins_with("[") and value.ends_with("]"):
		return parse_list(value)
	else:
		return value

# ------------------------------------------
# Limpiar Comillas, Corchetes y Espacios
# ------------------------------------------
func clean_string(value: String) -> String:
	value = value.strip_edges()

	# Eliminar corchetes
	if value.begins_with("[") and value.ends_with("]"):
		value = value.substr(1, value.length() - 2).strip_edges()

	# Eliminar comillas dobles
	if value.begins_with("\"") and value.ends_with("\""):
		value = value.substr(1, value.length() - 2).strip_edges()

	return value

# ------------------------------------------
# Convertir una cadena en una lista de Godot
# ------------------------------------------
func parse_list(value: String) -> Array:
	value = value.strip_edges()

	# Eliminar corchetes si aún están presentes
	if value.begins_with("[") and value.ends_with("]"):
		value = value.substr(1, value.length() - 2).strip_edges()

	var items = value.split(",", true)
	var result = []

	for item in items:
		result.append(clean_string(item))

	return result
