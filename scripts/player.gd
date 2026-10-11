extends CharacterBody2D

const SPEED := 280.0
const JUMP_VELOCITY := -460.0

var score := 0
var spawn_position := Vector2.ZERO

@onready var visual: Polygon2D = $Visual

func _ready() -> void:
	add_to_group("player")
	spawn_position = global_position

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		visual.scale.x = -1.0 if direction < 0.0 else 1.0
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED)

	move_and_slide()

func add_score(amount: int) -> void:
	score += amount
	var hud := get_tree().get_first_node_in_group("hud")
	if hud:
		hud.set_score(score)

func respawn() -> void:
	velocity = Vector2.ZERO
	global_position = spawn_position
