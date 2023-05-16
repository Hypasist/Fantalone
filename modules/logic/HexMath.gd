class_name HexMath
extends Node

# CONSTs & SCRIPTs
const HGAS = preload("res://utils/HEXGridAdvancedScripts.gd")

# VARs
static func get_hex_by_qr_coords(hex_dictionary, coords):
	if not hex_dictionary.has(coords.q):
		var new_hex = Hex.new(coords)
		hex_dictionary[coords.q] = {}
		hex_dictionary[coords.q][coords.r] = new_hex
	elif not hex_dictionary[coords.q].has(coords.r):
		var new_hex = Hex.new(coords)
		hex_dictionary[coords.q][coords.r] = new_hex
	return hex_dictionary[coords.q][coords.r]

static func get_hex_by_xy_coords(hex_dictionary, xy_coords):
	var qr_coords = xy_to_qr(xy_coords)
	return get_hex_by_qr_coords(hex_dictionary, qr_coords)

static func xy_to_qr(xy_coords:Vector2):
	var x:int = int(round(xy_coords.x))
	var y:int = int(round(xy_coords.y))
	var q:int = x - (y - (y%2)) / 2
	var r:int = y
	return HexCoords.new(q, r)

static func qr_to_xy(qr_coords:HexCoords):
	var q:int = int(round(qr_coords.q))
	var r:int = int(round(qr_coords.r))
	var x:int = q + (r - (r%2)) / 2
	var y:int = r
	return Vector2(x, y)

static func get_neighbour_hex(hex_dictionary, hex, direction):
	var coords = HGAS.coord_sum(hex.coords, HEXConstants.directions[direction])
	return get_hex_by_qr_coords(hex_dictionary, coords)

static func hex_to_position(coords):
	var x = coords.q + (coords.r - (coords.r%2)) / 2
	var y = coords.r
	if y % 2:
		return mod.Graphics.get_tilesize() * Vector2(x+1, y+0.5)
	else:
		return mod.Graphics.get_tilesize() * Vector2(x+0.5, y+0.5)


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

