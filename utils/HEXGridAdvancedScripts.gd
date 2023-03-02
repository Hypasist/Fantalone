
static func are_coords_in_line(list:Array, _direction):
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
			var distance = calculate_distance(ghost_coords, measurment_hex.coords)
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

			var coords = coord_sum(current_hex.coords, HEXConstants.directions[direction])
			current_hex = get_next_hex_in_line(hex_list, current_hex, direction)
			if current_hex:
				line_size += 1
				continue
			else:
				break
	return formation

static func get_next_hex_in_line(hex_list:Array, starting_hex, direction):
	var coords = coord_sum(starting_hex.coords, HEXConstants.directions[direction])
	for hex in hex_list:
		if are_equal(hex.coords, coords):
			return hex
	return null

## OLD HMATH
static func compare_with_array(c1, a1):
	return c1.q == a1[0] && c1.r == a1[1]

static func are_equal(c1:HexCoords, c2:HexCoords):
	return c1.q == c2.q && c1.r == c2.r

static func verify_distance(c1:HexCoords, c2:HexCoords, dist:Array):
	return c1.q + dist[0] == c2.q && c1.r + dist[1] == c2.r
	
static func calculate_distance(c1:HexCoords, c2:HexCoords):
	return (abs(c1.q - c2.q) + abs(c1.q + c1.r - c2.q - c2.r) + abs(c1.r - c2.r)) / 2

static func coord_sum(c1, c2):
	var tmp = null
	if c1 is Array: tmp = [c1[0], c1[1]]
	if c1 is HexCoords: tmp = [c1.q, c1.r]
	if c1 is Vector2: tmp = [c1.x, c1.y]
	if c2 is Array: tmp = [tmp[0] + c2[0], tmp[1] + c2[1]]
	if c2 is HexCoords: tmp = [tmp[0] + c2.q, tmp[1] + c2.r]
	if c2 is Vector2: tmp = [tmp[0] + c2.x, tmp[1] + c2.y]
	return HexCoords.new(tmp[0], tmp[1])
