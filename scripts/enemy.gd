extends Area2D

@export var left_limit := 0.0
@export var right_limit := 200.0
var _dir := 1.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	position.x += _dir * 70.0 * delta
	if position.x > right_limit:
		_dir = -1.0
	elif position.x < left_limit:
		_dir = 1.0
	var sprite := get_node_or_null("Sprite")
	if sprite:
		sprite.scale.x = -2.0 if _dir < 0.0 else 2.0

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player") and body.has_method("respawn"):
		body.respawn()
