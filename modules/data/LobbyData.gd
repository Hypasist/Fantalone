class_name LobbyData
extends Node

var Data = null

var MAX_PLAYER_NUM = 8
var MAP_PLAYER_NUM = 3
var MAX_OBSERVER_NUM = 8

const COLOR_UNUSED = -1
# Color / match_id
var available_colors = {}
# network_id / LobbyMemberInfo
var LobbyMemberInfo_dict = {} 
# unique_id / MatchMemberInfo
var MatchPlayerInfo_dict = {} 
# unique_id / MatchMemberInfo
var MatchObserverInfo_dict = {} 

func setup(package:Dictionary={}):
	LobbyMemberInfo_dict = {}
	MatchPlayerInfo_dict = {}
	MatchObserverInfo_dict = {}
	for color in mod.GameData.get_color_list():
		available_colors[color] = COLOR_UNUSED
	if package:
		LobbyDataPackage.unpack(self, package)

func is_map_full():
	return get_players_count() >= get_map_player_size()

func get_map_player_size():
	return MAP_PLAYER_NUM

var next_unique_id = 0
func get_new_unique_id():
	while next_unique_id == MatchMemberInfo.ID_INVALID: 
		next_unique_id = next_unique_id + 1
	var unique_id = next_unique_id
	next_unique_id = next_unique_id + 1
	return unique_id

func get_first_unused_match_id():
	var used_ids = []
	for member in MatchPlayerInfo_dict.values():
		used_ids.append(member.match_id)
	
	var search_range = get_map_player_size()
	for match_id in range(0, search_range):
		if not used_ids.has(match_id):
			return match_id
	
	Terminal.add_log(Debug.ERROR, Debug.LOBBY, "No more ids available!")
	return MatchMemberInfo.ID_INVALID

func get_unused_color():
	for color in available_colors:
		if available_colors[color] == COLOR_UNUSED:
			return color

func reserve_color(color, match_id):
	if color != Color.transparent:
		available_colors[color] = match_id

func free_color(color):
	available_colors[color] = COLOR_UNUSED

func change_player_name_by_unique_id(unique_id, value):
	if MatchPlayerInfo_dict.has(unique_id):
		var member = MatchPlayerInfo_dict[unique_id]
		member.nickname = value


func change_player_color(unique_id, value):
	if MatchPlayerInfo_dict.has(unique_id):
		var member = MatchPlayerInfo_dict[unique_id]
		var palette_array = available_colors.keys()
		var idx = palette_array.find(member.color)
		free_color(member.color)
		while true:
			idx = (idx + value + palette_array.size()) % palette_array.size()
			if available_colors[palette_array[idx]] == COLOR_UNUSED:
				reserve_color(palette_array[idx], member.match_id)
				member.color = palette_array[idx]
				return

func link_lobby_and_match_members(network_id, unique_id):
	var match_member = get_match_member_by_unique_id(unique_id)
	var lobby_member = LobbyMemberInfo_dict[network_id]
	match_member.link_lobby_member(lobby_member)
	lobby_member.link_match_member(match_member)

func new_lobby_member(network_id=NetworkAPI.INVALID_ID, nickname=LobbyMemberInfo.INVALID_NICKNAME, version=""):
	if version == mod.GameData.get_version():
		return add_lobby_member(network_id, nickname)
	else:
		mod.ServerData.Network.disconnect_client(network_id)

func add_lobby_member(network_id=NetworkAPI.INVALID_ID, nickname=LobbyMemberInfo.INVALID_NICKNAME):
	Terminal.add_log(Debug.INFO, Debug.LOBBY, "Adding new lobby member! %d, %s" % [network_id, nickname])
	var new_lobby_member = LobbyMemberInfo.new()
	new_lobby_member.setup(network_id, nickname)
	LobbyMemberInfo_dict[network_id] = new_lobby_member
	if is_map_full():
		var unique_id = add_observer(network_id, nickname)
	else:
		var unique_id = add_player(network_id, MatchPlayerInfo.ID_INVALID, \
						MatchPlayerInfo.HUMAN_PLAYER)

