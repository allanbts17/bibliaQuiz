extends Category

class_name TrueOrFalse

var answer_code: bool
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
			
func setup(_question: String,
			_dificulty: int,
			_max_points: int,
			_points_for_sucess: int,
			_default_question_points: int,
			_answer_code: bool,
			_id: String,
			_category_name: String) -> void:
	question = _question
	dificulty = _dificulty
	max_points = _max_points
	points_for_sucess = _points_for_sucess
	default_question_points = _default_question_points
	answer_code = _answer_code
	id = _id
	category_name = _category_name
	$VBoxContainer/VBoxContainerQuestion/question.text = question
		
func _on_true_pressed() -> void:
	on_success(10)
	
func _on_false_pressed() -> void:
	on_failed()
