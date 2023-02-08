class_name ServerLobbyData
extends LobbyData

func setup(package:Dictionary={}):
	LobbyMemberInfo_dict = {}
	MatchPlayerInfo_dict = {}
	MatchObserverInfo_dict = {}
	for color in mod.GameData.get_color_list():
		available_colors[color] = COLOR_UNUSED
	if package:
		LobbyDataPackage.unpack(self, package)
