extends Control

var map_control_enabled = false
func lock_map_control():
	map_control_enabled = false
func unlock_map_control():
	map_control_enabled = true

# ARROW HANDLE
func arrow_clear_direction():
	$MovementArrow.clear_direction()
func arrow_set_no_direction(position):
	$MovementArrow.set_no_direction_arrow(position)
func arrow_set_invalid(position):
	$MovementArrow.set_invalid_arrow(position)
func arrow_set_direction(position, direction):
	$MovementArrow.set_direction_arrow(position, direction)