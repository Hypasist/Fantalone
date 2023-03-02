class_name GameUI
extends Control

var map_control_enabled = false
func lock_map_control():
	map_control_enabled = false
func unlock_map_control():
	map_control_enabled = true

# 
func add_to_hoverlist(object):
	$Hoverlist.add_to_hoverlist(object)
func remove_from_hoverlist(object):
	$Hoverlist.remove_from_hoverlist(object)
func get_hovered_unit():
	return $Hoverlist.get_hovered_unit()
func get_hovered_tile():
	return $Hoverlist.get_hovered_tile()

# ARROW HANDLE
func arrow_clear_direction():
	$MovementArrow.clear_direction()
func arrow_set_no_direction(position):
	$MovementArrow.set_no_direction_arrow(position)
func arrow_set_invalid(position):
	$MovementArrow.set_invalid_arrow(position)
func arrow_set_direction(position, direction):
	$MovementArrow.set_direction_arrow(position, direction)

func setup():
	$MatchUI.setup()
	$MatchUI.show()

func hide_match_ui():
	$MatchUI.hide()

func update_ui():
	$MatchUI.update()

# GUI CONTROL
func set_UI_mode(mode):
	$GUIControl.set_UI_mode(mode)

func shorttap_handle():
	$GUIControl.shorttap_handle()

## SPELLCAST
func load_spell(spell_info):
	$GUIControl.load_spell(spell_info)
func set_spellcast_mode(value):
	$MatchUI.turn_on_spell_targeting() if value else $MatchUI.turn_off_spell_targeting()
func get_spellcast_mode():
	return $MatchUI.is_spellcast_mode()
