extends Node

const HGAS = preload("res://utils/HEXGridAdvancedScripts.gd")
const HC = preload("res://utils/HEXConstants.gd")

func recognize_line_unit(unit_list):
	var hex_list = []
	for unit in unit_list:
		hex_list.append(unit.hex)
	return mod.Logic.recognize_line_hex(hex_list)
	
func recognize_line_hex(hex_list:Array):
	var starting_hex = HGAS.find_most_extended_hex(hex_list, HC.BOTTOM_LEFT)
	var formation = HGAS.are_hexes_in_line(hex_list, starting_hex, [HC.TOP_LEFT, HC.TOP_RIGHT, HC.RIGHT])
	return formation
	
func recognize_formation_hex(hex_list:Array, move_direction = HC.BOTTOM_LEFT):
	var formation = recognize_line_hex(hex_list)
	formation.move_direction = move_direction
	formation.correlate_directions()
	return formation
	
func recognize_movement_unit(unit_list, direction):
	var hex_list = []
	for unit in unit_list:
		hex_list.append(unit.hex)
	return recognize_movement_hex(hex_list, direction)


func _evaluate_unit_command_move(movement, unit, destination_hex):
	if movement.get_owner() == unit.get_owner():
		movement.add_formation_power(unit.get_power())
		if destination_hex.is_taken():
			movement.add_command(LogCmdMoveAndPush.new(unit, destination_hex))
		elif destination_hex.is_lethal():
			movement.add_command(LogCmdMoveAndDie.new(unit, destination_hex))
		else:
			movement.add_command(LogCmdMoveToEmpty.new(unit, destination_hex))
	else:
		movement.add_opposed_power(unit.get_power())
		if destination_hex.is_lethal():
			movement.add_command(LogCmdGetPushedAndDie.new(unit, destination_hex))
		else:
			movement.add_command(LogCmdGetPushedToEmpty.new(unit, destination_hex))

func evaluate_unit_command(movement, unit):
	var current_hex = unit.hex
	var destination_hex = current_hex.get_neighbour(movement.get_direction())
	
	if destination_hex.get_tile() == null:
		Terminal.add_log(Debug.ERROR, Debug.MATCH, "Trying to reach beyond the map boundaries!")
		movement.invalid_move(movement.invalid.out_of_map_boundaries)
		
	elif destination_hex.is_passable() == false:
		movement.invalid_move(movement.invalid.unpassable_terrain)
		
	elif destination_hex.is_taken():
		var encountered_unit = destination_hex.get_unit()
		# PUSHING OWN UNIT
		if movement.get_owner() == encountered_unit.get_owner():
			# PUSHING OWN UNIT, BUT IT'S OK, COZ IT'S LEAVING (BELONGS TO FORMATION)
			if movement.does_belong(encountered_unit):
				_evaluate_unit_command_move(movement, unit, destination_hex)
			# PUSHING OWN UNIT, THAT DOESN'T BELONG TO FORMATION
			else:
				movement.invalid_move(movement.invalid.pushing_own_units)
		# PUSHING OTHER UNIT
		elif movement.is_pushing():
			movement.add_subject_to_evaluate(encountered_unit)
			_evaluate_unit_command_move(movement, unit, destination_hex)
		# MOVING TO TAKEN HEX, WHILE NOT PUSHING
		else:
			movement.invalid_move(movement.invalid.tile_occupied)
	else:
		# MOVING TO NON-TAKEN HEX
		_evaluate_unit_command_move(movement, unit, destination_hex)

func recognize_movement_hex(hex_list, direction):
	var formation = recognize_formation_hex(hex_list, direction)
	var movement = MovementInfo.new(formation)
	
	# START CHAIN-MOVEMENT
	while movement.is_valid():
		var subject = movement.get_subject_to_evaluate()
		if subject:
			if subject is UnitLogicBase:
				evaluate_unit_command(movement, subject)
		# NO COMMANDS LEFT TO EVALUATE
		elif movement.get_opposed_power() >= movement.get_formation_power(): 
			movement.invalid_move(movement.invalid.formation_too_weak)
		else:
			break
	return movement

func make_move_unit(unit_list, direction):
	var hex_list = []
	for unit in unit_list:
		hex_list.append(unit.hex)
	return make_move_hex(hex_list, direction)
	
func make_move_hex(hex_list, direction):
	var movement = recognize_movement_hex(hex_list, direction)
	execute_movement_commands(movement)
	return movement

func execute_movement_commands(movement:MovementInfo):
	if movement.is_valid() == false: return
	for command in movement.get_command_list():
		command.execute()


#func tireSelectedUnits():
#	for unit in selected_units:
#		unit.tire()
#func untireAllPlayerUnits(player_id):
#	for unit in Singletons.Logic.get_all_player_units(player_id):
#		unit.untire()

#func makeMove(moveInfo:Dictionary):
#	if moveInfo["isMoveValid"] == false: return
#
#	# find the most extended unit to the direction we move to
#	var frontHEX = Singletons.Worldmap.grid.HGAS.findMostExtendedHEX(moveInfo["affectedHEX"], moveInfo["moveDirection"])
#	while true:
#		var destinationHEX = frontHEX.getNeighbour(moveInfo["moveDirection"])
#		if destinationHEX.isLethal():
#			selected_units.erase(frontHEX.unit)
#			frontHEX.unit.free()
#		else:
#			frontHEX.unit.move(destinationHEX)
#		if moveInfo["affectedHEX"].has(frontHEX.getNeighbour(moveInfo["lineDirection"])):
#			frontHEX = frontHEX.getNeighbour(moveInfo["lineDirection"])
#		else:
#			break
#	Singletons.Logic.finishMove()
