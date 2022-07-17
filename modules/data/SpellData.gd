class_name SpellData
extends Node


enum { freeze_unit, untire_unit, create_unit, teleport_unit }
var spell_list = {
	freeze_unit			: "res://modules/data/spells/Freeze.gd",
	untire_unit			: "res://modules/data/spells/Untire.gd",
	create_unit			: "res://modules/data/spells/CreateUnit.gd",
	teleport_unit		: "res://modules/data/spells/TeleportUnit.gd"
	}

func get_spell_list():
	return spell_list.values()
