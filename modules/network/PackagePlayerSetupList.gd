class_name PackagePlayerSetupList
extends PackageBase

var package = []

func add_player_setup(order_id, peer_id, name, color):
	var setup = {
		"order_id": order_id,
		"peer_id": peer_id,
		"name": name,
		"color": color
		}

	package.append(setup)
