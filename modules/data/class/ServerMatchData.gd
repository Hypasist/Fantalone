class_name ServerMatchData
extends MatchData

func start_match():
	setup()
	mod.MapEditor.consume_mockup(mod.ServerData)
	mod.ServerData.MatchData.determine_next_turn_owner()
	mod.MatchNetworkAPI.broadcast_to_clients(MatchNetworkAPI.command.SERVER_START_MATCH, \
										MatchDataPackage.pack_match(mod.ServerData))

func stop_match():
	Terminal.add_log(Debug.INFO, Debug.MATCH, "Match stopped.")
