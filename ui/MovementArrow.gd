extends Sprite

enum arrowFrame { TOP_RIGHT, BOTTOM_RIGHT, RIGHT, NONE, INVALID }
func set_no_direction_arrow(position):
	set_direction_arrow(position, 6)

func set_invalid_arrow(position):
	set_direction_arrow(position, 7)

func set_direction_arrow(position, direction):
	show()
	set_position(position)
	match direction:
		0: # TOP LEFT
			set_flip_h(true)
			set_frame(arrowFrame.TOP_RIGHT)
		1: # TOP RIGHT
			set_flip_h(false)
			set_frame(arrowFrame.TOP_RIGHT)
		2: # RIGHT
			set_flip_h(false)
			set_frame(arrowFrame.RIGHT)
		3: # BOTTOM RIGHT
			set_flip_h(false)
			set_frame(arrowFrame.BOTTOM_RIGHT)
		4: # BOTTOM LEFT
			set_flip_h(true)
			set_frame(arrowFrame.BOTTOM_RIGHT)
		5: # LEFT
			set_flip_h(true)
			set_frame(arrowFrame.RIGHT)
		6: # NONE
			set_flip_h(false)
			set_frame(arrowFrame.NONE)
		7: # INVALID
			set_flip_h(false)
			set_frame(arrowFrame.INVALID)

func clear_direction():
	hide()