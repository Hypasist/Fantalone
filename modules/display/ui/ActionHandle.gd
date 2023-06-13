class_name ActionHandle
extends Node

func shorttap_handle():
	if mod.GameUI.is_menu_mode():
		return
	
	match mod.GameUI.get_UI_mode():
		mod.GameUI.SELECTION_MODE_NONE:
			var unit = mod.GameUI.Hoverlist.get_hovered_unit()
			if unit:
				match mod.GameUI.get_UI_action():
					mod.GameUI.UI_ACTION_SPELL:
						mod.SpellUI.new_unit_selected(unit)
					mod.GameUI.UI_ACTION_MOVE:
						mod.ControllerData.new_unit_selected(unit)
		mod.GameUI.SELECTION_MODE_TILE:
			var tile = mod.GameUI.Hoverlist.get_hovered_tile()
			if tile:
				match mod.GameUI.get_UI_action():
					mod.GameUI.UI_ACTION_SPELL:
						mod.SpellUI.new_tile_selected(tile)
					mod.GameUI.UI_ACTION_MOVE:
						pass

func end_turn_handle():
	mod.ControllerData.end_turn()
