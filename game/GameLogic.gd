extends Node

onready var worldmap = $"../Worldview/Worldmap"
onready var UI = $"UI"

var currently_selected_HEXES = []
func new_selected(new_actor:ActorBase):
	if new_actor.underControl == false: return
	
	# IF WASN'T SELECTED BEFORE -- SELECT AND CHECK
	if new_actor.selected == false:
		currently_selected_HEXES.append(new_actor.hex)
		
		# CHECK IF NEW ACTOR MATCHES A LINE
		if worldmap.grid.recognizeFormation(currently_selected_HEXES)["isLine"]:
			for hex in currently_selected_HEXES:
				hex.actor.select()
		else:
		# DESELECT ALL, AND SELECT NEW ACTOR ONLY
			for hex in currently_selected_HEXES:
				hex.actor.deselect()
			currently_selected_HEXES.clear()
			currently_selected_HEXES.append(new_actor.hex)
			new_actor.select()
			
	# IF WAS SELECTED BEFORE -- DESELECT AND CHECK
	else:
		new_actor.deselect()
		currently_selected_HEXES.erase(new_actor.hex)
		if worldmap.grid.recognizeFormation(currently_selected_HEXES)["isLine"] == false:
			for hex in currently_selected_HEXES:
				hex.actor.deselect()
			currently_selected_HEXES.clear()

func any_selected():
	return currently_selected_HEXES.empty() == false

func isMovementValidConsideringActors(moveInfo):
	var direction = moveInfo["moveDirection"]
	if moveInfo["isCorrelated"]:
		# WE NEED TO CHECK IF THE PATH IS PUSHABLE
		var currentHEX = moveInfo["frontHEX"]
		var enemyStrength = 0
		while true:
			currentHEX = currentHEX.getNeighbour(direction)
			# CHECK IF TRYING TO PUSH OWN UNIT
			if currentHEX && currentHEX.actor && currentHEX.actor.underControl:
				return false
			
			# CHECK IF ENEMY'S TOO STRONG
			if currentHEX && currentHEX.actor && currentHEX.actor.underControl == false:
				enemyStrength += 1
			
			if enemyStrength >= moveInfo["strength"]:
				return false
				
			if currentHEX && currentHEX.actor == null:
				break
	else:
		# WE JUST NEED TO CHECK IF THE IS A SPACE ON SIDE
		for hex in currently_selected_HEXES:
			var destination = hex.getNeighbour(direction) 
			if destination == null || destination.tile == null || \
				destination.tile.passable == false:
				return false
	
	return true

func isMovementValid(moveInfo:Dictionary):
	moveInfo["isMoveValid"] = false
	var direction = moveInfo["moveDirection"]
	
	for currentHEX in currently_selected_HEXES:
		var destinationHEX = currentHEX.getNeighbour(direction)
		
		if destinationHEX.tile.passable == false: return
		# PROP BLOCKING MOVEMENT GOES HERE
		# HEIGHT CONSIDERATIONS GO HERE
		#if destina
		
		if (destination == null || destination.tile == null \
		 || destination.tile.passable == false):
			return false
	return true

func considerMoving(direction):
	if !any_selected(): return { "isMoveValid" : false }
	return { "isMoveValid" : true }
	var moveInfo = worldmap.grid.recognizeFormation(currently_selected_HEXES, direction)

	isMovementValid(moveInfo)

	return moveInfo

