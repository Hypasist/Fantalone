tool
class_name TileDisplayBase
extends Node2D

var tileLogic = null
var hex = null

func setup(logic, hex_):
	mod.MapView.add_tile_resource(self)
	tileLogic = logic
	hex = hex_
	position = mod.Logic.hex_to_position(hex.coords)
	$CoordLabel.set_text(hex.coords.to_str())
	return self

func has_queued_command():
	return false
func execute_display_queue(comp_object_, comp_method_):
	pass

func _on_Tile_mouse_entered():
	mod.UI.add_to_hoverlist(tileLogic)

func _on_Tile_mouse_exited():
	mod.UI.remove_from_hoverlist(tileLogic)
