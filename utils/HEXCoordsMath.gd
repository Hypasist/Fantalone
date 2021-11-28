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