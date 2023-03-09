class_name Spells

enum { freeze_unit, untire_unit, create_unit, teleport_unit }
const spell_list = {
	freeze_unit			: "res://modules/data/spells/SpellFreeze.gd",
	untire_unit			: "res://modules/data/spells/SpellUntire.gd",
	create_unit			: "res://modules/data/spells/SpellCreateUnit.gd",
	teleport_unit		: "res://modules/data/spells/SpellTeleportUnit.gd"
	}

static func get_spell_list():
	return spell_list.values()
