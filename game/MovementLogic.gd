extends Node

enum invalidReason { no_reason, unpassable_terrain, pushing_own_units, formation_too_weak, tile_occupied }

var selected_units = []
func new_selected(new_unit:UnitBase):
	if Singletons.Logic.get_current_turn_owner() != new_unit.ownerId: return
	if new_unit.tired: return
	
	# IF WASN'T SELECTED BEFORE -- SELECT AND CHECK
	if new_unit.selected == false:
		selected_units.append(new_unit)
		
		# CHECK IF NEW UNIT MATCHES A LINE
		if lineCheck() == false:
			selected_units.clear()
			selected_units.append(new_unit)
			new_unit.select()
			
	# IF WAS SELECTED BEFORE -- DESELECT AND CHECK
	else:
		new_unit.deselect()
		selected_units.erase(new_unit)
		if lineCheck() == false:
			selected_units.clear()

# if they don't form a line -- deselect all
func lineCheck():
	if Singletons.Worldmap.grid.doUnitsFormALine(selected_units)["isLine"]:
		for unit in selected_units:
			unit.select()
		return true
	else:
		for unit in selected_units:
			unit.deselect()
		return false

func tireSelectedUnits():
	for unit in selected_units:
		unit.tire()

func untireAllPlayerUnits(player_id):
	for unit in Singletons.Logic.get_all_player_units(player_id):
		unit.untire()

func deselectAllUnits():
	for unit in selected_units:
		unit.deselect()
	selected_units.clear()

func any_selected():
	return selected_units.empty() == false

func isMovementValid(moveInfo:Dictionary):
	moveInfo["isMoveValid"] = false
	moveInfo["invalidReason"] = invalidReason.no_reason
	moveInfo["affectedHEX"] = [];
	for unit in selected_units: moveInfo["affectedHEX"].append(unit.hex)
	
	if moveInfo["canPush"]:
		# we are moving forward!
		var pushingHEX = moveInfo["frontHEX"]
		var pushedHEX = pushingHEX.getNeighbour(moveInfo["moveDirection"])
		var opposingStrength = 0
		while true:
			if pushedHEX.isPassable() == false:
				moveInfo["invalidReason"] = invalidReason.unpassable_terrain; return
			# PROP BLOCKING MOVEMENT GOES HERE
			# HEIGHT CONSIDERATIONS GO HERE
			if pushedHEX.isTaken():
				moveInfo["affectedHEX"].append(pushedHEX)
				if pushedHEX.getOwner() == moveInfo["frontHEX"].getOwner():
					moveInfo["invalidReason"] = invalidReason.pushing_own_units; return
				opposingStrength += 1
				if opposingStrength >= moveInfo["strength"]: 
					moveInfo["invalidReason"] = invalidReason.formation_too_weak; return
			else:
				if opposingStrength < moveInfo["strength"]: break
			
			pushingHEX = pushedHEX
			pushedHEX = pushingHEX.getNeighbour(moveInfo["moveDirection"])
			
	else:
		# we are moving to the side!
		for unit in selected_units:
			var destinationHEX = unit.hex.getNeighbour(moveInfo["moveDirection"])
			if destinationHEX.isPassable() == false: 
				moveInfo["invalidReason"] = invalidReason.unpassable_terrain; return
			# PROP BLOCKING MOVEMENT GOES HERE
			# HEIGHT CONSIDERATIONS GO HERE
			if destinationHEX.isTaken(): 
				moveInfo["invalidReason"] = invalidReason.tile_occupied; return
			
	moveInfo["isMoveValid"] = true

func evaluateFate(moveInfo:Dictionary):
	pass	

func considerMoving(direction):
	if !any_selected(): return { "isMoveValid" : false }
	
	var moveInfo = Singletons.Worldmap.grid.recognizeFormation(selected_units, direction)
	isMovementValid(moveInfo)
	evaluateFate(moveInfo)
	return moveInfo
	
# INFORMING THE PLAYER ABOUT THE MOVE RESULTS:
# 	IF VALID:
#   	- the *destination* tile should have a color (OR ONLY BLUE??) of the incoming HEX
#		- if the *destination* tile is a lethal hex, present a skull
#	IF INVALID:
#		IF NO_REASON:
#			assert?
#		IF UNPASSABLE TERRAIN:
#			red cage on the unpassable terrain?, blue tile on any affected?
#		IF PUSHING OWN UNITS:
#			red cage on mentioned own unit, blue tile under any affected
#		IF FORMATION TOO WEAK:
#			RED CAGE on first invalid enemy hex, rest with blue tile under
#		IF TILE OCCUPIED:
#			red cage on tiles uccupied, blue tiles under own hexes

func makeMove(moveInfo:Dictionary):
	if moveInfo["isMoveValid"] == false: return
	
	# find the most extended unit to the direction we move to
	var frontHEX = Singletons.Worldmap.grid.HGAS.findMostExtendedHEX(moveInfo["affectedHEX"], moveInfo["moveDirection"])
	while true:
		var destinationHEX = frontHEX.getNeighbour(moveInfo["moveDirection"])
		if destinationHEX.isLethal():
			selected_units.erase(frontHEX.unit)
			frontHEX.unit.free()
		else:
			frontHEX.unit.move(destinationHEX)
		
		if moveInfo["affectedHEX"].has(frontHEX.getNeighbour(moveInfo["lineDirection"])):
			frontHEX = frontHEX.getNeighbour(moveInfo["lineDirection"])
		else:
			break
			
	Singletons.Logic.finishMove()
	
# isLine
# isMoveValid
# invalidReason
# affectedHEX
# moveDirection
# lineDirection
# strength
# frontHEX
# canPush