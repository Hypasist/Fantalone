class_name IcecubeDisplay
extends UnitDisplayBase

func _init():
	pass

func assign_logic_scene(logic_scene):
	var match_player_info = mod.ClientData.LobbyData.get_player_by_match_id(logic_scene.get_owner())
	.assign_logic_scene(logic_scene)
	$NameLabel.set_text(logic_scene.get_name_id())
	return self

func set_tire(value):
	pass

func set_select(value):
	pass

func set_freeze(value):
	pass

func change_color(color_):
	pass

func start_animation(animation_name, animation_type, comp_object, comp_method):
	$Unit.start_animation(animation_name, animation_type, comp_object, comp_method)
