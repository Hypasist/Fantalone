extends Node

# CONSTs & SCRIPTs
const HGAS = preload("res://utils/HEXGridAdvancedScripts.gd")
#var HC = HEXConstants
#const HMath = preload("res://utils/HEXCoordsMath.gd")

# VARs
var hex_list = []

func get_hex_by_coords(coords):
	var return_hex = null
	for hex in hex_list:
		if HGAS.HMath.compare_with_array(hex.coords, coords):
			return_hex = hex
	if not return_hex:
		return_hex = Hex.new(coords)
		hex_list.append(return_hex)
	return return_hex


#func findNeighbours(newHEX:HEX):
#	for HEX in contents:
#		for dir in HC.directions:
#			if HMath.verifyDistance(newHEX.coords, HEX.coords, HC.directions[dir]):
#				newHEX.neighbours[dir] = HEX
#				HEX.neighbours[HC.opposite(dir)] = newHEX

#func squareToHEX(coordsSquare:Vector2):
#	var x:int = int(round(coordsSquare.x))
#	var y:int = int(round(coordsSquare.y))
#	var q:int = x - (y - (y%2)) / 2
#	var r:int = y
#	return HEXCoords.new(q, r)
#
#func HEXToSquare(coordsHEX:HEXCoords):
#	var x = coordsHEX.q + (coordsHEX.r - (coordsHEX.r%2)) / 2
#	var y = coordsHEX.r
#	return Vector2(x, y)
#
#
static func hex_to_position(coords):
	var x = coords.q + (coords.r - (coords.r%2)) / 2
	var y = coords.r
	if y % 2:
		return mod.Database.get_tilesize() * Vector2(x+1, y+0.5)
	else:
		return mod.Database.get_tilesize() * Vector2(x+0.5, y+0.5)
	
	
#func getHEX(coordsHEX:HEXCoords):
#	for hex in contents:
#		if HMath.areEqual(hex.coords, coordsHEX):
#			return hex
#	return null
#
#func squareToPosition(coordsSquare):
#	if int(round(coordsSquare.y)) % 2:
#		return cellSize * (coordsSquare + Vector2(1,0.5))
#	else:
#		return cellSize * (coordsSquare + Vector2(0.5,0.5))
#
#func doUnitsFormALine(UnitList:Array):
#	if UnitList.empty(): return { "isLine" : false }
#	var HEXList = [];
#	for unit in UnitList: HEXList.append(unit.hex)
#
#	var startingHEX = HGAS.findMostExtendedHEX(HEXList, HC.BOTTOM_LEFT)
#	var aLineResult = HGAS.doHEXFormALine(HEXList, startingHEX, [HC.TOP_LEFT, HC.TOP_RIGHT, HC.RIGHT])
#	return { "isLine" : aLineResult["isLine"] }
##
#func recognizeFormation(UnitList:Array, direction = HC.BOTTOM_LEFT):
#	if UnitList.empty(): return
#	var HEXList = [];
#	for unit in UnitList: HEXList.append(unit.hex)
#
#	var formationInfo = {
#		"isLine" : false,
#		"moveDirection" : direction,
#		"lineDirection" : null,
#		"canPush" : false,
#		"frontHEX" : null,
#		"strength" : HEXList.size(),
#	}
#
#	var frontHEX = HGAS.findMostExtendedHEX(HEXList, direction)
#	formationInfo["frontHEX"] = frontHEX
#	var searchDirection = [HC.getRelative(direction,2), HC.getRelative(direction,3), HC.getRelative(direction,4)] 
#	var aLineResult = HGAS.(HEXList, frontHEX, searchDirection)
#	formationInfo["isLine"] = aLineResult["isLine"]
#	formationInfo["lineDirection"] = aLineResult["direction"]
#
#	var isCorrelated = HC.areDirectionsCorrelated(direction, aLineResult["direction"])
#	formationInfo["canPush"] = isCorrelated
#
#	return formationInfo