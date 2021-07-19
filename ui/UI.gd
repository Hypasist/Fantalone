extends Control

onready var movementArrow = $"MovementArrow"
enum arrowFrame { TOP_RIGHT, BOTTOM_RIGHT, RIGHT, NONE }
func set_no_direction(position):
	set_direction(position, 6)

func set_direction(position, direction):
	movementArrow.show()
	movementArrow.set_position(position)
	match direction:
		0: # TOP LEFT
			movementArrow.set_flip_h(true)
			movementArrow.set_frame(arrowFrame.TOP_RIGHT)
		1: # TOP RIGHT
			movementArrow.set_flip_h(false)
			movementArrow.set_frame(arrowFrame.TOP_RIGHT)
		2: # RIGHT
			movementArrow.set_flip_h(false)
			movementArrow.set_frame(arrowFrame.RIGHT)
		3: # BOTTOM RIGHT
			movementArrow.set_flip_h(false)
			movementArrow.set_frame(arrowFrame.BOTTOM_RIGHT)
		4: # BOTTOM LEFT
			movementArrow.set_flip_h(true)
			movementArrow.set_frame(arrowFrame.BOTTOM_RIGHT)
		5: # LEFT
			movementArrow.set_flip_h(true)
			movementArrow.set_frame(arrowFrame.RIGHT)
		6: # NONE
			movementArrow.set_flip_h(false)
			movementArrow.set_frame(arrowFrame.NONE)

func clear_direction():
	movementArrow.hide()