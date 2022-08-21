extends UnitDisplayBase

var color = Color.white

func _init():
	pass

func assign_logic_scene(logic_scene):
	var match_player_info = mod.LobbyData.get_player_by_match_id(logic_scene.get_owner())
	if match_player_info:
		change_color(match_player_info.color)
	.assign_logic_scene(logic_scene)
	$NameLabel.set_text(unitLogic.get_name_id())
#	$Unit.setup_default_behaviour()
	return self

func set_tire(value):
	if value:
		$Tired.show()
	else:
		$Tired.hide()

func set_select(value):
	if value:
		$Selected.show()
		$Unit.set_modulate(color.lightened(0.5))
	else:
		$Selected.hide()
		$Unit.set_modulate(color)

func change_color(color_):
	color = color_
	$Unit.set_modulate(color)

func start_animation(animation_name, animation_type, comp_object, comp_method):
	$Unit.start_animation(animation_name, animation_type, comp_object, comp_method)
