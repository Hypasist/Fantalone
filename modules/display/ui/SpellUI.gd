class_name SpellUI
extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func targetting():
	pass

func _on_AcceptSpellButton_pressed():
	spell_casted()

func _on_CancelSpellButton_pressed():
	spell_deselected()

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

### SPELLS ---------------------------------------------------------------
func spell_selected(spell_info):
	mod.ControllerData.deselect_all_units()
	mod.GameUI.set_UI_mode(GameUI.UI_MODE_TILE)
	load_spell(spell_info)
	mod.GameUI.set_UI_action(GameUI.UI_ACTION_SPELL)

func spell_deselected():
	mod.GameUI.set_UI_mode(GameUI.UI_MODE_UNIT)
	unload_spell()
	mod.GameUI.set_UI_action(GameUI.UI_ACTION_MOVE)
	
func spell_casted():
	cast_spell()
	mod.ControllerData.update_display()
	spell_deselected()
