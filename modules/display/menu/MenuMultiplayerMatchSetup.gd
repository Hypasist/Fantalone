class_name MenuMultiplayerMatchSetup
extends MenuScreenBase

var PlayerOptions = null
var ButtonLabel = null
var LobbyData = null

var playerOptions_list = []
var buttonLabel_list = []

# NEW MULTIPLAYER GAME IS CREATED
func _ready():
	PlayerOptions = load("res://modules/display/menu/GuiMultiplayerPlayerOptions.tscn")
	ButtonLabel = load("res://modules/display/menu/ButtonLabel.tscn")
	LobbyData = mod.ClientData.LobbyData

# NETWORK SIGNALS HOOK UP
func _hookup_network_signals():
	mod.NetworkData.connect_network_signal("client_added", self, "_new_client_in_lobby") # server
	mod.NetworkData.connect_network_signal("client_removed", self, "_client_exit_lobby") # server
	mod.NetworkData.connect_network_signal("server_disconnected", self, "_server_disconnected") # client

func setup(setup_as_server = false):
	# Setup_as_server -- setup multiplayer server and singleplayer admin client
	#!Setup_as_server -- setup multiplayer client
	
	if setup_as_server:
		mod.ServerData.setup()
		$IPLabel.set_text("IP: %s" % mod.NetworkData.get_ip())
	else:
		$IPLabel.set_text("IP: %s" % mod.NetworkData.get_target_ip())
	mod.ClientData.setup(setup_as_server)
	
	refresh_lobby_display()
	_hookup_network_signals()

func refresh(level):
	restart_lobby_display()
	refresh_lobby_display()

func refresh_lobby_display():
	var lobby_players_served = {}
	for player in LobbyData.get_players():
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
	
	for observer in LobbyData.get_observers():
		var new_obs = ButtonLabel.instance()
		$ObserverList.add_child(new_obs)
		buttonLabel_list.append(new_obs)
		new_obs.set_text(observer.nickname)
	
	if mod.NetworkData.is_admin() and LobbyData.get_players_count() > 0:
		$StartGame.set_disabled(false)
	else:
		$StartGame.set_disabled(true)

func restart_lobby_display():
	for player_options in playerOptions_list:
		player_options.queue_free()
	playerOptions_list = []
	
	for i in range(0, LobbyData.get_map_player_size()):
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
	mod.LobbyNetworkAPI.send_to_server(LobbyNetworkAPI.command.NAME_CHANGE, \
				object.lobby_member.unique_id, value)
	
func _on_change_color(object, value):
	mod.LobbyNetworkAPI.send_to_server(LobbyNetworkAPI.command.COLOR_CHANGE, \
				object.lobby_member.unique_id, value)

func _on_add_bot(object):
	mod.LobbyNetworkAPI.send_to_server(LobbyNetworkAPI.command.NEW_MATCH_MEMBER, \
				mod.NetworkData.get_id(), object.match_id, MatchPlayerInfo.CPU_PLAYER)
				
func _on_add_human(object):
	mod.LobbyNetworkAPI.send_to_server(LobbyNetworkAPI.command.NEW_MATCH_MEMBER, \
				mod.NetworkData.get_id(), object.match_id, MatchPlayerInfo.HUMAN_PLAYER)

func _on_delete(object):
	mod.LobbyNetworkAPI.send_to_server(LobbyNetworkAPI.command.REMOVE_MATCH_MEMBER, \
				object.lobby_member.unique_id)

func _on_StartGame_pressed():
	mod.LobbyNetworkAPI.send_to_server(LobbyNetworkAPI.command.CLIENT_REQUEST_GAME_START)



func _on_Cancel_pressed():
	mod.NetworkData.disconnect_self()
	mod.Menu.switch_screens(mod.Menu.main_menu)

# Server specific
func _new_client_in_lobby(network_id):
	mod.LobbyNetworkAPI.send_to_client(LobbyNetworkAPI.command.SERVER_REQUEST_IDENTIFICATION, network_id)
	
func _client_exit_lobby(network_id):
	mod.ServerData.LobbyData.remove_lobby_member(network_id)
	mod.LobbyNetworkAPI.broadcast_to_clients(LobbyNetworkAPI.command.SERVER_UPDATE_LOBBY_STATUS, \
		LobbyDataPackage.pack(mod.ServerData.LobbyData))
	
func _server_disconnected():
	mod.NetworkData.disconnect_self()
	mod.Menu.switch_screens(mod.Menu.main_menu)
	mod.Popups.create_popup_with_confirmation("You have been disconnected from the server", "Understand")
