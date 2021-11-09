static func compare_with_array(c1, a1):
	return c1.q == a1[0] && c1.r == a1[1]

static func areEqual(c1:HexCoords, c2:HexCoords):
	return c1.q == c2.q && c1.r == c2.r

static func verifyDistance(c1:HexCoords, c2:HexCoords, dist:Array):
	return c1.q + dist[0] == c2.q && c1.r + dist[1] == c2.r
	
static func calculateDistance(c1:HexCoords, c2:HexCoords):
	return (abs(c1.q - c2.q) + abs(c1.q + c1.r - c2.q - c2.r) + abs(c1.r - c2.r)) / 2