# res://scripts/interaction_system.gd
extends Node

# Sinal
signal object_interacted(target_node: Node)


func _ready() -> void:
	print("Interaction System pronto.")
	# Conectamos o sinal ao StoryManager (assumindo que ele é um Autoload)
	if StoryManager:
		object_interacted.connect(StoryManager.on_object_interacted)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos := get_viewport().get_mouse_position()
		
		var world_2d = get_viewport().world_2d
		if not world_2d:
			return
		var space_state :World2D = world_2d.direct_space_state

		var params := PhysicsPointQueryParameters2D.new()
		params.position = mouse_pos
		params.collide_with_areas = true
		params.collide_with_bodies = true
		
		var results: Array = space_state.intersect_point(params, 8)
		if results.size() > 0:
			for r in results:
				var collider = r.collider
				if collider.is_in_group("interactable"):
					# A MÁGICA ACONTECE AQUI!
					# Emitimos o sinal e enviamos o objeto que foi clicado.
					object_interacted.emit(collider)
					
					# Saímos da função, pois já encontramos o que queríamos.
					return
