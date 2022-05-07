class_name MenuMultiplayerMatchSetup
extends MenuScreenBase

var PlayerOptions = null

var playerOptions_list = []
# var observerOptions_list = []

# NEW MULTIPLAYER GAME IS CREATED
func _ready():
	PlayerOptions = load("res://modules/display/menu/GuiMultiplayerPlayerOptions.tscn")

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
	mod.LobbyLogic.setup()
	
	if setup_as_server:
		mod.Network.create_server()
		mod.LobbyLogic.execute_command(LobbyLogic.command.REQUEST_NEW_MEMBER, mod.Database.get_player_name())
	else:
		mod.Network.connect_to_server()
		$StartGame.set_disabled(true)

	_hookup_network_signals()

func refresh(level):
	print("refreshing lobby")
	restart_lobby_display()
	refresh_lobby_display()

func refresh_lobby_display():
	var lobby_players_served = {}
	for player in mod.LobbyData.get_members():
		lobby_players_served[player] = false
	
	# for every playerOptions panel 
	for player_options in playerOptions_list:
		var playerOptions_id = playerOptions_list.find(player_options)

		# search for assigned player
		for player in lobby_players_served:
			if player.id == playerOptions_id:
				if lobby_players_served[player] == false:
					player_options.setup(player)
					lobby_players_served[player] = true
				else:
					Terminal.add_log(Debug.ERROR, "Trying to assign same member to another PlayerOptionsPanel!")
				break
	
	# discard the rest as observers
	for player in lobby_players_served:
		if lobby_players_served[player] == false:
			mod.LobbyData.move_player_to_observers(player.id)


func restart_lobby_display():
	for player_options in playerOptions_list:
		player_options.queue_free()
	playerOptions_list = []
	
	for i in range(0, mod.LobbyData.get_map_player_size()):
		var player_options = PlayerOptions.instance()
		player_options.set_name("PlayerOptions_%02d" % i)
		playerOptions_list.append(player_options)
		$PlayerOptionsList.add_child(player_options)
		player_options.connect("change_color", self, "_on_change_color")
		player_options.connect("kick", self, "_on_kick")
		player_options.connect("join", self, "_on_join")
		player_options.connect("change_name", self, "_on_change_name")
		player_options.connect("add_bot", self, "_on_add_bot")


func _on_change_name(object, value):
	mod.Database.set_player_name(value)
	mod.LobbyLogic.execute_command(LobbyLogic.command.REQUEST_NAME_CHANGE, value)
	
func _on_change_color(object, value):
	mod.LobbyLogic.execute_command(LobbyLogic.command.REQUEST_COLOR_CHANGE, value)
	
func _on_kick(object):
	if mod.Network.is_server():
		mod.Network.disconnect_client(object.lobby_member.network_id) # move this to LobbyLogic
	else:
		Terminal.add_log(Debug.ERROR, "Client trying to kick a lobby member!")
		

func _on_join(object):
	print(object)
	var id = playerOptions_list.find(object)

func _on_add_bot(object):
#	rpc_id(mod.Network.SERVER_ID, "multiplayer_lobby_execute_command", COMMAND_NEW_BOT, "Bot")
	pass

func _on_Cancel_pressed():
	mod.Network.disconnect_()
	mod.Menu.switch_screens(mod.Menu.main_menu)

func _on_StartGame_pressed():
	mod.LobbyLogic.execute_command(LobbyLogic.command.BROADCAST_START)

# Server specific
func _new_client_in_lobby(network_id):
	mod.LobbyLogic.execute_command(LobbyLogic.command.REQUEST_IDENTIFICATION, network_id)
	
func _client_exit_lobby(network_id):
	mod.LobbyData.remove_member(network_id)
	mod.LobbyLogic.execute_command(LobbyLogic.command.BROADCAST_LOBBY)
	
func _server_disconnected():
	mod.Network.disconnect_()
	mod.Menu.switch_screens(mod.Menu.main_menu)
	mod.PopupHelper.create_hanging_popup_with_confirmation("You have been disconnected from the server", "Understand")
