class_name TurnUI
extends Control


func _ready():
	pass # Replace with function body.


func update():
	if mod.LocalLogic.is_turn_owner_locally_present() and \
	   mod.MatchLogic.get_action_counter() > 0:
			$EndTurnButton.set_disabled(false)
	else:
		$EndTurnButton.set_disabled(true)
		
	if mod.LocalLogic.is_turn_owner_locally_present():
		$MoveCounter.set_text("%d moves left  " % [mod.MatchLogic.get_actions_left()])
	else:
		$MoveCounter.set_text("Waiting for opponent action: %d left  " % mod.MatchLogic.get_actions_left())


func _on_SpellButton_pressed():
	mod.PopupUI.create_spell_menu_popup()

func _on_EndTurnButton_pressed():
	mod.MatchLogic.request_end_turn()
