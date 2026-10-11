extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	var hud := get_tree().get_first_node_in_group("hud")
	if hud:
		hud.show_clear(body.score)
	body.set_physics_process(false)
