class_name OptionsMenuPopup
extends PopupBase

func setup(size:Vector2=Vector2(0,0)):
	.setup(size)
	$Box/VBoxContainer/AutofinishTurnsSlider.set_pressed(mod.OptionsData.is_autofinish_turn())
	set_displayed_name(mod.OptionsData.get_player_name())

func _on_CancelButton_pressed():
	mod.Popups.pop_popup(self)

func _on_AcceptButton_pressed():
	mod.OptionsData.set_autofinish_turn($Box/VBoxContainer/AutofinishTurnsSlider.is_pressed())
	mod.OptionsData.set_player_name(name_remembered)
	mod.Popups.pop_popup(self)

var name_remembered = ""
func set_displayed_name(text):
	name_remembered = text
	$Box/VBoxContainer/PlayerNameContainer/LineEdit.set_text(text)

func _on_LineEdit_text_entered(new_text):
	name_remembered = new_text

func _on_LineEdit_focus_exited():
	$Box/VBoxContainer/PlayerNameContainer/LineEdit.set_text(name_remembered)
