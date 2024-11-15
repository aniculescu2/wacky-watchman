extends Node

signal dialogue_started
signal dialogue_finished

@export_file("*.cfg") var dialogue_file: String
@export var npc_type: String
var dialogue_keys = []
var dialogue_name = ""
var current = 0
var dialogue_text = ""

## start_dialogue: Emits dialogue_started signal and returns first dialogue_text
func start_dialogue():
	dialogue_started.emit()
	current = 0
	var entry = load_dialogue()
	print(entry)
	dialogue_text = dialogue_keys[current].text
	dialogue_name = npc_type

## next_dialogue: goes to next dialogue or emits dialogue_finished if at end
func next_dialogue():
	current += 1
	if current == dialogue_keys.size():
		dialogue_finished.emit()
		return
	dialogue_text = dialogue_keys[current].text
	dialogue_name = dialogue_keys[current].name

## laod_dialogue: laods dialogue JSON file
func load_dialogue():
	print("npc_type ", npc_type)
	var dialogue = TextDatabase.new()
	dialogue.add_mandatory_property("dialog_1")
	dialogue.load_from_path(dialogue_file)
	for entry in dialogue.get_array():
		print(entry)
		if entry.name == npc_type:
			return entry
	return null
