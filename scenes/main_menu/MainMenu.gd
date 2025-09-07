extends Control

func _on_new_game_pressed() -> void:
	get_node("/root/StoryManager").load_chapter(0)
	
func _on_continue_pressed() -> void:
	var save = SaveManager.load_game(0)
	if save.is_empty():
		print("Nenhum save encontrado.")
	else:
		# Carrega cena salva, exemplo:
		get_tree().change_scene_to_file(save["scene_path"])

func _on_quit_pressed() -> void:
	get_tree().quit()
