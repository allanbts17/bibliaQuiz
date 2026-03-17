extends Category

class_name ChoseBestOption

var options: Array[String] = []
var answer_code: int
var answer_label: String

func _ready() -> void:
	id = "elrc"
	category_name = "Escoger la respuesta correcta"
	default_time = 30

func setup(_options: Array[String], _question: String, _dificulty: int,
					_max_points: int, _points_for_sucess: int, _default_question_points: int,
					_answer_code: int, _answer_label: String) -> void:
	options = _options
	question = _question
	dificulty = _dificulty
	max_points = _max_points
	points_for_sucess = _points_for_sucess
	default_question_points = _default_question_points
	answer_code = _answer_code
	answer_label = _answer_label
	
	
	$VBoxContainer/VBoxContainerButtons/HBoxContainer/opc1.text = options[0]
	$VBoxContainer/VBoxContainerButtons/HBoxContainer/opc2.text = options[1]
	$VBoxContainer/VBoxContainerButtons/HBoxContainer2/opc3.text = options[2]
	$VBoxContainer/VBoxContainerButtons/HBoxContainer2/opc4.text = options[3]
	$VBoxContainer/VBoxContainerQuestion/question.text = question

func common_pressed(code: int):
	if answer_code == code:
		on_success(10)
	else:
		on_failed()
		
func _on_opc_1_pressed() -> void:
	common_pressed(0)
	
func _on_opc_2_pressed() -> void:
	common_pressed(1)
	
func _on_opc_3_pressed() -> void:
	common_pressed(2)

func _on_opc_4_pressed() -> void:
	common_pressed(3)
