extends Area2D

@export var item_id: String = ""
var collected: bool = false

func _ready():
	connect("input_event", Callable(self, "_on_input_event"))

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not collected:
			collected = true
			get_tree().call_group("interaction_system", "on_collectible_found", item_id)
			queue_free()
