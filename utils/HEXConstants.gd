class_name HEXConstants
extends Reference

enum { TOP_LEFT = 0, TOP_RIGHT, RIGHT, BOTTOM_RIGHT, BOTTOM_LEFT, LEFT, NONE }
const NUMBER_OF_DIRECTIONS = 6

static func opposite(d1):
	return (d1 + 3) % NUMBER_OF_DIRECTIONS

const directions = {TOP_LEFT	:	[ 0, -1],
					TOP_RIGHT	:	[ 1, -1],
					RIGHT		:	[ 1,  0],
					BOTTOM_RIGHT:	[ 0,  1],
					BOTTOM_LEFT :	[-1,  1],
					LEFT		:	[-1,  0]}

static func correlated(d1, d2):
	return (d1 % 3) == (d2 % 3)
	
static func getRelative(d1, number):
	return (d1 + number + NUMBER_OF_DIRECTIONS) % NUMBER_OF_DIRECTIONS