func add_player(network_id, match_id, player_type):
	Terminal.add_log(Debug.INFO, Debug.LOBBY, "Adding new player! %s" % [LobbyMemberInfo_dict[network_id].nickname])
	for observer in get_observers():
		if observer.owner_lobby_member.network_id == network_id:
			remove_match_member(observer.unique_id)
	
	if get_players_count() < MAX_PLAYER_NUM:
		var new_member = MatchPlayerInfo.new()
		var new_color = get_unused_color()
		var nickname = LobbyMemberInfo_dict[network_id].nickname
		new_member.setup_new(match_id, nickname, new_color, player_type)
		reserve_color(new_color, new_member.match_id)
		MatchPlayerInfo_dict[new_member.unique_id] = new_member
		link_lobby_and_match_members(network_id, new_member.unique_id)
		return new_member.unique_id
	else:
		Terminal.add_log(Debug.ERROR, Debug.LOBBY, "No space for player available!")
		return MatchMemberInfo.ID_INVALID

func add_observer(network_id, nickname):
	Terminal.add_log(Debug.INFO, Debug.LOBBY, "Adding new observer! %s" % [nickname])
	if get_observers_count() < MAX_OBSERVER_NUM:
		var new_member = MatchObserverInfo.new()
		new_member.setup_new(nickname)
		MatchObserverInfo_dict[new_member.unique_id] = new_member
		link_lobby_and_match_members(network_id, new_member.unique_id)
		return new_member.unique_id
	else:
		Terminal.add_log(Debug.ERROR, Debug.LOBBY, "No space for observer available!")
		return MatchMemberInfo.ID_INVALID

func remove_match_member(unique_id, move_to_observers=true):
	Terminal.add_log(Debug.INFO, Debug.LOBBY, "Removing match member! %d" % unique_id)
	if MatchPlayerInfo_dict.has(unique_id):
		var match_member = MatchPlayerInfo_dict[unique_id]
		var lobby_member = match_member.owner_lobby_member
		MatchPlayerInfo_dict.erase(unique_id)
		free_color(match_member.color)
		lobby_member.unlink_match_member(match_member)
		if lobby_member.owned_match_members.empty() and move_to_observers:
			add_observer(lobby_member.network_id, lobby_member.nickname)
	
	if MatchObserverInfo_dict.has(unique_id):
		var match_member = MatchObserverInfo_dict[unique_id]
		var lobby_member = match_member.owner_lobby_member
		lobby_member.unlink_match_member(match_member)
		MatchObserverInfo_dict.erase(unique_id)

func remove_lobby_member(network_id):
	Terminal.add_log(Debug.INFO, Debug.LOBBY, "Removing lobby member! %d" % network_id)
	if LobbyMemberInfo_dict.has(network_id):
		var lobby_member = LobbyMemberInfo_dict[network_id]
		for owned_member in lobby_member.owned_match_members:
			if owned_member is MatchPlayerInfo:
				MatchPlayerInfo_dict.erase(owned_member.unique_id)
				free_color(owned_member.color)
			elif owned_member is MatchObserverInfo:
				MatchObserverInfo_dict.erase(owned_member.unique_id)
		LobbyMemberInfo_dict.erase(network_id)

func get_lobby_members():
	return LobbyMemberInfo_dict.values()
func get_players():
	return MatchPlayerInfo_dict.values()
func get_observers():
	return MatchObserverInfo_dict.values()

func get_players_count():
	return MatchPlayerInfo_dict.size()
func get_observers_count():
	return MatchObserverInfo_dict.size()

func get_match_member_by_unique_id(unique_id):
	if MatchPlayerInfo_dict.has(unique_id):
		return MatchPlayerInfo_dict[unique_id]
	if MatchObserverInfo_dict.has(unique_id):
		return MatchObserverInfo_dict[unique_id]
	return MatchMemberInfo.ID_INVALID

func get_player_by_match_id(match_id):
	for member in MatchPlayerInfo_dict.values():
		if member.match_id == match_id:
			return member
	return null
