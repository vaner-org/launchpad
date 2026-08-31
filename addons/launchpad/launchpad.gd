@tool
extends EditorPlugin

var is_editor_focused = false

# You can change this to any button
var button: JoyButton = JOY_BUTTON_GUIDE
# Change this to disable running Launchpin scene
var use_launchpin: bool = true

var guide_pressed: bool = false
var guide_press_time: int = 0
var guide_cancelled: bool = false
const GUIDE_MAX_HOLD_MSEC: int = 500

func _enter_tree():
	is_editor_focused = true
	get_tree().get_root().connect("focus_entered", _on_editor_focus_entered)
	get_tree().get_root().connect("focus_exited", _on_editor_focus_exited)

func _exit_tree():
	if get_tree() and get_tree().get_root():
		get_tree().get_root().disconnect("focus_entered", _on_editor_focus_entered)
		get_tree().get_root().disconnect("focus_exited", _on_editor_focus_exited)

func _input(event):
	if not (event is InputEventJoypadButton):
		return

	# Track the guide button's own press/release
	if event.button_index == button:
		if event.is_pressed():
			guide_pressed = true
			guide_cancelled = false
			guide_press_time = Time.get_ticks_msec()
			return

		if event.is_released():
			if not guide_pressed:
				return

			var held_msec = Time.get_ticks_msec() - guide_press_time
			var was_cancelled = guide_cancelled

			# reset state for next press
			guide_pressed = false
			guide_cancelled = false

			if was_cancelled:
				return
			if held_msec >= GUIDE_MAX_HOLD_MSEC:
				return

			_do_guide_action()
		return

	# Any other JOY_BUTTON press while guide button is held down cancels it
	if guide_pressed and event.is_pressed():
		guide_cancelled = true

func _do_guide_action():
	if is_editor_focused:
		if use_launchpin and Engine.has_singleton("Launchpin"):
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
