class_name FormationInfo
 
var unit_list = []
var line = false
var move_direction = null
var line_direction = null
var correlated_directions = false
var owner_id = null

func get_pusher():
	return unit_list.back()
func is_line():
	return line
func is_pushing():
	return correlated_directions
func get_owner():
	return owner_id
func get_unit_list():
	return unit_list
func add_hex_list(hex_list):
	for hex in hex_list:
		unit_list.append(hex.get_unit())
func get_direction():
	return move_direction
func correlate_directions():
	if move_direction == line_direction:
		correlated_directions = true
	elif (move_direction % 3) == (line_direction % 3):
		correlated_directions = true
		var tmp_list = []
		for unit in unit_list:
			tmp_list.push_front(unit)
		unit_list = tmp_list
	else:
		correlated_directions = false
func conclude_ownership():
	owner_id = null if unit_list.empty() else unit_list.front().get_owner()
	for unit in unit_list:
		if owner_id != unit.get_owner():
			Terminal.addLog("ERROR, formation units ownership mismatch!")

func copy(other):
	unit_list = other.unit_list
	line = other.line
	move_direction = other.move_direction
	line_direction = other.line_direction
	correlated_directions = other.correlated_directions
	owner_id = other.owner_id