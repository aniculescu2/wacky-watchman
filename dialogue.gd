extends TextureRect

var dialogue_node = null
signal dialogue_finished
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

func show_dialogue(dialogue):
	show()
	$Button.show()
	$Button.grab_focus()
	dialogue_node = dialogue

	#dialogue_node.dialogue_started.connect(self.set_active.bind(false))
	#dialogue_node.dialogue_finished.connect(self.set_active.bind(true))
	dialogue_node.dialogue_finished.connect(hide)
	dialogue_node.dialogue_finished.connect(_on_dialogue_finished)
	dialogue_node.start_dialogue()
	#$Name.text = "[center]" + dialogue_node.dialogue_name + "[/center]"
	$Text.text = dialogue_node.dialogue_text

func _on_dialogue_finished():
	#dialogue_node.dialogue_started.disconnect(player.set_active)
	#dialogue_node.dialogue_finished.disconnect(player.set_active)
	dialogue_node.dialogue_finished.disconnect(hide)
	dialogue_node.dialogue_finished.disconnect(_on_dialogue_finished)

func _on_button_button_up() -> void:
	dialogue_node.next_dialogue()
	$Text.text = dialogue_node.dialogue_text
	if dialogue_node.current == dialogue_node.dialogue_keys.size() - 1:
		$Button.hide()
		dialogue_finished.emit()
