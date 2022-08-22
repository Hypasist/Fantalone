extends Node

func new_tile_selected(tile):
	current_spell.new_selected(tile)

func new_unit_selected(unit):
	current_spell.new_selected(unit)

var current_spell = null
func load_spell(spell_info):
	current_spell = spell_info
func unload_spell():
	clear_selections()
	current_spell = null
func get_spell():
	return current_spell

func cast_spell():
	current_spell.cast()

func clear_selections():
	current_spell.clear_selection()
