extends Node

func get_hex_by_coords(coords):
	return $HexGrid.get_hex_by_coords(coords)

func hex_to_position(coords:HexCoords):
	return $HexGrid.hex_to_position(coords)

func any_unit_selected():
	return true
	
func considerMoving(direction):
	pass
func is_move_valid(direction):
	pass