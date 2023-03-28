class_name GameUI
extends Control

onready var Hoverlist = $Hoverlist
onready var MovementArrow = $MovementArrow
onready var ActionHandle = $ActionHandle
onready var MatchUI = $MatchUI
onready var SpellUI = $SpellUI

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

## --- UI MODE TO DIFFERENTIATE BETWEEN DIFFERENT GUI ACTION TYPES --- ##
enum { UI_ACTION_NONE, UI_ACTION_MENU, UI_ACTION_MOVE, UI_ACTION_SPELL } ## MERGE EVERYTHING
var current_UI_action = UI_ACTION_NONE
func get_UI_action():
	return current_UI_action
func set_UI_action(action):
	match current_UI_action:
		UI_ACTION_MENU:
			mod.Menu.hide_menu()
		UI_ACTION_MOVE:
			MatchUI.hide()
		UI_ACTION_SPELL:
			SpellUI.hide()
	current_UI_action = action
	match current_UI_action:
		UI_ACTION_MENU:
			mod.Menu.show_menu()
		UI_ACTION_MOVE:
			MatchUI.show()
		UI_ACTION_SPELL:
			SpellUI.show()

## ----------------------------------------- ##
func setup():
	$MatchUI.setup()
	$MatchUI.show()

func hide_match_ui():
	$MatchUI.hide()

func update_ui():
	$MatchUI.update()

## SPELLCAST
func spell_selected(spell_info):
	$SpellUI.spell_selected(spell_info)
func load_spell(spell_info):
	$SpellUI.load_spell(spell_info)
