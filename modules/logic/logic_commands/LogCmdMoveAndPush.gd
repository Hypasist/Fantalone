class_name LogCmdMoveAndPush
extends LogCmdBase

var unit = null
var destination_hex = null

func _init(_caster, _unit, _destination_hex).(_caster, _unit):
	unit = _unit
	destination_hex = _destination_hex
	# Terminal.add_log(Debug.ALL, Debug.LOGIC_CMD, "[%s] New LogCmdMoveAndPush from %s to %s" % [unit.get_name_id(), unit.hex.coords.to_str(), destination_hex.coords.to_str()])

func execute():
	Terminal.add_log(Debug.ALL, Debug.LOGIC_CMD, "[%s] LogCmdMoveAndPush %s" % [unit.get_name_id(), unit.hex.coords.to_str()])
	
	unit.move_to_hex(destination_hex)
	DisCmdMoveToEmpty.new(unit)
	EffectTiredClass.new(caster, unit, 1).start_effect()
