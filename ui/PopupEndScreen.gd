class_name PopupEndScreen
extends PopupBase

var EndScreenSummaryBar = preload("res://ui/EndScreenSummaryBar.tscn")
var endscreen_bar_list = {}

func setup(size:Vector2=Vector2(0,0)):
	.setup(size)
#	set_anchors_by_anchors($MarginContainer/HBoxContainer, Vector2(0.7, 0), Vector2(1,1))
	setup_summary_panel()

func setup_summary_panel():
	for player in mod.ClientData.LobbyData.get_players():
		var summary_bar = EndScreenSummaryBar.instance()
		$Box/EndScreenSummaryPanel.add_child(summary_bar)
		endscreen_bar_list[player.match_id] = summary_bar
		var turn_owner = (mod.ClientData.MatchData.get_turn_owner() == player.match_id)
		var army_size = mod.ClientData.MatchData.get_players_units_num(player.match_id)
		endscreen_bar_list[player.match_id].update_bar(turn_owner, player.color, player.nickname, army_size)

func _on_Button_pressed():
	mod.Popups.pop_popup(self)
	mod.ClientData.MatchData.stop_match()
	mod.Game.exit_game()
