# dialogue_system.gd
extends CanvasLayer
class_name DialogueSystem

signal dialogue_started(session_id: String)
signal dialogue_ended(session_id: String)
signal line_displayed(text: String)

enum SkipMode {
	NONE,		# Nenhum skip
	LINE,		# Pular linha atual
	SESSION		# Pular sessão inteira
}

@export var text_speed: float = 0.02  # Segundos por caractere
@export var skip_key: String = "ui_accept"
@export var session_skip_key: String = "ui_cancel"

var current_session: Array = []
var current_line: int = -1
var is_typing: bool = false
var session_history: Dictionary = {}  # Para replay


func start_dialogue(session: Array, session_id: String = "") -> void:
	if not session.is_empty():
		current_session = session
		current_line = -1
		dialogue_started.emit(session_id)
		show()
		_next_line()


func _next_line() -> void:
	if is_typing:
		_complete_line()
		return
	
	current_line += 1
	
	if current_line >= current_session.size():
		end_dialogue()
		return
	
	_display_text(current_session[current_line])


func _display_text(text: String) -> void:
	is_typing = true
	$DialogueBox/Text.text = ""
	
	# Animação de digitação
	for i in range(text.length()):
		if not is_typing:  # Foi interrompido
			break
		$DialogueBox/Text.text += text[i]
		line_displayed.emit($DialogueBox/Text.text)
		await get_tree().create_timer(text_speed).timeout
	
	is_typing = false
	$DialogueBox/Arrow.show()


func _complete_line() -> void:
	$DialogueBox/Text.text = current_session[current_line]
	is_typing = false
	$DialogueBox/Arrow.show()


func end_dialogue() -> void:
	hide()
	dialogue_ended.emit(current_session[current_line])


func _input(event: InputEvent) -> void:
	if not visible:
		return
	
	# Avançar linha ou completar texto
	if event.is_action_pressed(skip_key):
		if is_typing:
			_complete_line()
		else:
			_next_line()
	
	# Pular sessão inteira
	if event.is_action_pressed(session_skip_key):
		end_dialogue()
	
	# Clique na tela
	if event is InputEventMouseButton and event.pressed:
		if is_typing:
			_complete_line()
		else:
			_next_line()


func replay_session(session_id: String) -> void:
	if session_history.has(session_id):
		start_dialogue(session_history[session_id], session_id)
