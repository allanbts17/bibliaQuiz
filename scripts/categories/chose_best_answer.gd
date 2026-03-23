extends Category

class_name ChoseBestOption

var options: Array = []
var answer_code: int
var answer_label: Variant
var time_left: int = 30

func _ready() -> void:
	default_time = 10
	time_left = default_time
	update_time_label()

func update_time_label() -> void:
	if has_node("VBoxContainer/TimeLabel"):
		$VBoxContainer/TimeLabel.text = str(time_left)

func _on_timer_timeout() -> void:
	if time_left > 0:
		time_left -= 1
		update_time_label()
		if time_left <= 0:
			on_failed()
			
func setup(_options: Array,
			_question: String,
			_dificulty: int,
			_max_points: int,
			_points_for_sucess: int,
			_default_question_points: int,
			_answer_code: int,
			_answer_label: Variant,
			_id: String,
			_category_name: String) -> void:
	options = _options
	question = _question
	dificulty = _dificulty
	max_points = _max_points
	points_for_sucess = _points_for_sucess
	default_question_points = _default_question_points
	answer_code = _answer_code
	answer_label = _answer_label
	id = _id
	category_name = _category_name
	
	
	$VBoxContainer/VBoxContainerButtons/HBoxContainer/opc1.text = str(GlobalData.normalize_number(options[0]))
	$VBoxContainer/VBoxContainerButtons/HBoxContainer/opc2.text = str(GlobalData.normalize_number(options[1]))
	$VBoxContainer/VBoxContainerButtons/HBoxContainer2/opc3.text = str(GlobalData.normalize_number(options[2]))
	$VBoxContainer/VBoxContainerButtons/HBoxContainer2/opc4.text = str(GlobalData.normalize_number(options[3]))
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
