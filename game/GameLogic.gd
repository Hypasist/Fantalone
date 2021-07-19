extends Node

onready var worldmap = $"../Worldview/Worldmap"
onready var UI = $"UI"

var currently_selected_HEXES = []
func new_selected(new_actor:ActorBase):
	if new_actor.underControl == false: return
	
	# IF WASN'T SELECTED BEFORE -- SELECT AND CHECK
	if new_actor.selected == false:
		currently_selected_HEXES.append(new_actor.hex)
		if worldmap.grid.doHEXFormALine(currently_selected_HEXES)["isLine"]:
			for hex in currently_selected_HEXES:
				hex.actor.select()
		else:
			for hex in currently_selected_HEXES:
				hex.actor.deselect()
			currently_selected_HEXES.clear()
			currently_selected_HEXES.append(new_actor.hex)
			new_actor.select()
			
	# IF WAS SELECTED BEFORE -- DESELECT AND CHECK
	else:
		new_actor.deselect()
		currently_selected_HEXES.erase(new_actor.hex)
		if worldmap.grid.doHEXFormALine(currently_selected_HEXES)["isLine"] == false:
			for hex in currently_selected_HEXES:
				hex.actor.deselect()
			currently_selected_HEXES.clear()

func any_selected():
	return currently_selected_HEXES.empty() == false

func isMovementValid(direction):
	var lineResult = worldmap.grid.doHEXFormALine(currently_selected_HEXES)
	if !lineResult["isLine"]: return false
	
	var canPush = true if direction == lineResult["dir"] || \
		worldmap.grid.opp_dir[direction] == lineResult["dir"] else false
	
	if canPush:
		if isMovementValidConsideringTiles(direction):
			return true
	else:
		if isMovementValidConsideringTiles(direction):
			return true
		
		
func isMovementValidConsideringTiles(direction):
	for hex in currently_selected_HEXES:
		var destination = hex.getNeighbour(direction) 
		if (destination is TileBase) == false || \
			destination.passable == false:
			return true
	return false
	
func isMovementValidConsideringActors(direction):
	for hex in currently_selected_HEXES:
		var destination = hex.getNeighbour(direction) 
		if (destination is TileBase) == false || \
			destination.passable == false:
			return true
	return false