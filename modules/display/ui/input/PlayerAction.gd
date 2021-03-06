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
	var unit = mod.UI.get_hovered_unit()
	if unit:
		mod.LocalLogic.new_unit_selected(unit)

func action_longtap(_position):
	pass
	
func action_longtap_stopped():
	pass

var dragRelativeTreshold = 100
func action_drag(position, relative):
	if mod.LocalLogic.any_unit_selected() == false:
		mod.UI.arrow_clear_direction()
	elif relative.length() < dragRelativeTreshold:
		mod.UI.arrow_set_no_direction(position)
	else:
		var direction = touchscreenScripts.angleVector2direction(relative)
		if mod.LocalLogic.is_move_valid(direction):
			mod.UI.arrow_set_direction(position, direction)
		else:
			mod.UI.arrow_set_invalid(position)

func action_drag_stopped(position, relative):
	if mod.LocalLogic.any_unit_selected():
		if relative.length() < dragRelativeTreshold:
			mod.UI.arrow_set_no_direction(position)
		else:
			var direction = touchscreenScripts.angleVector2direction(relative)
			mod.LocalLogic.complete_movement(direction)
	mod.UI.arrow_clear_direction()

func action_cancel():
	pass # Replace with function body.
