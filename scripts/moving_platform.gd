extends AnimatableBody2D

@export var distance := 180.0
@export var period := 2.8

var _origin := Vector2.ZERO
var _time := 0.0

func _ready() -> void:
	_origin = position
	sync_to_physics = true

func _physics_process(delta: float) -> void:
	_time += delta
	var offset := sin(_time / period * TAU) * distance * 0.5
	position.x = _origin.x + offset
