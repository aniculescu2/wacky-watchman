extends Node

signal dialogue_started
signal dialogue_finished

@export_file("*.json") var dialogue_file: String
var dialogue_keys = []
var dialogue_name = ""
var current = 0
var dialogue_text = ""

# start_dialogue: Emits dialogue_started signal and returns first dialogue_text
func start_dialogue():
	dialogue_started.emit()
	current = 0
	index_dialogue()
	dialogue_text = dialogue_keys[current].text
	dialogue_name = dialogue_keys[current].name

# next_dialogue: goes to next dialogue or emits dialogue_finished if at end
func next_dialogue():
	current += 1
	if current == dialogue_keys.size():
		dialogue_finished.emit()
		return
	dialogue_text = dialogue_keys[current].text
	dialogue_name = dialogue_keys[current].name

# index_dialogue: stores dialogue lines into dialogue_keys
func index_dialogue():
	var dialogue = load_dialogue(dialogue_file)
	dialogue_keys.clear()
	for key in dialogue:
		dialogue_keys.append(dialogue[key])

# laod_dialogue: laods dialogue JSON file
func load_dialogue(file_path):
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var test_json_conv = JSON.new()
		test_json_conv.parse(file.get_as_text())
		var dialogue = test_json_conv.get_data()
		return dialogue
