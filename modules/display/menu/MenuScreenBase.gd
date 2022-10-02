class_name MenuScreenBase
extends Control

signal screen_resolved(return_package)

var dataPackage = {
	"command" : null,
	"package" : null,
	"screenPath" : null
}

func resolve_screen(command, package, screenPath):
	dataPackage["command"] = command
	dataPackage["package"] = package
	dataPackage["screenPath"] = screenPath
	emit_signal("screen_resolved", dataPackage)

func setup(setup_params):
	Terminal.add_log(Debug.ALL, Debug.MENUS, "MenuScreenBase setup requested, param %s" % setup_params)
	_hookup_network_signals()

func _hookup_network_signals():
	Terminal.add_log(Debug.ALL, Debug.MENUS, "MenuScreenBase _hookup_network_signals requested")

func refresh(refresh_level):
	Terminal.add_log(Debug.ALL, Debug.MENUS, "MenuScreenBase refresh requested, level %d" % refresh_level)
