class_name TileBase
extends Node2D

var overseer = null
var grid = null
var hex = null

var tilename = ""
var lethal = false
var passable = false
var safe2spawn = false

func setup(_info):
	overseer = _info["overseer"]
	grid = _info["HEXgrid"]
	position = grid.squareToPosition(_info["coords"])
	$Label.set_text(grid.squareToHEX(_info["coords"]).toStr())
	
func assignHEX(_hex):
	hex = _hex

func _on_Tile_mouse_entered():
	overseer.add_to_hoverlist(self)

func _on_Tile_mouse_exited():
	overseer.remove_from_hoverlist(self)
