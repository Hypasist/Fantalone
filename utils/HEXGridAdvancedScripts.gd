
static func doHEXFormALine(HEXList:Array, startingHEX:HEX, searchDirections:Array):
	var returnValue = { "isLine" : false, "dir" : null }
	if HEXList.empty(): return returnValue
	
	for direction in searchDirections:
		var currentHEX = startingHEX
		var currentLineSize = 0
		while true:
			currentLineSize += 1
			if currentLineSize == HEXList.size():
				returnValue["isLine"] = true
				returnValue["dir"] = direction
				return true
			
			var expectedHEX = currentHEX.getNeighbour(direction)
			if HEXList.has(expectedHEX):
				currentHEX = expectedHEX
			else:
				break
	return returnValue

static func findBottomLeftHEX(HEXList:Array):
	if HEXList.empty(): return null
	var bottomLeftHEX = HEXList[0]
	
	for examinedHEX in HEXList:
		if examinedHEX.coords.r > bottomLeftHEX.coords.r:
			bottomLeftHEX = examinedHEX
		elif examinedHEX.coords.r == bottomLeftHEX.coords.r && \
			 examinedHEX.coords.q < bottomLeftHEX.coords.q:
			bottomLeftHEX = examinedHEX
	return bottomLeftHEX
