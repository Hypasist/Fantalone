class_name HEXGridAdvancedScripts
const HMath = preload("res://utils/HEXCoordsMath.gd")

static func doHEXFormALine(HEXList:Array, startingHEX:HEX, searchDirections:Array):
	var returnValue = { "isLine" : false, "direction" : null }
	if HEXList.empty(): return returnValue
	
	for direction in searchDirections:
		var currentHEX = startingHEX
		var currentLineSize = 0
		while true:
			currentLineSize += 1
			if currentLineSize == HEXList.size():
				returnValue["isLine"] = true
				returnValue["direction"] = direction
				return returnValue
			
			var expectedHEX = currentHEX.getNeighbour(direction)
			if HEXList.has(expectedHEX):
				currentHEX = expectedHEX
			else:
				break
	
	return returnValue

static func findMostExtendedHEX(HEXList:Array, direction):
	if HEXList.empty(): return null
	var mostExtendedHEX = null
	var maxDistance = 0
	var vector = HEXConstants.directions[direction]
	
	for candidateHEX in HEXList:
		var ghostHEX = candidateHEX.getNeighbour(direction)
		for measurmentHEX in HEXList:
			var distance = HMath.calculateDistance(ghostHEX.coords, measurmentHEX.coords)
			if distance > maxDistance:
				maxDistance = distance
				mostExtendedHEX = candidateHEX
				
	return mostExtendedHEX