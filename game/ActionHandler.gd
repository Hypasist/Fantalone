extends Node

const PopupBase = preload("res://ui/PopupBase.tscn")
onready var eventlog = $"../UI/EventLog"
onready var hoverlist = $"../Worldview/Worldmap".hoverlist
onready var gamelogic = $"../GameLogic"
onready var UI = $"../UI"

var moveInfo = {}

var dragRelativeTreshold = 100
func _on_UserActionManager_action_drag_active(position, relative):
	moveInfo.clear()
	if gamelogic.any_selected() == false:
		UI.clear_direction()
	elif relative.length() < dragRelativeTreshold:
		UI.set_no_direction_arrow(position)
	else:
		var direction = touchscreenScripts.angleVector2direction(relative)
		moveInfo = gamelogic.considerMoving(direction)
		if moveInfo["isMoveValid"]:
			UI.set_direction_arrow(position, direction)
		else:
			UI.set_invalid_arrow(position)

func _on_UserActionManager_action_drag_stopped():
	UI.clear_direction()
	if moveInfo.empty() == false:
		gamelogic.makeMove(moveInfo)
		moveInfo.clear()

func _on_UserActionManager_action_longtap_active(position):
	eventlog.addLog(str("longtap",position))


func _on_UserActionManager_action_longtap_stopped():
	eventlog.addLog(str("longtap stop"))


func _on_UserActionManager_action_shorttap(position):
	for hovered_object in hoverlist:
		if(hovered_object.is_in_group("Actors")):
			gamelogic.new_selected(hovered_object)
			return

func _on_UserActionManager_action_cancel():
	pass # Replace with function body.
