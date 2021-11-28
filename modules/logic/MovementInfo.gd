class_name MovementInfo
extends FormationInfo
# TODO: movement info inherits after formation info
enum invalid { no_reason, unpassable_terrain, pushing_own_units, formation_too_weak, tile_occupied }
var invalid_reason = null
var valid = true
var command_list = []
var formation_power = 0
var opposed_power = 0

func _init(formation):
	copy(formation)
	for unit in unit_list:
		add_dummy_command(unit)
		
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

func add_dummy_command(unit):
	command_list.append(CommandInfo.new(unit, null, CommandInfo.unit_commands.unevaluated))
func get_command_list():
	return command_list
func get_unevaluated_command():
	for command in command_list:
		if command.command == CommandInfo.unit_commands.unevaluated:
			return command
	return null