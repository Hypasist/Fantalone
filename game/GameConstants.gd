class_name GameConstants

enum { TOP_LEFT = 0, TOP_RIGHT, RIGHT, BOTTOM_RIGHT, BOTTOM_LEFT, LEFT, NONE }
const opp_dir = [ BOTTOM_RIGHT, BOTTOM_LEFT, LEFT, TOP_LEFT, TOP_RIGHT, RIGHT ]

const directions = {TOP_LEFT	:	[ 0, -1],
					TOP_RIGHT	:	[ 1, -1],
					RIGHT		:	[ 1,  0],
					BOTTOM_RIGHT:	[ 0,  1],
					BOTTOM_LEFT :	[-1,  1],
					LEFT		:	[-1,  0]}