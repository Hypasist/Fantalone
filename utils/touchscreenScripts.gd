class_name touchscreenScripts
extends Reference

var perspective_ratio = Vector2(1.0, 0.5)
const offset_of_0direction = (-5.0*PI/6.0)
const angle_per_direction = (PI/3.0)
static func angleVector2direction(angleVector):
	var plainRelative = angleVector # / perspective_ratio
	# change to angle and offset to positive numbers
	var angle = fmod(plainRelative.angle() + 2*PI, 2*PI)
	# offset to the angle of direction 0 (TOP_LEFT)
	angle = fmod(angle - offset_of_0direction, 2*PI)
	# match to direction
	var direction = int(angle / (PI/3.0))
	return direction
