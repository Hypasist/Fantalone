extends Node

# MAP HANDLERS
func action_scroll(relative):
	mod.MapView.scroll(relative)

func action_zoom(position, relative, is_step):
	mod.MapView.zoom(position, relative, is_step)

func action_rotate():
	pass

# -------------------------------------

func action_shorttap(_position):
	mod.GameUI.ActionHandle.shorttap_handle()

func action_longtap(_position):
	pass
	
func action_longtap_stopped():
	pass

var drag_relative_treshold = 100
func action_drag(position, relative):
	if mod.ControllerData.any_unit_selected() == false:
		mod.GameUI.MovementArrow.clear_direction()
	elif relative.length() < drag_relative_treshold:
		mod.GameUI.MovementArrow.set_no_direction(position)
	else:
		var direction = TouchscreenScripts.angleVector2direction(relative)
		if mod.ControllerData.is_selected_move_valid(direction):
			mod.GameUI.MovementArrow.set_direction(position, direction)
		else:
			mod.GameUI.MovementArrow.set_invalid(position)

func action_drag_stopped(position, relative):
	if mod.ControllerData.any_unit_selected():
		if relative.length() < drag_relative_treshold:
			mod.GameUI.MovementArrow.set_no_direction(position)
		else:
			var direction = TouchscreenScripts.angleVector2direction(relative)
			mod.ControllerData.complete_movement(direction)
	mod.GameUI.MovementArrow.clear_direction()

func action_cancel():
	pass # Replace with function body.
