@tool
extends EditorPlugin

var editor_interface
var is_editor_focused = false

# You can change this to any button
var button: JoyButton = JOY_BUTTON_GUIDE

func _enter_tree():
	editor_interface = get_editor_interface()
	if editor_interface:
		get_tree().get_root().connect("focus_entered", _on_editor_focus_entered)
		get_tree().get_root().connect("focus_exited", _on_editor_focus_exited)
		
		# Assume focus when project loaded
		is_editor_focused = true
	else:
		print("EditorInterface unavailable, cannot bind gamepad")

func _exit_tree():
	if get_tree() and get_tree().get_root():
		get_tree().get_root().disconnect("focus_entered", _on_editor_focus_entered)
		get_tree().get_root().disconnect("focus_exited", _on_editor_focus_exited)

func _input(event):
	if editor_interface:
		if event is InputEventJoypadButton and event.pressed and event.button_index == button:
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
	editor_interface.play_main_scene()
