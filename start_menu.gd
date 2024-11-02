extends CanvasLayer

# Signals 'Main' node that start button has been pressed
signal start_game
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HUD/StartButton.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_button_pressed() -> void:
	self.hide()
	start_game.emit()
