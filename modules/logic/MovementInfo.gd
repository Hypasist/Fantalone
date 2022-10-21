class_name MovementInfo
extends FormationInfo

var error_info = null
var command_list = []
var formation_power = 0
var opposed_power = 0

func _init(formation):
	error_info = ErrorInfo.new()
	if formation:
		copy(formation)
	for unit in unit_list:
		add_subject_to_evaluate(unit)

func invalid_move(reason):
	error_info.invalid_move(reason)
func is_valid():
	return error_info.is_valid()
func get_invalid_string():
	return error_info.get_invalid_string()

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
