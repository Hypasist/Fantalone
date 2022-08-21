tool
class_name TileDisplayBase
extends ObjectDisplayBase

func assign_logic_scene(logic_scene):
	.assign_logic_scene(logic_scene)
	$CoordLabel.set_text(logic.get_hex().get_coords().to_str())

func execute_display_queue(_comp_object_, _comp_method_):
	pass

func set_select(value):
	if value:
		$Tile/Selected.show()
	else:
		$Tile/Selected.hide()
	
