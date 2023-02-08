class_name ClientLobbyData
extends LobbyData

# ADMIN PRIVILEGES
var admin_privileges = false
func set_admin_privileges(is_admin):
	admin_privileges = is_admin
func is_admin():
	return admin_privileges

# SETUP

func setup(package:Dictionary={}):
	LobbyMemberInfo_dict = {}
	MatchPlayerInfo_dict = {}
	MatchObserverInfo_dict = {}
	for color in mod.GameData.get_color_list():
		available_colors[color] = COLOR_UNUSED
	if package:
		LobbyDataPackage.unpack(self, package)

