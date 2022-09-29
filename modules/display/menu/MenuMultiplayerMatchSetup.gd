class_name MenuMultiplayerMatchSetup
extends MenuScreenBase

var PlayerOptions = null
var ButtonLabel = null

var playerOptions_list = []
var buttonLabel_list = []

# NEW MULTIPLAYER GAME IS CREATED
func _ready():
	PlayerOptions = load("res://modules/display/menu/GuiMultiplayerPlayerOptions.tscn")
	ButtonLabel = load("res://modules/display/menu/ButtonLabel.tscn")

# NETWORK SIGNALS HOOK UP
func _hookup_network_signals():
	if mod.Network.is_server():
		mod.Network.connect_network_signal("client_added", self, "_new_client_in_lobby") # server
		mod.Network.connect_network_signal("client_removed", self, "_client_exit_lobby") # server
	else:
		mod.Network.connect_network_signal("server_disconnected", self, "_server_disconnected") # client
#	connect("_remove_user", self, "_on_Tween2D_all_completed") # server
#	connect("_exit_lobby", self, "_on_Tween2D_all_completed") # client

func setup(setup_as_server = false):
	mod.LobbyData.setup()
	mod.LobbyNetwork.setup()
	
	if setup_as_server:
		mod.Network.create_server()
		$IPLabel.set_text("IP: %s" % mod.Network.get_ip())
		mod.LobbyNetwork.execute_command(LobbyNetwork.command.REQUEST_IDENTIFICATION, Network.SERVER_ID)
	else:
		mod.Network.connect_to_server()
		$IPLabel.set_text("IP: %s" % mod.Network.get_target_ip())
		$StartGame.set_disabled(true)
	
	_hookup_network_signals()

func refresh(level):
	restart_lobby_display()
	refresh_lobby_display()

func refresh_lobby_display():
	var lobby_players_served = {}
	for player in mod.LobbyData.get_players():
		lobby_players_served[player] = false
	
	# for every playerOptions panel 
	for player_options in playerOptions_list:
		var playerOptions_match_id = player_options.match_id

		# search for assigned player
		for player in lobby_players_served:
			if player.match_id == playerOptions_match_id:
				if lobby_players_served[player] == false:
					player_options.setup(player)
					lobby_players_served[player] = true
				else:
					Terminal.add_log(Debug.ERROR, Debug.LOBBY, "Trying to assign same member to another PlayerOptionsPanel!")
				break
		
	for observer in mod.LobbyData.get_observers():
		var new_obs = ButtonLabel.instance()
		$ObserverList.add_child(new_obs)
		buttonLabel_list.append(new_obs)
		new_obs.set_text(observer.nickname)
		
	if mod.Network.is_server():
		if mod.LobbyData.get_players_count() > 0:
			$StartGame.set_disabled(false)
		else:
			$StartGame.set_disabled(true)


func restart_lobby_display():
	for player_options in playerOptions_list:
		player_options.queue_free()
	playerOptions_list = []
	
	for i in range(0, mod.LobbyData.get_map_player_size()):
		var player_options = PlayerOptions.instance()
		player_options.ready(i)
		playerOptions_list.append(player_options)
		$PlayerOptionsList.add_child(player_options)
		player_options.connect("change_color", self, "_on_change_color")
		player_options.connect("change_name", self, "_on_change_name")
		player_options.connect("add_bot", self, "_on_add_bot")
		player_options.connect("add_human", self, "_on_add_human")
		player_options.connect("delete", self, "_on_delete")

	for buttonLabel in buttonLabel_list:
		buttonLabel.queue_free()
	buttonLabel_list = []



func _on_change_name(object, value):
	mod.LobbyNetwork.execute_command(LobbyNetwork.command.REQUEST_NAME_CHANGE, \
				object.lobby_member.unique_id, value)
	
func _on_change_color(object, value):
	mod.LobbyNetwork.execute_command(LobbyNetwork.command.REQUEST_COLOR_CHANGE, \
				object.lobby_member.unique_id, value)

func _on_add_bot(object):
	mod.LobbyNetwork.execute_command(LobbyNetwork.command.REQUEST_NEW_MEMBER, \
				object.match_id, MatchPlayerInfo.CPU_PLAYER)
				
func _on_add_human(object):
	mod.LobbyNetwork.execute_command(LobbyNetwork.command.REQUEST_NEW_MEMBER, \
				object.match_id, MatchPlayerInfo.HUMAN_PLAYER)

func _on_delete(object):
	if mod.Network.is_server():
		mod.LobbyNetwork.execute_command(LobbyNetwork.command.REQUEST_REMOVE, \
					object.lobby_member.unique_id)

func _on_Cancel_pressed():
	mod.Network.disconnect_()
	mod.Menu.switch_screens(mod.Menu.main_menu)

func _on_StartGame_pressed():
	mod.LobbyLogic.start_game_setup()

# Server specific
func _new_client_in_lobby(network_id):
	mod.LobbyNetwork.execute_command(LobbyNetwork.command.REQUEST_IDENTIFICATION, network_id)
	
func _client_exit_lobby(network_id):
	mod.LobbyData.remove_lobby_member(network_id)
	mod.LobbyNetwork.execute_command(LobbyNetwork.command.BROADCAST_LOBBY)
	
func _server_disconnected():
	mod.Network.disconnect_()
	mod.Menu.switch_screens(mod.Menu.main_menu)
	mod.PopupUI.create_popup_with_confirmation("You have been disconnected from the server", "Understand")
