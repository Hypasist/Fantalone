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
	Terminal.add_log(Debug.ALL, "MenuScreenBase setup requested, param %s" % setup_params)

func refresh(refresh_level):
	Terminal.add_log(Debug.ALL, "MenuScreenBase refresh requested, level %d" % refresh_level)
