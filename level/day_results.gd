extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


func show_results(num_accepted, num_rejected, gold):
	%AcceptedLabel.text = str(num_accepted)
	%RejectedLabel.text = str(num_rejected)
	%GoldLabel.text = str(gold)
	show()
	%Button.grab_focus()
	$AnimationPlayer.play("fade")


func _on_button_pressed() -> void:
	$AnimationPlayer.play_backwards("fade")
	hide()
