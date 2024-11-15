extends TextureRect

var dialogue = []
var bribe_num = 0
var current = 0
signal npc_dialogue_finished
signal npc_leave
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

func _process(_delta: float) -> void:
	if $Button.visible:
		$Button.grab_focus()

func show_dialogue(name, orig_dialogue, bribe):
	show()
	$Button.show()
	$Button.grab_focus()
	bribe_num = bribe
	dialogue = orig_dialogue.duplicate()

	$Name.text = "[center]" + name + "[/center]"
	$Text.text = dialogue[current]

var next_bribe = 0
var next_end = 0
func _on_button_button_up() -> void:
	if current < dialogue.size() - 1:
		current += 1
		if dialogue[current] == "":
			$Button.hide()
			npc_dialogue_finished.emit(0)
		elif dialogue[current] == "end":
			$Button.hide()
			npc_dialogue_finished.emit(0)
			next_end = 1
		else:
			$Text.text = dialogue[current]
			$Button.show()
	else:
		$Button.hide()
		if next_end == 1:
			npc_dialogue_finished.emit(1)
		else:
			npc_dialogue_finished.emit(0)
		if bribe_num > 0 and next_bribe == 0:
			dialogue.append("You sure? I'll make it worth your while.
							(Offers %d coins)" % bribe_num)
			next_bribe = 1

## Move forward a certain number of dialogue lines
## Calls _on_button_button_up() to use "end of dialogue" logic
func next_dialogue(step):
	current += step - 1
	_on_button_button_up()
