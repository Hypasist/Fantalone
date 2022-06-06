class_name PopupBase
extends NinePatchRect

static func set_anchors_by_size(object, size = Vector2(1,1)):
	var diff = Vector2((1 - size.x)/2, (1 - size.y)/2)
	object.set_anchor(MARGIN_LEFT, diff.x, true)
	object.set_anchor(MARGIN_TOP, diff.y, true)
	object.set_anchor(MARGIN_RIGHT, 1 - diff.x, true)
	object.set_anchor(MARGIN_BOTTOM, 1 - diff.y, true)

static func set_anchors_by_anchors(object, top_left = Vector2(0,0), bot_right = Vector2(1,1)):
	object.set_anchor(MARGIN_TOP, top_left.x, true)
	object.set_anchor(MARGIN_LEFT, top_left.y, true)
	object.set_anchor(MARGIN_BOTTOM, bot_right.x, true)
	object.set_anchor(MARGIN_RIGHT, bot_right.y, true)

func setup(size:Vector2=Vector2(1,1)):
	size = Utils.clamp2(size, Vector2(0,0), Vector2(1,1))
	set_anchors_by_size(self, size)

func destroy():
	queue_free()
