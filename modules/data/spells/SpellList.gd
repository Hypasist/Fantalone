class_name SpellList
extends Node


enum { freeze_unit, untire_unit, create_unit, teleport_unit }
var spell_list = {
	freeze_unit			: "res://modules/data/spells/SpellFreeze.gd",
	untire_unit			: "res://modules/data/spells/SpellUntire.gd",
	create_unit			: "res://modules/data/spells/SpellCreateUnit.gd",
	teleport_unit		: "res://modules/data/spells/SpellTeleportUnit.gd"
	}

func get_spell_list():
	return spell_list.values()
