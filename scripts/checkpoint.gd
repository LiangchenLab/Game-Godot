extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player") and body.has_method("set_checkpoint"):
		body.set_checkpoint(global_position + Vector2(0, 8))
		var vis := get_node_or_null("Sprite")
		if vis == null:
			for child in get_children():
				if child is CanvasItem:
					child.modulate = Color(0.7, 0.9, 1.0)
