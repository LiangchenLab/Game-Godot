extends CanvasLayer

var coin_total := 12
var score := 0
var started := false

var score_label: Label
var start_panel: Panel
var pause_panel: Panel
var clear_panel: Panel
var clear_label: Label

func _ready() -> void:
	add_to_group("hud")
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build()
	set_score(0)
	get_tree().paused = true

func _unhandled_input(event: InputEvent) -> void:
	if started and event.is_action_pressed("ui_cancel"):
		_toggle_pause()

func set_total(value: int) -> void:
	coin_total = value
	set_score(score)

func set_score(value: int) -> void:
	score = value
	if score_label:
		score_label.text = "星星  %d / %d" % [score, coin_total]

func show_clear(found: int) -> void:
	clear_label.text = "到站了\n收集 %d / %d 颗星星" % [found, coin_total]
	clear_panel.visible = true
	get_tree().paused = true

func _build() -> void:
	score_label = Label.new()
	score_label.position = Vector2(24, 16)
	score_label.add_theme_font_size_override("font_size", 28)
	score_label.add_theme_color_override("font_color", Color(0.12, 0.16, 0.2))
	add_child(score_label)

	var hint := Label.new()
	hint.position = Vector2(24, 52)
	hint.text = "A D 移动，空格跳跃。手机用屏幕下方按钮。Esc 暂停。"
	hint.add_theme_font_size_override("font_size", 18)
	hint.add_theme_color_override("font_color", Color(0.16, 0.2, 0.24))
	add_child(hint)

	var pause_button := Button.new()
	pause_button.text = "暂停"
	pause_button.position = Vector2(1160, 16)
	pause_button.size = Vector2(88, 40)
	pause_button.pressed.connect(_toggle_pause)
	add_child(pause_button)

	start_panel = _panel(Vector2(340, 160), Vector2(600, 360))
	var title := Label.new()
	title.text = "岭行"
	title.position = Vector2(0, 48)
	title.size = Vector2(600, 80)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 64)
	title.add_theme_color_override("font_color", Color(0.96, 0.95, 0.9))
	start_panel.add_child(title)
	var sub := Label.new()
	sub.text = "沿山路跑到红旗"
	sub.position = Vector2(0, 140)
	sub.size = Vector2(600, 40)
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sub.add_theme_font_size_override("font_size", 24)
	sub.add_theme_color_override("font_color", Color(0.9, 0.9, 0.86))
	start_panel.add_child(sub)
	var start_button := Button.new()
	start_button.text = "开始"
	start_button.position = Vector2(200, 230)
	start_button.size = Vector2(200, 64)
	start_button.pressed.connect(_start)
	start_panel.add_child(start_button)
	add_child(start_panel)

	pause_panel = _panel(Vector2(390, 220), Vector2(500, 260))
	pause_panel.visible = false
	var pause_label := Label.new()
	pause_label.text = "暂停"
	pause_label.position = Vector2(0, 36)
	pause_label.size = Vector2(500, 60)
	pause_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	pause_label.add_theme_font_size_override("font_size", 40)
	pause_label.add_theme_color_override("font_color", Color(0.96, 0.95, 0.9))
	pause_panel.add_child(pause_label)
	var resume := Button.new()
	resume.text = "继续"
	resume.position = Vector2(150, 140)
	resume.size = Vector2(200, 56)
	resume.pressed.connect(_toggle_pause)
	pause_panel.add_child(resume)
	add_child(pause_panel)

	clear_panel = _panel(Vector2(340, 180), Vector2(600, 320))
	clear_panel.visible = false
	clear_label = Label.new()
	clear_label.position = Vector2(0, 36)
	clear_label.size = Vector2(600, 140)
	clear_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	clear_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	clear_label.add_theme_font_size_override("font_size", 36)
	clear_label.add_theme_color_override("font_color", Color(0.96, 0.95, 0.9))
	clear_panel.add_child(clear_label)
	var again := Button.new()
	again.text = "再玩一次"
	again.position = Vector2(200, 210)
	again.size = Vector2(200, 56)
	again.pressed.connect(_restart)
	clear_panel.add_child(again)
	add_child(clear_panel)

	_touch(Vector2(36, 560), "move_left", "左")
	_touch(Vector2(150, 560), "move_right", "右")
	_touch(Vector2(1120, 540), "jump", "跳")

func _panel(at: Vector2, size: Vector2) -> Panel:
	var panel := Panel.new()
	panel.position = at
	panel.size = size
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.08, 0.11, 0.14, 0.92)
	style.set_corner_radius_all(18)
	panel.add_theme_stylebox_override("panel", style)
	return panel

func _touch(at: Vector2, action: String, caption: String) -> void:
	var button := TouchScreenButton.new()
	button.texture_normal = load("res://assets/touch_button.png")
	button.position = at
	button.action = action
	button.passby_press = true
	add_child(button)
	var label := Label.new()
	label.text = caption
	label.position = at + Vector2(30, 30)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_size_override("font_size", 28)
	label.add_theme_color_override("font_color", Color(0.96, 0.95, 0.9))
	add_child(label)

func _start() -> void:
	started = true
	start_panel.visible = false
	get_tree().paused = false
	var player := get_tree().get_first_node_in_group("player")
	if player:
		player.playing = true

func _toggle_pause() -> void:
	if not started or clear_panel.visible:
		return
	var paused := not get_tree().paused
	get_tree().paused = paused
	pause_panel.visible = paused

func _restart() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
