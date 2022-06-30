class_name MatchMenuPopup
extends PopupBase

func setup(size:Vector2=Vector2(0,0)):
	.setup(size)

func _on_ContinueButton_pressed():
	mod.PopupUI.pop_popup(self)

func _on_MainMenu_confirmed(dummy1=null, dummy2=null):
	mod.PopupUI.free_popup(confirmation_popup)
	mod.LobbyLogic.end_match()

var confirmation_popup = null
func _on_MainMenuButton_pressed():
	confirmation_popup = mod.PopupUI.create_custom_popup(
		"Are you sure you want to quit to main menu?",
		["Yes", "No"], [true, true], self, "_on_MainMenuButton_handler"
	)

func _on_MainMenuButton_handler(value):
	print(value)
	pass

func _on_ExitButton_confirmed(dummy1=null, dummy2=null):
	mod.PopupUI.free_popup(confirmation_popup)
	mod.LobbyLogic.end_match()
	mod.Game.exit_game()
	
func _on_ExitButton_pressed():
	confirmation_popup = mod.PopupUI.create_custom_popup(
		"Are you sure you want to quit the game?",
		["Yes", "No"], [true, true], self, "_on_ExitButton_handler"
	)

func _on_ExitButton_handler(value):
	print(value)
	pass
