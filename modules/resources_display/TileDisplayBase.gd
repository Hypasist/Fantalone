tool
class_name TileDisplayBase
extends Node2D

var tileLogic = null
func assign_logic_scene(logic):
	tileLogic = logic
	var hx = tileLogic.get_hex()
	var coords = hx.get_coords()
	position = mod.Logic.hex_to_position(coords)
	$CoordLabel.set_text(coords.to_str())

func has_queued_command():
	return false
func execute_display_queue(_comp_object_, _comp_method_):
	pass

func _on_Tile_mouse_entered():
	mod.UI.add_to_hoverlist(tileLogic)

func _on_Tile_mouse_exited():
	mod.UI.remove_from_hoverlist(tileLogic)
