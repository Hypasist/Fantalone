class_name GameUI
extends Control

onready var Hoverlist = $Hoverlist
onready var MovementArrow = $MovementArrow
onready var ActionHandle = $ActionHandle
onready var MatchUI = $MatchUI

## ------ MAP CONTROL TO PREVENT FROM ACCIDENTALTY CLICKING STUFF ------ ##
var map_control_enabled = false
func lock_map_control():
	map_control_enabled = false
func unlock_map_control():
	map_control_enabled = true
func get_map_control():
	return map_control_enabled

## --- UI MODE TO DIFFERENTIATE BETWEEN DIFFERENT GUI TARGETING STATES --- ##
enum { UI_MODE_MENU, UI_MODE_UNIT, UI_MODE_TILE }
var current_UI_mode = UI_MODE_MENU
func get_UI_mode():
	return current_UI_mode
func set_UI_mode(mode):
	current_UI_mode = mode

## ----------------------------------------- ##
func setup():
	$MatchUI.setup()
	$MatchUI.show()

func hide_match_ui():
	$MatchUI.hide()

func update_ui():
	$MatchUI.update()

## SPELLCAST
func load_spell(spell_info):
	$GUIControl.load_spell(spell_info)
func set_spellcast_mode(value):
	$MatchUI.turn_on_spell_targeting() if value else $MatchUI.turn_off_spell_targeting()
func get_spellcast_mode():
	return $MatchUI.is_spellcast_mode()
