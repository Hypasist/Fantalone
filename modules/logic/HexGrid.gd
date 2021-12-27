extends Node

# CONSTs & SCRIPTs
const HGAS = preload("res://utils/HEXGridAdvancedScripts.gd")
const HC = preload("res://utils/HEXConstants.gd")
#const HMath = preload("res://utils/HEXCoordsMath.gd")

# VARs
var hex_list = []
var hex_coord_dict = {}

func get_hex_by_coords(coords):
	if not hex_coord_dict.has(coords.q):
		var new_hex = Hex.new(coords)
		hex_coord_dict[coords.q] = {}
		hex_coord_dict[coords.q][coords.r] = new_hex
		hex_list.append(new_hex)
	elif not hex_coord_dict[coords.q].has(coords.r):
		var new_hex = Hex.new(coords)
		hex_coord_dict[coords.q][coords.r] = new_hex
		hex_list.append(new_hex)
	return hex_coord_dict[coords.q][coords.r]

func xy_to_qr(xy_coords:Vector2):
	var x:int = int(round(xy_coords.x))
	var y:int = int(round(xy_coords.y))
	var q:int = x - (y - (y%2)) / 2
	var r:int = y
	return HexCoords.new(q, r)

func get_neighbour(hex, direction):
	var coords = HGAS.HMath.coord_sum(hex.coords, HC.directions[direction])
	return get_hex_by_coords(coords)

static func hex_to_position(coords):
	var x = coords.q + (coords.r - (coords.r%2)) / 2
	var y = coords.r
	if y % 2:
		return mod.Database.get_tilesize() * Vector2(x+1, y+0.5)
	else:
		return mod.Database.get_tilesize() * Vector2(x+0.5, y+0.5)
	

#func HEXToSquare(coordsHEX:HEXCoords):
#	var x = coordsHEX.q + (coordsHEX.r - (coordsHEX.r%2)) / 2
#	var y = coordsHEX.r
#	return Vector2(x, y)
#
#func squareToPosition(coordsSquare):
#	if int(round(coordsSquare.y)) % 2:
#		return cellSize * (coordsSquare + Vector2(1,0.5))
#	else:
#		return cellSize * (coordsSquare + Vector2(0.5,0.5))

#func coordsSquareToPosition(coordsSquare):
#	var tilePosition = Singletons.MapEditor.map_to_world(coordsSquare)
#	tilePosition += (Singletons.MapEditor.get_cell_size() / 2)
#	return tilePosition

