class_name Lobby
extends Node

var MAX_PLAYER_NUM = 8
var MAP_PLAYER_NUM = 4
var MAX_OBSERVER_NUM = 8

const NO_ID = -1
const COLOR_UNUSED = -1
# Color / id
var available_colors = {}
# network_id / LobbyMemberInfo
var LobbyMemberInfo_dict = {} 

func setup(package:Array=[]):
	LobbyMemberInfo_dict = {}
	for color in mod.Database.get_colorlist():
		available_colors[color] = COLOR_UNUSED
	if package:
		for record in package:
			var new_member = LobbyMemberInfo.new()
			new_member.setup(record["id"], record["network_id"], \
				record["type"], record["nickname"], \
				record["color"], record["player_type"])
			reserve_color(record["color"], record["id"])
			LobbyMemberInfo_dict[new_member.network_id] = new_member


func get_map_player_size():
	return MAP_PLAYER_NUM


func get_unused_id(type = LobbyMemberInfo.TYPE_OBSERVER):
	var used_ids = []
	for member in LobbyMemberInfo_dict.values():
		if member.type == type:
			used_ids.append(member.id)
	
	var search_range = get_map_player_size() if (type == LobbyMemberInfo.TYPE_PLAYER) else MAX_OBSERVER_NUM
	for id in range(0, search_range):
		if not used_ids.has(id):
			return id
	
	Terminal.add_log(Debug.ERROR, "No more ids available!")
	return NO_ID


func get_unused_color():
	for color in available_colors:
		if available_colors[color] == COLOR_UNUSED:
			return color

func reserve_color(color, id):
	if color != Color.transparent:
		available_colors[color] = id

func free_color(color):
	available_colors[color] = COLOR_UNUSED


func change_player_color(id, value):
	var member = get_member_by_id_type(id, LobbyMemberInfo.TYPE_PLAYER)
	var palette_array = available_colors.keys()
	var idx = palette_array.find(member.color)
	free_color(member.color)
	
	while true:
		idx = (idx + value + palette_array.size()) % palette_array.size()
		if available_colors[palette_array[idx]] == COLOR_UNUSED:
			reserve_color(palette_array[idx], id)
			member.color = palette_array[idx]
			return

func get_member_count(type=LobbyMemberInfo.TYPE_MEMBER):
	var count = 0
	for member in LobbyMemberInfo_dict.values(): 
		if type == LobbyMemberInfo.TYPE_MEMBER || type == member.type:
			count += 1
	return count

func add_update_member(network_id, type, nickname):
	print("Adding new member! %d, %d, %s" % [network_id, type, nickname])
	if type == LobbyMemberInfo.TYPE_PLAYER:
		if get_member_count(LobbyMemberInfo.TYPE_PLAYER) < MAX_PLAYER_NUM:
			var new_member = LobbyMemberInfo.new()
			var new_id = get_unused_id(LobbyMemberInfo.TYPE_PLAYER)
			var new_color = get_unused_color()
			reserve_color(new_color, new_id)
			new_member.setup(new_id, network_id, LobbyMemberInfo.TYPE_PLAYER, nickname, new_color)
			LobbyMemberInfo_dict[network_id] = new_member
		else:
			type = LobbyMemberInfo.TYPE_OBSERVER
	
	if type == LobbyMemberInfo.TYPE_OBSERVER:
		if get_member_count(LobbyMemberInfo.TYPE_OBSERVER) < MAX_OBSERVER_NUM:
			var new_member = LobbyMemberInfo.new()
			var new_id = get_unused_id(LobbyMemberInfo.TYPE_OBSERVER)
			new_member.setup(new_id, network_id, LobbyMemberInfo.TYPE_OBSERVER, nickname)
			LobbyMemberInfo_dict[network_id] = new_member
		else:
			Terminal.add_log(Debug.ERROR, "No space for observer available!")

func remove_member(network_id):
	print("Removing a member! %d" % network_id)
	if LobbyMemberInfo_dict.has(network_id):
		var member = LobbyMemberInfo_dict[network_id]
		free_color(member.color)
		LobbyMemberInfo_dict.erase(network_id)

func move_observer_to_players(id):
	var member = get_member_by_id_type(id, LobbyMemberInfo.TYPE_OBSERVER)
	var new_id = get_unused_id(LobbyMemberInfo.TYPE_PLAYER)
	var new_color = get_unused_color()
	reserve_color(new_color, new_id)
	member.color = new_color
	member.type = LobbyMemberInfo.TYPE_PLAYER
	member.id = new_id

func move_player_to_observers(id):
	var member = get_member_by_id_type(id, LobbyMemberInfo.TYPE_PLAYER)
	var new_id = get_unused_id(LobbyMemberInfo.TYPE_OBSERVER)
	free_color(member.color)
	member.color = LobbyMemberInfo.COLOR_INVALID
	member.type = LobbyMemberInfo.TYPE_OBSERVER
	member.id = new_id
	
func get_members(type=LobbyMemberInfo.TYPE_MEMBER):
	var result = []
	for member in LobbyMemberInfo_dict.values():
		if type == LobbyMemberInfo.TYPE_MEMBER || type == member.type:
			result.append(member)
	return result

func get_member_by_network_id(network_id):
	return LobbyMemberInfo_dict[network_id]

func get_member_by_id_type(id, type=LobbyMemberInfo.TYPE_PLAYER):
	for member in LobbyMemberInfo_dict.values():
		if member.id == id and member.type == type:
			return member
