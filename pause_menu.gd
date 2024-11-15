extends Panel

@onready var _resume_button := $VBoxContainer/ResumeButton
@onready var _quit_button := $VBoxContainer/QuitButton
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

func open():
	show()
	_resume_button.grab_focus()

func close():
	hide()
	get_tree().paused = false


func _on_resume_button_button_up() -> void:
	close()


func _on_quit_button_button_up() -> void:
	if visible:
		get_tree().quit()


func _on_menu_button_button_up() -> void:
	close()
	get_tree().reload_current_scene()
