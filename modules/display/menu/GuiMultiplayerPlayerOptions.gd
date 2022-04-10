class_name GuiMultiplayerPlayerOptions
extends Control

var lobby_member:LobbyMemberInfo = null

func _ready():
	clear()

func setup(_lobby_member = null):
	if _lobby_member == null:
		return
		
	lobby_member = _lobby_member
	var has_ownership = lobby_member.network_id == mod.Network.get_id()
	var is_server = mod.Network.is_server()
	
	$Box/PlayerName.set_text(lobby_member.nickname)
	$Box/Color.set_frame_color(lobby_member.color)
	if has_ownership:
		$Box/PlayerName.set_editable(true)
		$Box/LeftColor.set_disabled(false)
		$Box/RightColor.set_disabled(false)
		if is_server:
			change_action_button(ACTION_NONE)
		else:
			change_action_button(ACTION_LEAVE)
	
	else:
		$Box/PlayerName.set_editable(false)
		$Box/LeftColor.set_disabled(true)
		$Box/RightColor.set_disabled(true)
		if is_server:
			change_action_button(ACTION_KICK)
		else:
			change_action_button(ACTION_NONE)

func clear():
	lobby_member = null
	$Box/PlayerName.set_text("-- empty --")
	$Box/Color.set_frame_color(Color.transparent)
	$Box/PlayerName.set_editable(false)
	$Box/LeftColor.set_disabled(true)
	$Box/RightColor.set_disabled(true)
	change_action_button(ACTION_JOIN)
	
enum {ACTION_KICK, ACTION_LEAVE, ACTION_JOIN, ACTION_NONE}
func change_action_button(action):
	$Box/ActionButton/KickButton.hide()
	$Box/ActionButton/LeaveButton.hide()
	$Box/ActionButton/JoinButton.hide()
	match action:
		ACTION_KICK:
			$Box/ActionButton/KickButton.show()
		ACTION_LEAVE:
			$Box/ActionButton/LeaveButton.show()
		ACTION_JOIN:
			$Box/ActionButton/JoinButton.show()
		ACTION_NONE:
			pass

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

signal kick(object)
func _on_KickButton_pressed():
	emit_signal("kick", self)

signal join(object)
func _on_JoinButton_pressed():
	emit_signal("join", self)

func _on_LeaveButton_pressed():
	pass # Replace with function body.
