extends Node

# MAP HANDLERS
func handle_scroll(relative):
	mod.MapView.scroll(relative)

func handle_zoom(position, relative, is_step):
	mod.MapView.zoom(position, relative, is_step)

func handle_rotate():
	pass

# -------------------------------------

func action_shorttap(position):
#	for hovered_object in hoverlist:
#		if(hovered_object.is_in_group("Units")):
#			Singletons.Logic.new_selected(hovered_object)
#			return
	pass

func action_longtap(position):
	pass
	
func action_longtap_stopped():
	pass

var dragRelativeTreshold = 100
func action_drag(position, relative):
	if mod.Logic.any_unit_selected() == false: # TUTAJ SIE ZASTANOW, CZY TO TUTAJ NIE POWINIEN BYC CROSS
												# I CZY TO W OGOLE JEST POTRZEBNE
		mod.UI.arrow_clear_direction()
	elif relative.length() < dragRelativeTreshold:
		mod.UI.arrow_set_no_direction(position)
	else:
		var direction = touchscreenScripts.angleVector2direction(relative)
		if mod.Logic.is_move_valid(direction):
			mod.UI.arrow_set_direction(position, direction)
		else:
			mod.UI.arrow_set_invalid(position)

func action_drag_stopped(position, relative):
	if mod.Logic.any_unit_selected():
		if relative.length() < dragRelativeTreshold:
			mod.UI.arrow_set_no_direction(position)
		else:
			var direction = touchscreenScripts.angleVector2direction(relative)
			mod.Logic.execute_move(direction)
	mod.UI.arrow_clear_direction()

func action_cancel():
	pass # Replace with function body.