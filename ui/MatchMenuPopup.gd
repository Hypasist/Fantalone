class_name MatchMenuPopup
extends PopupBase

func setup(size:Vector2=Vector2(0,0)):
	.setup(size)

func _on_ContinueButton_pressed():
	mod.PopupUI.pop_popup(self)


func _on_MainMenuButton_handler(value):
	match value:
		0:
			mod.PopupUI.pop_popup(self)
			mod.MatchLogic.stop_match()
		1:
			pass

func _on_MainMenuButton_pressed():
	mod.PopupUI.create_custom_popup(
		"Are you sure you want to quit to main menu?",
		["Yes", "No"], [true, true], self, "_on_MainMenuButton_handler"
	)


func _on_ExitButton_handler(value):
	match value:
		0:
			mod.PopupUI.pop_popup(self)
			mod.MatchLogic.stop_match()
			mod.Game.exit_game()
		1:
			pass
	
func _on_ExitButton_pressed():
	mod.PopupUI.create_custom_popup(
		"Are you sure you want to quit the game?",
		["Yes", "No"], [true, true], self, "_on_ExitButton_handler"
	)


func _on_OptionsButton_pressed():
	mod.PopupUI.create_options_menu_popup()

