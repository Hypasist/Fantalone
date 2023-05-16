class_name PopupSplash
extends PopupBase

const splash_timelimit_ms = 2000
const tween_time_s = 0.45

var splash_timer = null
var splash_tween = null
var showing = true

func setup(size:Vector2=Vector2(0,0)):
	.setup(size)
	splash_timer = Timer.new()
	add_child(splash_timer)
	splash_tween = CustomTween.new()
	add_child(splash_tween)
	splash_tween.connect("tween_completed", self, "_on_Tween_completed")
	splash_tween.initialize(self, "modulate:a", 0, 1, tween_time_s, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	splash_tween.start_normal(0)

func set_info(color):
	$Box/Label.set_text("TERAZ TURA KOLORU %s" % [mod.GameData.get_color_name_by_color(color)])
	$Box/ColorRect.set_frame_color(color)

func start_splash_timer():
	splash_timer.connect("timeout", self, "_on_Timer_completed")
	splash_timer.start(splash_timelimit_ms/1000)

func close_up():
	showing = false
	splash_timer.stop()
	splash_tween.start_reverse(modulate.a)

func _on_Tween_completed(_object = null, _key = null):
	if showing:
		start_splash_timer()
	else:
		mod.Popups.pop_popup(self)

func _on_Timer_completed():
	close_up()
func _on_Button_button_down():
	close_up()
