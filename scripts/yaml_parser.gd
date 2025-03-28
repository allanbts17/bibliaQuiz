extends Node

class_name YamlParser

func parse_yaml(path: String):
	if not FileAccess.file_exists(path):
		print("No se encontró el archivo YAML en:", path)
		return {}

	var file = FileAccess.open(path, FileAccess.READ)
	var yaml_text = file.get_as_text()
	file.close()
	var result = process_yaml_lines(yaml_text)
	print()
	print()
	print()
	print(JSON.stringify(result, "\t"))  # Imprime con indentación por tabs
	print()
	print(result)

	
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
	
func handle_parameter_value(line,next_level_key,result,aux):
	if line.split(":")[1].strip_edges() == "":
		next_level_key = line.split(":")[0].strip_edges()
		aux[next_level_key] = ""
		#prints(next_level_key)
	else:
		result[line.split(":")[0].strip_edges()] = format_text(line.split(":")[1].strip_edges())
	return next_level_key

func finish_add_next_indent(next_level_key,in_array,result,aux,indentation):
	if next_level_key != "":
		result[next_level_key] = process_yaml_lines(aux[next_level_key],indentation + 1)
		print("Result in ",next_level_key)
		print(aux)
		print(result[next_level_key])
		
		next_level_key = ""
		aux = {}
	return { "aux": aux, "next_level_key":next_level_key }
	
func process_yaml_lines(yaml_text: String, indentation = 0) -> Variant:
	var result = {}
	var list = []
	var aux = {}
	var next_level_key = ""
	var in_array = false
	#print()
	#print("RAW input text:",indentation,",",yaml_text.split("\n")[0].count('\t'))
	#print(yaml_text)
	#print("END of RAW text")
	for line in yaml_text.split("\n"):
		line = line.strip_edges(false)
		var newline = line.replace("\n", "\\n").replace("\t", "\\t").replace("\r", "\\r")
		var tabsCount = line.count('\t')
		#print(line.count('\t'),newline)
		
		if indentation == 1 and line.contains(': Jesús'):
			print("test")
		if indentation == 2 and line.contains(': Jesús'):
			print("test")
		# Manejar las lines con la indentación definida
		if indentation >= tabsCount:
			# Recursividad para las lineas con mayor indentación
			var obj = finish_add_next_indent(next_level_key,in_array,result,aux,indentation)
			aux = obj["aux"]
			next_level_key = obj["next_level_key"]
			
			# Cuando se encuentra un ":" y no es de una lista
			if(":" in line and not line.strip_edges().begins_with("-")):
				# Cuando el parámetro tiene como valor un objeto o array
				next_level_key = handle_parameter_value(line,next_level_key,result,aux)
					
			# Manejar arrays
			elif line.strip_edges().begins_with("-") and not ":" in line:
				list.append(line.split("-")[1].strip_edges())
				
			# Manejar arrays con objetos
			elif line.strip_edges().begins_with("-") and ":" in line:
				if result.size() > 0:
					list.append(result)
					result = {}
				line = remove_char(line,"-")
				
				var obj1 = finish_add_next_indent(next_level_key,in_array,result,aux,indentation+1)
				aux = obj1["aux"]
				next_level_key = obj1["next_level_key"]
				#result[line.split(":")[0].strip_edges()] = format_text(line.split(":")[1].strip_edges())
				next_level_key = handle_parameter_value(line,next_level_key,result,aux)
				in_array = true
				
		# Manejar parámetros dentro del objeto del array
		elif in_array and indentation + 1 == tabsCount:
			var obj = finish_add_next_indent(next_level_key,in_array,result,aux,indentation+1)
			aux = obj["aux"]
			next_level_key = obj["next_level_key"]
			next_level_key = handle_parameter_value(line,next_level_key,result,aux)
			print(next_level_key)
			#result[line.split(":")[0].strip_edges()] = format_text(line.split(":")[1].strip_edges())
		else:
			# Reunir líneas con mayor indentación
			if next_level_key != "":
				if in_array and next_level_key == "challenges":
					print("En un array añadiendo",line)
				aux[next_level_key] += line + '\n'
				
	if in_array and next_level_key == "challenges":
		#print("En un array añadiendo",line)
		print()
		print(yaml_text)
		print()
		print(list)
		print()
		print(result)
		print()
		print(aux)
	#if next_level_key != "":
		#var obj = finish_add_next_indent(next_level_key, in_array, result, aux, indentation)
		#aux = obj["aux"]
		#next_level_key = obj["next_level_key"]
		#print("Result after")
		#print(result)
		
	if list.size() > 0:
		if result.size() > 0:
			list.append(result)
		return list
	elif in_array and result.size() > 0 and not aux.size():
		list.append(result)
		return list
	#elif in_array and next_level_key != "" and aux.size():
		#print("Aquiii")
		#return aux
	else:
		return result
