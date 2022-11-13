class_name Logic
extends Node

func get_hex_by_qr_coords(qr_coords):
	return $HexGrid.get_hex_by_coords(qr_coords)
func get_hex_by_xy_coords(xy_coords):
	var qr_coords = $HexGrid.xy_to_qr(xy_coords)
	return $HexGrid.get_hex_by_coords(qr_coords)
func get_neighbour_hex(hex, direction):
	return $HexGrid.get_neighbour(hex, direction)

func hex_to_position(coords:HexCoords):
	return $HexGrid.hex_to_position(coords)

func recognize_line_unit(unit_list):
	return $MovementLogic.recognize_line_unit(unit_list)
func recognize_line_hex(hex_list):
	return $MovementLogic.recognize_line_hex(hex_list)

func recognize_formation_unit(unit_list, direction):
	return $MovementLogic.recognize_formation_unit(unit_list, direction)
func recognize_formation_hex(hex_list, direction):
	return $MovementLogic.recognize_formation_hex(hex_list, direction)
