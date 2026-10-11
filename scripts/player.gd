extends CharacterBody2D

const SPEED := 260.0
const JUMP_VELOCITY := -520.0
## 手感：离台后仍可起跳（关卡设计-MVP 80–120ms）
const COYOTE_TIME := 0.1
## 手感：落地前按跳，落地立即起跳
const JUMP_BUFFER := 0.1
const SPRITE_SCALE := 2.2

var score := 0
var spawn_position := Vector2.ZERO
var playing := false
var coyote_timer := 0.0
var jump_buffer_timer := 0.0

@onready var sprite: AnimatedSprite2D = $Sprite

func _ready() -> void:
	add_to_group("player")
	spawn_position = global_position
	_setup_frames()
	sprite.scale = Vector2(SPRITE_SCALE, SPRITE_SCALE)
	sprite.play("idle")

## Pixel Adventure：Idle/Run/Jump 分表加载（行业常用多帧动画，不再 6 格拼凑）
func _setup_frames() -> void:
	var frames := SpriteFrames.new()
	frames.add_animation("idle")
	frames.add_animation("run")
	frames.add_animation("jump")
	frames.set_animation_loop("idle", true)
	frames.set_animation_loop("run", true)
	frames.set_animation_loop("jump", false)
	frames.set_animation_speed("idle", 12.0)
	frames.set_animation_speed("run", 16.0)
	frames.set_animation_speed("jump", 8.0)

	_add_strip(frames, "idle", "res://assets/player_idle.png", 32)
	_add_strip(frames, "run", "res://assets/player_run.png", 32)
	_add_strip(frames, "jump", "res://assets/player_jump.png", 32)
	sprite.sprite_frames = frames
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

func _add_strip(frames: SpriteFrames, anim: String, path: String, frame_w: int) -> void:
	var tex: Texture2D = load(path)
	if tex == null:
		return
	var n := maxi(1, int(tex.get_width() / frame_w))
	for i in n:
		var atlas := AtlasTexture.new()
		atlas.atlas = tex
		atlas.region = Rect2(i * frame_w, 0, frame_w, tex.get_height())
		frames.add_frame(anim, atlas)

func _physics_process(delta: float) -> void:
	if not playing:
		velocity = Vector2.ZERO
		sprite.play("idle")
		return

	var on_floor := is_on_floor()
	if on_floor:
		coyote_timer = COYOTE_TIME
	else:
		coyote_timer = maxf(coyote_timer - delta, 0.0)
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = JUMP_BUFFER
	else:
		jump_buffer_timer = maxf(jump_buffer_timer - delta, 0.0)

	if jump_buffer_timer > 0.0 and (on_floor or coyote_timer > 0.0):
		velocity.y = JUMP_VELOCITY
		jump_buffer_timer = 0.0
		coyote_timer = 0.0

	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		sprite.scale.x = (-SPRITE_SCALE) if direction < 0.0 else SPRITE_SCALE
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
