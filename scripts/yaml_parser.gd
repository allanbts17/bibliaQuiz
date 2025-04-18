extends Node

class_name YamlParser
var result_obj = {}
var result_list = []
var aux_obj = {}
var next_level_key = ""
var in_array = false
var debug = true

func parse_yaml(path: String):
	if not FileAccess.file_exists(path):
		print("No se encontró el archivo YAML en:", path)
		return {}

	var file = FileAccess.open(path, FileAccess.READ)
	var yaml_text = file.get_as_text()
	file.close()
	var result_obj = process_yaml_lines(yaml_text)
	print()
	print()
	print()
	print(JSON.stringify(result_obj, "\t"))  # Imprime con indentación por tabs
	print()
	print(result_obj)

	
func format_text(text: String):
	if text.is_valid_int():
		return int(text)
	elif text.is_valid_float():
		return float(text)
	elif text == "null":
		return null
	elif text == "true":
		return true
	elif text == "false":
		return false
	else:
		return text
		
func detect(text: String, char: String) -> bool:
	return char in text
	
func remove_char(text: String, char: String):
	var index = text.find(char)
	if index != -1:
		text = text.substr(0, index) + text.substr(index + 1)
	return text
	
func handle_parameter_value(line):
	if line.split(":")[1].strip_edges() == "":
		next_level_key = line.split(":")[0].strip_edges()
		aux_obj[next_level_key] = ""
	else:
		result_obj[line.split(":")[0].strip_edges()] = format_text(line.split(":")[1].strip_edges())
		
# Mueve al personaje en una dirección específica.
# @param indentation int - Nivel de indentación en el yaml
func finish_add_next_indent(indentation: int):
	if next_level_key != "":
		result_obj[next_level_key] = process_yaml_lines(aux_obj[next_level_key],indentation + 1)
		print("Result in ",next_level_key)
		print(aux_obj)
		print(result_obj[next_level_key])
		
		next_level_key = ""
		aux_obj = {}
	
func debug_breaker(indentation: int, line: String):
	if indentation == 1 and line.contains(': Jesús'):
		print("test")
	if indentation == 2 and line.contains(': Jesús'):
		print("test")
	
func process_yaml_lines(yaml_text: String, indentation = 0) -> Variant:
	result_obj = {}
	result_list = []
	aux_obj = {}
	next_level_key = ""
	in_array = false
	var yaml_lines = yaml_text.split("\n")

	for line in yaml_lines:
		line = line.strip_edges(false)
		var line_showing_whitespaces = line.replace("\n", "\\n").replace("\t", "\\t").replace("\r", "\\r")
		var tabsCount = line.count('\t')
		

		# Manejar las lines con la indentación definida
		if indentation >= tabsCount:
			finish_add_next_indent(indentation)
			
			# Cuando se encuentra un ":" y no es de una lista
			if(":" in line and not line.strip_edges().begins_with("-")):
				# Cuando el parámetro tiene como valor un objeto o array
				handle_parameter_value(line)
					
			# Manejar arrays
			elif line.strip_edges().begins_with("-") and not ":" in line:
				result_list.append(line.split("-")[1].strip_edges())
				
			# Manejar arrays con objetos
			elif line.strip_edges().begins_with("-") and ":" in line:
				if result_obj.size() > 0:
					result_list.append(result_obj)
					result_obj = {}
				line = remove_char(line,"-")
				
				finish_add_next_indent(indentation+1)

				#result_obj[line.split(":")[0].strip_edges()] = format_text(line.split(":")[1].strip_edges())
				handle_parameter_value(line)
				in_array = true
				
		# Manejar parámetros dentro del objeto del array
		elif in_array and indentation + 1 == tabsCount:
			finish_add_next_indent(indentation+1)
			handle_parameter_value(line)
			print(next_level_key)
			#result_obj[line.split(":")[0].strip_edges()] = format_text(line.split(":")[1].strip_edges())
		else:
			# Reunir líneas con mayor indentación
			if next_level_key != "":
				if in_array and next_level_key == "challenges":
					print("En un array añadiendo",line)
				aux_obj[next_level_key] += line + '\n'
				
	if in_array and next_level_key == "challenges":
		#print("En un array añadiendo",line)
		print()
		print(yaml_text)
		print()
		print(result_list)
		print()
		print(result_obj)
		print()
		print(aux_obj)
	#if next_level_key != "":
		#var obj = finish_add_next_indent(next_level_key, in_array, result_obj, aux_obj, indentation)
		#aux_obj = obj["aux_obj"]
		#next_level_key = obj["next_level_key"]
		#print("Result after")
		#print(result_obj)
		
	if result_list.size() > 0:
		if result_obj.size() > 0:
			result_list.append(result_obj)
		return result_list
	elif in_array and result_obj.size() > 0 and not aux_obj.size():
		result_list.append(result_obj)
		return result_list
	#elif in_array and next_level_key != "" and aux_obj.size():
		#print("Aquiii")
		#return aux_obj
	else:
		return result_obj
