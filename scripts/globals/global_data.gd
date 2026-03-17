extends Node

var level = 1
var challenge = 0

func to_typed_string_array(arr: Array) -> Array[String]:
	var typed: Array[String] = []
	for item in arr:
		typed.append(item)
	return typed
