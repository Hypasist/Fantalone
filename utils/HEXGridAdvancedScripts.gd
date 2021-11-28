const HMath = preload("res://utils/HEXCoordsMath.gd")
const HC = preload("res://utils/HEXConstants.gd")

static func are_coords_in_line(list:Array, direction):
	for starting_coord in list:
		for tested_coord in  list:
			if starting_coord == tested_coord: continue
			
static func find_most_extended_hex(hex_list:Array, direction):
	if hex_list.empty(): return null
	var most_extended_hex = null
	var max_distance = 0
	var vector = HEXConstants.directions[direction]

	# TODO -- WRITE THIS W/O THIS STRANGE GHOST MECHANISM
	for candidate_hex in hex_list:
		var ghost_coords = HexCoords.new(vector[0], vector[1]).add(candidate_hex.coords)
		for measurment_hex in hex_list:
			var distance = HMath.calculate_distance(ghost_coords, measurment_hex.coords)
			if distance > max_distance:
				max_distance = distance
				most_extended_hex = candidate_hex
	return most_extended_hex

static func are_hexes_in_line(hex_list:Array, starting_hex, search_directions:Array):
	var formation = FormationInfo.new()
	if hex_list.empty() or starting_hex == null: return formation

	for direction in search_directions:
		var current_hex = starting_hex
		var line_size = 1
		while true:
			if line_size == hex_list.size():
				formation.line = true
				formation.line_direction = direction
				formation.add_hex_list(hex_list)
				formation.conclude_ownership()
				return formation

			current_hex = current_hex.get_neighbour(direction)
			if hex_list.has(current_hex):
				line_size += 1
				continue
			else:
				break
	return formation
