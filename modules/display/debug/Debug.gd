extends Control

func _process(_delta):
	var text = String(mod.MapView.scale) + "\n" + String(mod.MapView.position)
	$Current.set_text(text)
#	$Debug.set_text(str(Singletons.InputServant.get_longtap_time_left(), "  ", $InputServant/UserActionHandler.saved_action_info["current"]))
