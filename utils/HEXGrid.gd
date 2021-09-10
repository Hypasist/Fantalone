class_name HEXGrid

# CONSTs & SCRIPTs
var HC = HEXConstants
var HGAS = HEXGridAdvancedScripts
const HMath = preload("res://utils/HEXCoordsMath.gd")

# VARs
var contents = []
var cellSize : Vector2 = Vector2(0,0)

func _init(_cellSize):
	cellSize = _cellSize

func addHEX(coordsSquare:Vector2, object = null):
	var coordsHEX : HEXCoords = squareToHEX(coordsSquare)
	
	var newHEX = getHEX(coordsHEX)
	if newHEX: # already exists
		newHEX.assignObject(object)
	else: # create new
		newHEX = HEX.new(coordsHEX, object)
		findNeighbours(newHEX)
		contents.append(newHEX)

func findNeighbours(newHEX:HEX):
	for HEX in contents:
		for dir in HC.directions:
			if HMath.verifyDistance(newHEX.coords, HEX.coords, HC.directions[dir]):
				newHEX.neighbours[dir] = HEX
				HEX.neighbours[HC.opposite(dir)] = newHEX

func squareToHEX(coordsSquare:Vector2):
	var x:int = int(round(coordsSquare.x))
	var y:int = int(round(coordsSquare.y))
	var q:int = x - (y - (y%2)) / 2
	var r:int = y
	return HEXCoords.new(q, r)
	
func HEXToSquare(coordsHEX:HEXCoords):
	var x = coordsHEX.q + (coordsHEX.r - (coordsHEX.r%2)) / 2
	var y = coordsHEX.r
	return Vector2(x, y)
	
func HEXToPosition(coordsHEX:HEXCoords):
	var x = coordsHEX.q + (coordsHEX.r - (coordsHEX.r%2)) / 2
	var y = coordsHEX.r
	
	if y % 2:
		return cellSize * Vector2(x+1, y+0.5)
	else:
		return cellSize * Vector2(x+0.5, y+0.5)
	
	
func getHEX(coordsHEX:HEXCoords):
	for hex in contents:
		if HMath.areEqual(hex.coords, coordsHEX):
			return hex
	return null
	
func squareToPosition(coordsSquare):
	if int(round(coordsSquare.y)) % 2:
		return cellSize * (coordsSquare + Vector2(1,0.5))
	else:
		return cellSize * (coordsSquare + Vector2(0.5,0.5))

func doActorsFormALine(ActorList:Array):
	if ActorList.empty(): return { "isLine" : false }
	var HEXList = [];
	for actor in ActorList: HEXList.append(actor.hex)
	
	var startingHEX = HGAS.findMostExtendedHEX(HEXList, HC.BOTTOM_LEFT)
	var aLineResult = HGAS.doHEXFormALine(HEXList, startingHEX, [HC.TOP_LEFT, HC.TOP_RIGHT, HC.RIGHT])
	return { "isLine" : aLineResult["isLine"] }
	
func recognizeFormation(ActorList:Array, direction = HC.BOTTOM_LEFT):
	if ActorList.empty(): return
	var HEXList = [];
	for actor in ActorList: HEXList.append(actor.hex)
	
	var formationInfo = {
		"isLine" : false,
		"moveDirection" : direction,
		"lineDirection" : null,
		"canPush" : false,
		"frontHEX" : null,
		"strength" : HEXList.size(),
	}
	
	var frontHEX = HGAS.findMostExtendedHEX(HEXList, direction)
	formationInfo["frontHEX"] = frontHEX
	var searchDirection = [HC.getRelative(direction,2), HC.getRelative(direction,3), HC.getRelative(direction,4)] 
	var aLineResult = HGAS.doHEXFormALine(HEXList, frontHEX, searchDirection)
	formationInfo["isLine"] = aLineResult["isLine"]
	formationInfo["lineDirection"] = aLineResult["direction"]
	
	var isCorrelated = HC.areDirectionsCorrelated(direction, aLineResult["direction"])
	formationInfo["canPush"] = isCorrelated
	
	return formationInfo