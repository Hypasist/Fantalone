tool
class_name ObjectDisplayBase
extends Node2D

var logic = null
func assign_logic_scene(logic_scene):
	logic = logic_scene
	position = HexMath.hex_to_position(logic.get_hex().get_coords())

# --- COMMAND QUEUE HANDLING --- #
var _command_queue = []
var _comp_object = null
var _comp_method = null
var display_busy = false
var current_display_command = null

func is_display_busy():
	return (current_display_command != null)
func display_deletable():
	return display_busy == false and has_commands_queued() == false
func queue_command(display_command):
	_command_queue.push_back(display_command)
func has_commands_queued():
	return _command_queue.empty() == false
func execute_display_queue(comp_object, comp_method):
	_comp_object = comp_object
	_comp_method = comp_method
	execute_display_command()
func execute_display_command():
	current_display_command = _command_queue.pop_front()
	if current_display_command:
		var err = current_display_command.connect("command_completed", self, "execute_display_command")
		if err: breakpoint
		current_display_command.execute()
	else:
		current_display_command = null
		_comp_object.call(_comp_method)
func abort_display_queue():
	if is_display_busy():
		_command_queue.clear()
		current_display_command.abort()
		current_display_command = null
		_comp_object.call(_comp_method)

func set_select(value):
	if value:
		$Tile/Selected.show()
	else:
		$Tile/Selected.hide()

func _on_Object_mouse_entered():
	mod.GameUI.Hoverlist.add_to_hoverlist(logic)
func _on_Object_mouse_exited():
	mod.GameUI.Hoverlist.remove_from_hoverlist(logic)
