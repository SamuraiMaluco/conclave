extends Area2D

func _ready():
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	connect("input_event", Callable(self, "_on_input_event"))

func _on_mouse_entered():
	get_tree().call_group("interaction_system", "on_hover_start", self)

func _on_mouse_exited():
	get_tree().call_group("interaction_system", "on_hover_end", self)

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_tree().call_group("interaction_system", "on_interact", self)
