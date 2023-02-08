class_name ControllerLogic
extends Node

static func identify_platform():
	match OS.get_name():
		"Android":
			return ControllerData.clients.mobile
		"Windows":
			return ControllerData.clients.desktop
		_:
			Terminal.add_log(Debug.ERROR, Debug.SYSTEM, "Cannot recognize OS: %s!" % [OS.get_name])
