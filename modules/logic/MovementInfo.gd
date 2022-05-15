class_name MovementInfo
extends FormationInfo
# TODO: movement info inherits after formation info
enum invalid { no_reason, out_of_map_boundaries, unpassable_terrain, pushing_own_units, formation_too_weak, tile_occupied, not_your_turn }
var invalid_reason = null
var valid = true
var command_list = []
var formation_power = 0
var opposed_power = 0

func _init(formation):
	copy(formation)
	for unit in unit_list:
		add_subject_to_evaluate(unit)
		
func invalid_move(reason):
	valid = false
	invalid_reason = reason
func is_valid():
	return valid
func does_belong(unit):
	return unit_list.has(unit)
func add_formation_power(power):
	formation_power += power
func add_opposed_power(power):
	opposed_power += power
func get_formation_power():
	return formation_power
func get_opposed_power():
	return opposed_power

func add_command(command):
	command_list.append(command)
func get_command_list():
	return command_list
func add_subject_to_evaluate(subject):
	command_list.append(LogCmdDummy.new(subject))
func get_subject_to_evaluate():
	for command in command_list:
		if command is LogCmdDummy:
			command_list.erase(command)
			return command.subject
	return null
