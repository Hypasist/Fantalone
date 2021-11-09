class_name MenuScreenBase
extends Control

signal screen_resolved(returnPackage)

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