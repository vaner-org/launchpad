@tool
extends EditorPlugin

var is_editor_focused = false

# You can change this to any button
var button: JoyButton = JOY_BUTTON_GUIDE

func _enter_tree():
	is_editor_focused = true
	get_tree().get_root().connect("focus_entered", _on_editor_focus_entered)
	get_tree().get_root().connect("focus_exited", _on_editor_focus_exited)

func _exit_tree():
	if get_tree() and get_tree().get_root():
		get_tree().get_root().disconnect("focus_entered", _on_editor_focus_entered)
		get_tree().get_root().disconnect("focus_exited", _on_editor_focus_exited)

func _input(event):
	if event is InputEventJoypadButton and event.pressed and event.button_index == button:
		if is_editor_focused:
			if Engine.has_singleton("Launchpin"):
				Engine.get_singleton("Launchpin").run_scene()
			else:
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
		EditorInterface.stop_playing_scene()

func run_project():
	EditorInterface.play_main_scene()
