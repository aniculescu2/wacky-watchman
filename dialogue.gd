extends TextureRect

var dialogue_node = null
var bribe_num = 0
signal npc_dialogue_finished
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

func show_dialogue(dialogue, npc_type, bribe):
	show()
	$Button.show()
	$Button.grab_focus()
	dialogue_node = dialogue
	bribe_num = bribe

	dialogue_node.dialogue_finished.connect(hide)
	dialogue_node.dialogue_finished.connect(_on_dialogue_finished)
	dialogue_node.start_dialogue()
	dialogue_node.dialogue_keys.append({"name": npc_type, "text": "May I enter the city?"})
	dialogue_node.dialogue_keys.append({"name": npc_type, "text": "You sure? I'll make it worth your while. (Offers %d coins)"})
	$Name.text = "[center]" + dialogue_node.dialogue_name + "[/center]"
	$Text.text = dialogue_node.dialogue_text

func _on_dialogue_finished():
	dialogue_node.dialogue_finished.disconnect(hide)
	dialogue_node.dialogue_finished.disconnect(_on_dialogue_finished)

func _on_button_button_up() -> void:
	dialogue_node.next_dialogue()
	$Text.text = dialogue_node.dialogue_text
	if dialogue_node.current >= dialogue_node.dialogue_keys.size() - 2:
		if dialogue_node.current >= dialogue_node.dialogue_keys.size() - 1:
			$Text.text = dialogue_node.dialogue_text % bribe_num
		$Button.hide()
		npc_dialogue_finished.emit()

## Move forward a certain number of dialogue lines
## Calls _on_button_button_up() to use "end of dialogue" logic
func next_dialog(step):
	for i in range(step-1):
		dialogue_node.next_dialogue()
	_on_button_button_up()
