class_name Lobby
extends Node

var MAX_PLAYER_NUM = 8
var MAP_PLAYER_NUM = 4
var MAX_OBSERVER_NUM = 8

const COLOR_UNUSED = -1
var available_colors = {}
var LobbyPlayerInfo_dict = {}
var LobbyObserverInfo_dict = {}


func setup(package:Array=[]):
	LobbyPlayerInfo_dict = {}
	LobbyObserverInfo_dict = {}
	for color in mod.Database.get_colorlist():
		available_colors[color] = COLOR_UNUSED
	if package:
		for record in package:
			var new_member = LobbyMemberInfo.new()
			new_member.id = record["id"]
			new_member.network_id = record["network_id"]
			new_member.type = record["type"]
			new_member.nickname = record["nickname"]
			new_member.color = record["color"]
			
			if new_member.type == LobbyMemberInfo.TYPE_PLAYER:
				LobbyPlayerInfo_dict[new_member.id] = new_member
				available_colors[new_member.color] = new_member.id
			elif new_member.type == LobbyMemberInfo.TYPE_OBSERVER:
				LobbyObserverInfo_dict[new_member.id] = new_member

func get_map_player_size():
	return MAP_PLAYER_NUM

func get_unused_player_id():
	for id in range(0, MAX_PLAYER_NUM):
		if not LobbyPlayerInfo_dict.has(id):
			return id

func get_unused_observer_id():
	for id in range(0, MAX_OBSERVER_NUM):
		if not LobbyObserverInfo_dict.has(id):
			return id

func get_unused_color():
	for color in available_colors:
		if available_colors[color] == COLOR_UNUSED:
			return color
func reserve_color(color, id):
	available_colors[color] = id
func free_color(color):
	available_colors[color] = COLOR_UNUSED

func change_member_color(id, value):
	var member = LobbyPlayerInfo_dict[id]
	var palette_array = available_colors.keys()
	var idx = palette_array.find(member.color)
	free_color(member.color)
	
	while true:
		idx = (idx + value + palette_array.size()) % palette_array.size()
		if available_colors[palette_array[idx]] == COLOR_UNUSED:
			reserve_color(palette_array[idx], id)
			member.color = palette_array[idx]
			return

func add_new_player(network_id, nickname):
	if LobbyPlayerInfo_dict.size() < get_map_player_size():
		var new_member = LobbyMemberInfo.new()
		var new_id = get_unused_player_id()
		var new_color = get_unused_color()
		reserve_color(new_color, new_id)
		new_member.setup(new_id, network_id, LobbyMemberInfo.TYPE_PLAYER, nickname, new_color)
		LobbyPlayerInfo_dict[new_id] = new_member
	else:
		add_new_observer(network_id, nickname)

func add_new_observer(network_id, nickname):
	var new_member = LobbyMemberInfo.new()
	var new_id = get_unused_observer_id()
	new_member.setup(new_id, network_id, LobbyMemberInfo.TYPE_OBSERVER, nickname)
	LobbyObserverInfo_dict[new_id] = new_member

func move_observer_to_players(id):
	var member = LobbyObserverInfo_dict[id]
	var new_id = get_unused_player_id()
	var new_color = get_unused_color()
	LobbyObserverInfo_dict.erase(id)
	member.color = new_color
	member.type = LobbyMemberInfo.TYPE_PLAYER
	member.id = new_id
	LobbyPlayerInfo_dict[new_id] = member

func move_player_to_observers(id):
	var member = LobbyObserverInfo_dict[id]
	var new_id = get_unused_observer_id()
	LobbyObserverInfo_dict.erase(id)
	free_color(member.color)
	member.color = LobbyMemberInfo.COLOR_INVALID
	member.type = LobbyMemberInfo.TYPE_OBSERVER
	member.id = new_id
	LobbyObserverInfo_dict[new_id] = member
	
func get_players():
	return LobbyPlayerInfo_dict.values()

func get_observers():
	return LobbyObserverInfo_dict.values()

func get_member_by_network_id(network_id):
	for lobby_member_info in LobbyPlayerInfo_dict.values():
		if lobby_member_info.network_id == network_id:
			return lobby_member_info
	for lobby_member_info in LobbyObserverInfo_dict:
		if lobby_member_info.network_id == network_id:
			return lobby_member_info
