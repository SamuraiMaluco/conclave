extends Node

# Estado atual da História
var current_chapter: int = 0
var current_step: int = 0
var story_data: Array = []

func load_chapter(chapter_id: int) -> void:
	var path = "res://story/chapter_%d.json" % chapter_id
	if not FileAccess.file_exists(path):
		push_error("Capítulo não encontrado: " + path)
		return
	
	var file = FileAccess.open(path, FileAccess.READ)
	var json = JSON.parse_string(file.get_as_text())
	file.close()
	
	if typeof(json) == TYPE_DICTIONARY and json.has("steps"):
		story_data = json["steps"]
		current_chapter = chapter_id
		current_step = 0
		run_step()
		
func run_step() -> void:
	if current_step >= story_data.size():
		print("Capítulo %d concluído" % current_chapter)
		return
			
	var step = story_data[current_step]
	match step["type"]:
		"dialogue":
			show_dialogue(step["text"])
		"collectible":
			give_item(step["item"])
		"event":
			trigger_event(step["action"]) 
	
func next_step() -> void:
	current_step += 1
	run_step()
	
func show_dialogue(text: String) -> void:
	print("Diálogo: " + text)

func give_item(item: String) -> void:
	print("Você coletou um item: " + item)

func trigger_event(action: String) -> void:
	print("Explore mais o ambiente: " + action)
				
