extends CharacterBody2D

const SPEED := 260.0
const JUMP_VELOCITY := -520.0

var score := 0
var spawn_position := Vector2.ZERO
var playing := false

@onready var sprite: AnimatedSprite2D = $Sprite

func _ready() -> void:
	add_to_group("player")
	spawn_position = global_position
	_setup_frames()
	sprite.play("idle")

func _setup_frames() -> void:
	var tex: Texture2D = load("res://assets/player_sheet.png")
	var frames := SpriteFrames.new()
	frames.add_animation("idle")
	frames.add_animation("run")
	frames.add_animation("jump")
	frames.set_animation_loop("idle", true)
	frames.set_animation_loop("run", true)
	frames.set_animation_loop("jump", false)
	frames.set_animation_speed("idle", 4.0)
	frames.set_animation_speed("run", 10.0)
	frames.add_frame("idle", _atlas(tex, 0))
	for i in range(1, 5):
		frames.add_frame("run", _atlas(tex, i))
	frames.add_frame("jump", _atlas(tex, 5))
	sprite.sprite_frames = frames

func _atlas(tex: Texture2D, index: int) -> AtlasTexture:
	var atlas := AtlasTexture.new()
	atlas.atlas = tex
	atlas.region = Rect2(index * 32, 0, 32, 32)
	return atlas

func _physics_process(delta: float) -> void:
	if not playing:
		velocity = Vector2.ZERO
		sprite.play("idle")
		return
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		sprite.scale.x = -2.0 if direction < 0.0 else 2.0
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED)
	if not is_on_floor():
		sprite.play("jump")
	elif abs(velocity.x) > 10.0:
		sprite.play("run")
	else:
		sprite.play("idle")
	move_and_slide()

func add_score(amount: int) -> void:
	score += amount
	var hud := get_tree().get_first_node_in_group("hud")
	if hud:
		hud.set_score(score)

func set_checkpoint(at: Vector2) -> void:
	spawn_position = at

func respawn() -> void:
	velocity = Vector2.ZERO
	global_position = spawn_position
