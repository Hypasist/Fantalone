class_name HEXCoordsMath

static func areEqual(c1:HEXCoords, c2:HEXCoords):
	return c1.q == c2.q && c1.r == c2.r

static func verifyDistance(c1:HEXCoords, c2:HEXCoords, dist:Array):
	return c1.q + dist[0] == c2.q && c1.r + dist[1] == c2.r
	
static func calculateDistance(c1:HEXCoords, c2:HEXCoords):
	return (abs(c1.q - c2.q) + abs(c1.q + c1.r - c2.q - c2.r) + abs(c1.r - c2.r)) / 2