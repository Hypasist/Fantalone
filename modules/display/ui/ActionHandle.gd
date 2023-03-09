class_name ActionHandle
extends Node

func shorttap_handle():
	match mod.GameUI.get_UI_mode():
		mod.GameUI.UI_MODE_MENU:
			pass
		mod.GameUI.UI_MODE_UNIT:
			var unit = mod.GameUI.Hoverlist.get_hovered_unit()
			if unit:
				match mod.GameUI.get_UI_action():
					mod.GameUI.UI_ACTION_SPELL:
						$SpellcastLogic.new_unit_selected(unit)
					mod.GameUI.UI_ACTION_MOVE:
						mod.ControllerData.new_unit_selected(unit)
		mod.GameUI.UI_MODE_TILE:
			var tile = mod.GameUI.Hoverlist.get_hovered_tile()
			if tile:
				match mod.GameUI.get_UI_action():
					mod.GameUI.UI_ACTION_SPELL:
						$SpellcastLogic.new_tile_selected(tile)
					mod.GameUI.UI_ACTION_MOVE:
						pass

func end_turn_handle():
	mod.ControllerData.end_turn()
