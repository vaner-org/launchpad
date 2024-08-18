@tool
extends EditorPlugin

var editor_interface
var is_editor_focused = false
var button = JOY_BUTTON_GUIDE

func _enter_tree():
	editor_interface = get_editor_interface()
	print("Plugin activated")
	get_tree().get_root().connect("focus_entered", _on_editor_focus_entered)
	get_tree().get_root().connect("focus_exited", _on_editor_focus_exited)

func _exit_tree():
	print("Plugin deactivated")
	if get_tree() and get_tree().get_root():
		get_tree().get_root().disconnect("focus_entered", _on_editor_focus_entered)
		get_tree().get_root().disconnect("focus_exited", _on_editor_focus_exited)

func _input(event):
	if event is InputEventJoypadButton and event.pressed:
		if event.button_index == button:  # You can change this to any key
			if is_editor_focused:
				print("Launching game...")
				run_project()
			else:
				print("Exiting game...")
				quit_game()

func _on_editor_focus_entered():
	is_editor_focused = true

func _on_editor_focus_exited():
	is_editor_focused = false

func quit_game():
	if not Engine.is_editor_hint():
		get_tree().quit()
	else:
		editor_interface.stop_playing_scene()

func run_project():
	if editor_interface:
		editor_interface.play_main_scene()
	else:
		print("Editor interface not available")
