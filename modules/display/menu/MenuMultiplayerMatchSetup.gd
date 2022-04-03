class_name MenuMultiplayerMatchSetup
extends MenuScreenBase

var PlayerOptions = null

var lobby = null
var playerOptions_list = []
var observerOptions_list = []

func _init():
	rpc_config("multiplayer_lobby_execute_command", MultiplayerAPI.RPC_MODE_SYNC)
	_setup_network_()

# NEW MULTIPLAYER GAME IS CREATED
func _ready():
	PlayerOptions = load("res://modules/display/menu/GuiMultiplayerPlayerOptions.tscn")
	lobby = Lobby.new()

func setup():
	lobby.setup()
	if mod.Network.is_server():
		rpc_id(mod.Network.SERVER_ID, "multiplayer_lobby_execute_command", COMMAND_NEW_MEMBER, "Server")

func refresh_lobby_display():
	var lobby_players_served = {}
	for player in lobby.get_members():
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
			lobby.move_player_to_observers(player.id)


func restart_lobby_display():
	for player_options in playerOptions_list:
		player_options.queue_free()
	playerOptions_list = []
	
	for i in range(0, lobby.get_map_player_size()):
		var player_options = PlayerOptions.instance()
		player_options.set_name("PlayerOptions_%02d" % i)
		playerOptions_list.append(player_options)
		$PlayerList.add_child(player_options)
		player_options.connect("change_color", self, "_on_change_color")
		player_options.connect("join", self, "_on_join")


func _on_change_color(object, value):
	rpc_id(mod.Network.SERVER_ID, "multiplayer_lobby_execute_command", COMMAND_COLOR_CHANGE, value)

func _on_join(object):
	print(object)
	var id = playerOptions_list.find(object)
	mod.Network.broadcast_to_peers(id)
	
enum {COMMAND_BROADCAST_LOBBY, COMMAND_COLOR_CHANGE, COMMAND_NEW_MEMBER, COMMAND_JOIN, COMMAND_LEAVE, COMMAND_OBSERVE, COMMAND_UPDATE_LOBBY, \
COMMAND_SEND_IDENTIFICATION, COMMAND_ASK4_LOBBY_UPDATE}
func multiplayer_lobby_execute_command(command, package=null):
	# check rights
	match command:
		COMMAND_BROADCAST_LOBBY, COMMAND_COLOR_CHANGE, COMMAND_NEW_MEMBER, COMMAND_JOIN, COMMAND_LEAVE, COMMAND_OBSERVE:
			if not mod.Network.is_server():
				Terminal.add_log(Debug.ERROR, "Trying to execute incoming unknown server command!")
				return
	
	print("executing command ", command)
	var network_id = get_tree().get_rpc_sender_id()
	match command:
		COMMAND_NEW_MEMBER:
			lobby.add_update_member(network_id, LobbyMemberInfo.TYPE_PLAYER, package)
		COMMAND_COLOR_CHANGE:
			var member = lobby.get_member_by_network_id(network_id)
			lobby.change_player_color(member.id, package)
		COMMAND_UPDATE_LOBBY:
			lobby.setup(package)
			restart_lobby_display()
			refresh_lobby_display()
		COMMAND_SEND_IDENTIFICATION:
			rpc_id(mod.Network.SERVER_ID, "multiplayer_lobby_execute_command", COMMAND_NEW_MEMBER, "NOWY MEMBER BQ")
		COMMAND_BROADCAST_LOBBY:
			pass
		_:
			Terminal.add_log(Debug.ERROR, "Trying to execute incoming unknown command!")
			return
	
	# broadcast to every member after certain commands 
	match command:
		COMMAND_BROADCAST_LOBBY, COMMAND_COLOR_CHANGE, COMMAND_NEW_MEMBER, COMMAND_JOIN, COMMAND_LEAVE, COMMAND_OBSERVE:
			if mod.Network.is_server():
				var update_package = LobbyMemberInfoPackage.pack(lobby)
				rpc("multiplayer_lobby_execute_command", COMMAND_UPDATE_LOBBY, update_package)

func _on_Cancel_pressed():
	mod.Network.disconnect_()
	mod.Menu.switch_screens(mod.Menu.main_menu)

func _on_StartGame_pressed():
	print("START MATCH")
#	mod.Database.clear_players_info()
#	mod.Database.add_player_info(0, $P1.get_current_name(), $P1.get_current_color())
#	mod.Database.add_player_info(1, $P2.get_current_name(), $P2.get_current_color())
#	mod.Game.start_match()

# Server specific
func _new_client_in_lobby(network_id):
	rpc_id(network_id, "multiplayer_lobby_execute_command", COMMAND_SEND_IDENTIFICATION)
func _client_exit_lobby(network_id):
	lobby.remove_member(network_id)
	multiplayer_lobby_execute_command(COMMAND_BROADCAST_LOBBY)

func _setup_network_():
	if mod.Network.is_server():
		mod.Network.connect_network_signal("client_added", self, "_new_client_in_lobby") # server
		mod.Network.connect_network_signal("client_removed", self, "_client_exit_lobby") # server
	else:
		pass
#	connect("_remove_user", self, "_on_Tween2D_all_completed") # server
#	connect("_exit_lobby", self, "_on_Tween2D_all_completed") # client
