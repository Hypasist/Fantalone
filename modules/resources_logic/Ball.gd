extends UnitLogicBase

var _owner_id = null
var _selected = false
var _tired = false
var _power = 1

func _init(owner_id):
	_owner_id = owner_id

func select():
	if not _selected:
		unitDisplay.select()
		_selected = true
func deselect():
	if _selected:
		unitDisplay.deselect()
		_selected = false

func handle_command(command):
	match command.command:
		CommandInfo.unit_commands.unevaluated:
			Terminal.addLog("ERROR, unevaluated command executed!")
		CommandInfo.unit_commands.move_to_empty:
			move_to_hex(command.destination_hex)
			unitDisplay.move_to_hex(command.destination_hex)
		CommandInfo.unit_commands.move_and_push:
			move_to_hex(command.destination_hex)
			unitDisplay.push_to_hex(command.destination_hex)
		CommandInfo.unit_commands.move_and_die:
			move_to_hex(command.destination_hex)
			die()
			unitDisplay.suicide_to_hex(command.destination_hex)
		CommandInfo.unit_commands.get_pushed_to_empty:
			move_to_hex(command.destination_hex)
			unitDisplay.get_pushed_to_hex(command.destination_hex)
		CommandInfo.unit_commands.get_pushed_and_die:
			move_to_hex(command.destination_hex)
			die()
			unitDisplay.get_killed_to_hex(command.destination_hex)

func get_owner():
	return _owner_id
func get_power():
	return _power
func is_tired():
	return _tired
func is_selected():
	return _selected

