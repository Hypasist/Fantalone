class_name ActionHandle
extends Node

func shorttap_handle():
	match mod.GameUI.get_UI_mode():
		mod.GameUI.UI_MODE_MENU:
			pass
		mod.GameUI.UI_MODE_UNIT:
			var unit = mod.GameUI.Hoverlist.get_hovered_unit()
			if unit:
				if mod.GameUI.get_spellcast_mode():
					$SpellcastLogic.new_unit_selected(unit)
				else:
					mod.ControllerData.new_unit_selected(unit)
		mod.GameUI.UI_MODE_TILE:
			var tile = mod.GameUI.Hoverlist.get_hovered_tile()
			if tile:
				if mod.GameUI.get_spellcast_mode():
					$SpellcastLogic.new_tile_selected(tile)

func end_turn_handle():
	mod.ControllerData.end_turn()
