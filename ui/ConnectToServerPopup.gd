class_name ConnectToServerPopup
extends PopupBase

var default_ip = "192.168.0.1"

func setup(size:Vector2=Vector2(0,0)):
	.setup(size)
	set_displayed_name(default_ip)

func _on_CancelButton_pressed():
	mod.Popups.pop_popup(self)

func _on_AcceptButton_pressed():
	if changed_name:
		_on_LineEdit_text_entered(changed_name)
	mod.NetworkData.set_target_ip(name_remembered)
	mod.Menu.switch_screens(mod.Menu.multiplayer_setup, false)
	mod.Popups.pop_popup(self)

var name_remembered = ""
func set_displayed_name(text):
	name_remembered = text
	$Box/VBoxContainer/DirectConnectionContainer/LineEdit.set_text(text)
func revert_displayed_name():
	$Box/VBoxContainer/DirectConnectionContainer/LineEdit.set_text(name_remembered)

func _on_LineEdit_text_entered(new_text):
	if new_text.is_valid_ip_address():
		name_remembered = new_text
	else:
		revert_displayed_name()

func _on_LineEdit_focus_exited():
	revert_displayed_name()

func _on_AutosearchButton_pressed():
	Terminal.add_log(Debug.INFO, Debug.SYSTEM, "Autosearch not implemented yet")

var changed_name = null
func _on_LineEdit_text_changed(new_text):
	changed_name = new_text
