class_name GameUI
extends Control

onready var Hoverlist = $Hoverlist
onready var MovementArrow = $MovementArrow
onready var ActionHandle = $ActionHandle
onready var MatchUI = $MatchUI
onready var SpellUI = $SpellUI


## --- MENU MODE BLOCKADE --- ##
var menu_mode_enabled = true
func is_menu_mode():
	return menu_mode_enabled
func set_menu_mode(value=true):
	menu_mode_enabled = value
## --- UI MODE TO DIFFERENTIATE BETWEEN DIFFERENT GUI TARGETING STATES --- ##
enum { SELECTION_MODE_NONE, SELECTION_MODE_UNIT, SELECTION_MODE_TILE }
var current_selection_mode = SELECTION_MODE_NONE
func get_UI_mode():
	return current_selection_mode
func set_selection_mode(mode):
	Terminal.add_log(Debug.INFO, Debug.INPUT, "Selection mode set: %s." % mode)
	current_selection_mode = mode

## --- UI MODE TO DIFFERENTIATE BETWEEN DIFFERENT GUI ACTION TYPES --- ##
enum { UI_ACTION_NONE, UI_ACTION_MENU, UI_ACTION_MOVE, UI_ACTION_SPELL } ## MERGE EVERYTHING
var last_UI_action = UI_ACTION_NONE
var current_UI_action = UI_ACTION_NONE
func get_UI_action():
	return current_UI_action
func set_UI_action(action):
	last_UI_action = current_UI_action
	match current_UI_action:
		UI_ACTION_MOVE:
			MatchUI.hide()
		UI_ACTION_SPELL:
			SpellUI.hide()
	current_UI_action = action
	match current_UI_action:
		UI_ACTION_MOVE:
			MatchUI.show()
		UI_ACTION_SPELL:
			SpellUI.show()
func revert_UI_action():
	set_UI_action(last_UI_action)
	last_UI_action = UI_ACTION_NONE

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
