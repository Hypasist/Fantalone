class_name LogSubCmdMoveAndPush
extends LogSubCmdBase

var destination_hex = null

func _init(param_dictionary).(param_dictionary):
	unit = param_dictionary["unit"]
	destination_hex = param_dictionary["destination"]
	Terminal.add_log(Debug.ALL, Debug.LOGIC_CMD, "[%s] New LogSubCmdMoveAndPush from %s to %s" % [unit.get_name_id(), unit.hex.coords.to_str(), destination_hex.coords.to_str()])


func execute():
	Terminal.add_log(Debug.ALL, Debug.LOGIC_CMD, "[%s] LogSubCmdMoveAndPush %s" % [unit.get_name_id(), unit.hex.coords.to_str()])
	
	unit.move_to_hex(destination_hex)
	DisCmdMoveToEmpty.new(unit)
	EffectTiredClass.new(caller, unit, 1).start_effect()
