extends Node

var level
var challenge = 0

func to_typed_string_array(arr: Array) -> Array[String]:
	var typed: Array[String] = []
	for item in arr:
		typed.append(item)
	return typed

func get_category_by_id(id: String):
	var result = GameData.data.categories.filter(func(c): return c["id"] == id)
	return result[0]
	
func normalize_number(value):
	match typeof(value):
		TYPE_FLOAT:
			if is_equal_approx(value, int(value)):
				return int(value)
			return value

		TYPE_STRING:
			return value
		_:
			return value
