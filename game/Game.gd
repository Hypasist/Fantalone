extends Node

## TODO:
# animated tiles
# album for tiles
# *tiles with connections?? (water to grass e.g.?)
# long tap for help

#if zoom with pinch, move camera position
onready var logger = $UI/EventLog
onready var game_resolution = get_viewport().size

func _ready():
	$Worldview.setup(game_resolution)
	logger.addLog("Game's ready")

func _process(delta):
	$UI/Debug.set_text(str($UserActionHandler/LongTapTimer.get_time_left()))
	pass

#      (1,0) (2,0) (3,0) (4,0)
#    (0,1) (1,1) (2,1) (3,1) (4,1)
#      (1,2) (2,2) (3,2) (4,2)
#    (0,3) (1,3) (2,3) (3,3) (4,3)
