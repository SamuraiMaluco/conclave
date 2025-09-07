extends Control
# Mostra/esconde o menu
func toggle_pause() -> void:
	if get_tree().paused:
		get_tree().paused = false
		hide()
	else:
		get_tree().paused = true
		show()

func _on_continue_pressed() -> void:
	get_tree().paused = false
	hide()

func _on_save_pressed() -> void:
	# Exemplo de dados para salvar, você pode puxar do StoryManager ou outro lugar
	var data := {
		"chapter": 1,
		"progress": 5,
		"inventory": ["chave", "mapa"]
	}
	SaveManager.save_game(1, data)
	print("Jogo salvo no pause menu!")

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
