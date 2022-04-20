class_name PopupBase
extends NinePatchRect

static func set_anchors_by_size(object, size = Vector2(1,1)):
	var diff = Vector2((1 - size.x)/2, (1 - size.y)/2)
	object.set_anchor(MARGIN_LEFT, diff.x, true)
	object.set_anchor(MARGIN_TOP, diff.y, true)
	object.set_anchor(MARGIN_RIGHT, 1 - diff.x, true)
	object.set_anchor(MARGIN_BOTTOM, 1 - diff.y, true)

static func set_anchors_by_anchors(object, anchor_x = Vector2(0,1), anchor_y = Vector2(0,1)):
	object.set_anchor(MARGIN_LEFT, anchor_x.x, true)
	object.set_anchor(MARGIN_TOP, anchor_y.x, true)
	object.set_anchor(MARGIN_RIGHT, anchor_x.y, true)
	object.set_anchor(MARGIN_BOTTOM, anchor_y.y, true)

const internal_top_padding = 40
const internal_leftright_padding = 50
const internal_bot_padding = 5
func set_popuptext_margins():
	$MarginContainer.set("custom_constants/margin_top", internal_top_padding)
	$MarginContainer.set("custom_constants/margin_left", internal_leftright_padding)
	$MarginContainer.set("custom_constants/margin_bottom", -internal_bot_padding)
	$MarginContainer.set("custom_constants/margin_right", -internal_leftright_padding)

func setup(text:String="", size:Vector2=Vector2(0,0)):
	$MarginContainer/PopupText.set_text(text)
	size = Utils.clamp2(size, Vector2(0,0), Vector2(1,1))
	set_anchors_by_size(self, size)
	set_popuptext_margins()
	set_anchors_by_anchors($MarginContainer/PopupText, Vector2(0,1), Vector2(0,75))

func destroy():
	queue_free()
