class_name LogSubCmdBase
extends LogCmdBase

var unit = null
func get_unit():
	return unit

func _init(param_dictionary={"unit":null}).():
	unit = param_dictionary["unit"]
