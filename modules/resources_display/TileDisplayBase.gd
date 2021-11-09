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
	$CoordLabel.set_text(hex.coords.toStr())
	return self

func _on_Tile_mouse_entered():
	pass
	#overseer.add_to_hoverlist(self)

func _on_Tile_mouse_exited():
	pass
	#overseer.remove_from_hoverlist(self)
