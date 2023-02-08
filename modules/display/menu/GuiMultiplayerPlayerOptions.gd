class_name GuiMultiplayerPlayerOptions
extends Control

var match_id = MatchMemberInfo.ID_INVALID
var lobby_member:MatchMemberInfo = null

func ready(_match_id):
	lobby_member = null
	match_id = _match_id
	set_name("PlayerOptions_%02d" % match_id)
	set_displayed_name("-- empty --")
	$Box/Color.set_frame_color(Color.transparent)
	$Box/PlayerName.set_editable(false)
	$Box/LeftColor.set_disabled(true)
	$Box/RightColor.set_disabled(true)
	if NetworkAPI.is_admin():
		$Box/AddBotButton.set_disabled(false)
		$Box/AddHumanButton.set_disabled(false)
		$Box/DeleteButton.set_disabled(true)
	else:
		$Box/AddBotButton.set_disabled(true)
		$Box/AddHumanButton.set_disabled(false)
		$Box/DeleteButton.set_disabled(true)


func setup(_lobby_member = null):
	if _lobby_member == null:
		return
		
	lobby_member = _lobby_member
	var has_ownership = lobby_member.owner_lobby_member.network_id == mod.ClientData.Network.get_id()
	var is_admin = NetworkAPI.is_admin()
	
	set_displayed_name(lobby_member.nickname)
	$Box/Color.set_frame_color(lobby_member.color)
	$Box/AddBotButton.set_disabled(true)
	$Box/AddHumanButton.set_disabled(true)
	if has_ownership:
		$Box/PlayerName.set_editable(true)
		$Box/LeftColor.set_disabled(false)
		$Box/RightColor.set_disabled(false)
		$Box/DeleteButton.set_disabled(false)
	
	else:
		$Box/PlayerName.set_editable(false)
		$Box/LeftColor.set_disabled(true)
		$Box/RightColor.set_disabled(true)
		if is_admin:
			$Box/DeleteButton.set_disabled(false)
		else:
			$Box/DeleteButton.set_disabled(true)

func update_color():
	$Box/Color.set_frame_color(lobby_member.color)
func get_current_color():
	return $Box/Color.get_frame_color()
func get_current_name():
	return $Box/PlayerName.get_text()

signal change_color(object, value)
func _on_RightColor_pressed():
	emit_signal("change_color", self, 1)
func _on_LeftColor_pressed():
	emit_signal("change_color", self, -1)

signal add_bot(object)
func _on_AddBotButton_pressed():
	emit_signal("add_bot", self)

signal add_human(object)
func _on_AddHumanButton_pressed():
	emit_signal("add_human", self)

signal delete(object)
func _on_DeleteButton_pressed():
	emit_signal("delete", self)

var name_remembered = ""
func set_displayed_name(text):
	name_remembered = text
	$Box/PlayerName.set_text(text)

signal change_name(object, text)
func _on_PlayerName_text_entered(new_text):
	emit_signal("change_name", self, new_text)

func _on_PlayerName_focus_exited():
	$Box/PlayerName.set_text(name_remembered)
