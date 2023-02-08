class_name GUIControl
extends Node

## INFORMING THE PLAYER ABOUT THE MOVE RESULTS:
## 	IF VALID:
##   	- the *destination* tile should have a color (OR ONLY BLUE??) of the incoming HEX
##		- if the *destination* tile is a lethal hex, present a skull
##	IF INVALID:
##		IF NO_REASON:
##			assert?
##		IF UNPASSABLE TERRAIN:
##			red cage on the unpassable terrain?, blue tile on any affected?
##		IF PUSHING OWN UNITS:
##			red cage on mentioned own unit, blue tile under any affected
##		IF FORMATION TOO WEAK:
##			RED CAGE on first invalid enemy hex, rest with blue tile under
##		IF TILE OCCUPIED:
##			red cage on tiles uccupied, blue tiles under own hexes

enum { UI_MODE_MENU, UI_MODE_UNIT, UI_MODE_TILE }
var current_UI_mode = UI_MODE_MENU
func get_UI_mode():
	return current_UI_mode
func set_UI_mode(mode):
	current_UI_mode = mode

func shorttap_handle():
	match get_UI_mode():
		UI_MODE_MENU:
			pass
		UI_MODE_UNIT:
			var unit = mod.GameUI.get_hovered_unit()
			if unit:
				if mod.MatchUI.is_spellcast_mode():
					$SpellcastLogic.new_unit_selected(unit)
				else:
					mod.ControllerData.new_unit_selected(unit)
		UI_MODE_TILE:
			var tile = mod.GameUI.get_hovered_tile()
			if tile:
				if mod.MatchUI.is_spellcast_mode():
					$SpellcastLogic.new_tile_selected(tile)

func load_spell(spell_info):
	$SpellcastLogic.load_spell(spell_info)
func unload_spell():
	$SpellcastLogic.unload_spell()
func cast_spell():
	$SpellcastLogic.cast_spell()

