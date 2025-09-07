extends Node

var save_path := "user://save_" # PREFIXO DO ARQUIVO
var save_extensions := ".json"

func get_save_file(slot: int) -> String:
	return save_path + str(slot) + save_extensions

func save_game(slot: int, data: Dictionary) -> void:
	var file = FileAccess.open(get_save_file(slot), FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()
		print("Salvo com sucesso no slot ", slot)

func load_game(slot: int) -> Dictionary:
	var path = get_save_file(slot)
	if not FileAccess.file_exists(path):
		return {}
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		file.close()
		
		var json = JSON.new()
		var error = json.parse(content)
		if error == OK:
			return json.get_data()
	return {}

func delete_save(slot:int) -> void:
	var path = get_save_file(slot)
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)
		print("Save do slot ", slot, " deletado.")
