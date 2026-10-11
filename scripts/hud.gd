extends CanvasLayer

@onready var score_label: Label = $ScoreLabel
@onready var clear_panel: Panel = $ClearPanel
@onready var clear_label: Label = $ClearPanel/ClearLabel

func _ready() -> void:
	add_to_group("hud")
	clear_panel.visible = false
	set_score(0)

func set_score(value: int) -> void:
	score_label.text = "星星  %d / 8" % value

func show_clear(score: int) -> void:
	clear_panel.visible = true
	clear_label.text = "到站了\n收集 %d / 8 颗星星" % score
