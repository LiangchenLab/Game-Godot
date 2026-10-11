extends Node2D

const GRASS := preload("res://assets/tile_grass.png")
const DIRT := preload("res://assets/tile_dirt.png")
const SPIKE_TEX := preload("res://assets/spike.png")
const COIN_TEX := preload("res://assets/coin_sheet.png")
const FLAG_TEX := preload("res://assets/flag.png")
const CHECK_TEX := preload("res://assets/checkpoint.png")
const CLOUD_TEX := preload("res://assets/cloud.png")
const SLIME_TEX := preload("res://assets/slime_sheet.png")

var coin_total := 0

func _ready() -> void:
	_clouds()
	_build()
	call_deferred("_announce")

func _announce() -> void:
	var hud := get_tree().get_first_node_in_group("hud")
	if hud:
		hud.set_total(coin_total)

func _clouds() -> void:
	for pos in [Vector2(180, 120), Vector2(860, 80), Vector2(1700, 140), Vector2(2600, 90), Vector2(3600, 130), Vector2(4500, 70)]:
		var cloud := Sprite2D.new()
		cloud.texture = CLOUD_TEX
		cloud.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		cloud.position = pos
		cloud.scale = Vector2(2, 2)
		cloud.z_index = -5
		add_child(cloud)

func _build() -> void:
	# Act1 教学：长平地 + 星星引导；首缺口后再放单尖刺（避免第一跳即死）
	_run(0, 28, 560)
	_run(1000, 6, 560)
	_run(1280, 10, 560)
	_spikes(1480, 560)

	# Act2 加压：高台 → 移动平台 → 检查点 → 史莱姆 + 尖刺
	_run(1680, 6, 430)
	_run(2000, 12, 560)
	_moving(Vector2(2480, 470))
	_run(2740, 8, 400)
	_checkpoint(Vector2(2860, 368))
	_run(3120, 14, 560)
	_slime(Vector2(3360, 520), 3160, 3500)
	_spikes(3520, 560)
	_spikes(3580, 560)

	# Act3 收尾：三级阶梯上升 + 落地大平台过旗
	_run(3760, 4, 480)
	_run(4000, 4, 400)
	_run(4240, 4, 320)
	_run(4480, 12, 560)
	_goal(Vector2(4760, 500))
	_pit(Vector2(2600, 980), Vector2(5400, 80))

	for pos in [
		# Act1 地上引导星
		Vector2(220, 490), Vector2(420, 490), Vector2(680, 490),
		Vector2(1100, 490), Vector2(1400, 490),
		# Act2
		Vector2(1760, 360), Vector2(1880, 360), Vector2(2200, 490),
		Vector2(2480, 390), Vector2(2860, 320), Vector2(3280, 490),
		# Act3 收尾星
		Vector2(3840, 410), Vector2(4080, 330), Vector2(4320, 250),
		Vector2(4600, 490), Vector2(4700, 490),
	]:
		_coin(pos)
	_spawn(Vector2(80, 512))

func _spawn(at: Vector2) -> void:
	var player := preload("res://scenes/player.tscn").instantiate()
	player.position = at
	add_child(player)

func _run(x: int, tiles: int, top: int) -> void:
	for i in tiles:
		var grass := Sprite2D.new()
		grass.texture = GRASS
		grass.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		grass.position = Vector2(x + 16 + i * 32, top)
		add_child(grass)
		var dirt := Sprite2D.new()
		dirt.texture = DIRT
		dirt.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		dirt.position = Vector2(x + 16 + i * 32, top + 32)
		add_child(dirt)
	var size := Vector2(tiles * 32, 64)
	_solid(Vector2(x + size.x * 0.5, top + 16), size)

func _solid(center: Vector2, size: Vector2) -> void:
	var body := StaticBody2D.new()
	body.position = center
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = size
	shape.shape = rect
	body.add_child(shape)
	add_child(body)

func _spikes(x: int, surface_top: int) -> void:
	var area := Area2D.new()
	area.position = Vector2(x + 16, surface_top - 16)
	area.collision_layer = 4
	area.collision_mask = 2
	area.set_script(preload("res://scripts/pit.gd"))
	var vis := Sprite2D.new()
	vis.texture = SPIKE_TEX
	vis.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(28, 16)
	shape.position = Vector2(0, 8)
	shape.shape = rect
	area.add_child(vis)
	area.add_child(shape)
	add_child(area)

func _coin(at: Vector2) -> void:
	coin_total += 1
	var area := Area2D.new()
	area.position = at
	area.collision_layer = 4
	area.collision_mask = 2
	area.set_script(preload("res://scripts/coin.gd"))
	var vis := AnimatedSprite2D.new()
	vis.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	vis.scale = Vector2(2, 2)
	var frames := SpriteFrames.new()
	frames.add_animation("spin")
	frames.set_animation_loop("spin", true)
	frames.set_animation_speed("spin", 6.0)
	for i in 2:
		var atlas := AtlasTexture.new()
		atlas.atlas = COIN_TEX
		atlas.region = Rect2(i * 16, 0, 16, 16)
		frames.add_frame("spin", atlas)
	vis.sprite_frames = frames
	vis.play("spin")
	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 14.0
	shape.shape = circle
	area.add_child(vis)
	area.add_child(shape)
	add_child(area)

func _goal(at: Vector2) -> void:
	var area := _marker(at, FLAG_TEX, preload("res://scripts/goal.gd"))
	add_child(area)

func _checkpoint(at: Vector2) -> void:
	add_child(_marker(at, CHECK_TEX, preload("res://scripts/checkpoint.gd")))

func _marker(at: Vector2, tex: Texture2D, script: Script) -> Area2D:
	var area := Area2D.new()
	area.position = at
	area.collision_layer = 4
	area.collision_mask = 2
	area.set_script(script)
	var vis := Sprite2D.new()
	vis.texture = tex
	vis.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	vis.scale = Vector2(2, 2)
	vis.position = Vector2(0, -24)
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(36, 80)
	shape.position = Vector2(8, -16)
	shape.shape = rect
	area.add_child(vis)
	area.add_child(shape)
	return area

func _moving(at: Vector2) -> void:
	var body := AnimatableBody2D.new()
	body.position = at
	body.set_script(preload("res://scripts/moving_platform.gd"))
	var vis := Sprite2D.new()
	vis.texture = GRASS
	vis.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	vis.scale = Vector2(5, 1)
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(160, 32)
	shape.shape = rect
	body.add_child(vis)
	body.add_child(shape)
	add_child(body)

func _slime(at: Vector2, left: float, right: float) -> void:
	var area := Area2D.new()
	area.position = at
	area.collision_layer = 4
	area.collision_mask = 2
	area.set_script(preload("res://scripts/enemy.gd"))
	area.set("left_limit", left)
	area.set("right_limit", right)
	var vis := AnimatedSprite2D.new()
	vis.name = "Sprite"
	vis.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	vis.scale = Vector2(2, 2)
	var frames := SpriteFrames.new()
	frames.add_animation("crawl")
	frames.set_animation_loop("crawl", true)
	frames.set_animation_speed("crawl", 4.0)
	for i in 2:
		var atlas := AtlasTexture.new()
		atlas.atlas = SLIME_TEX
		# Kenney 角色帧 32×32（旧版史莱姆条带曾为 32×24）
		atlas.region = Rect2(i * 32, 0, 32, 32)
		frames.add_frame("crawl", atlas)
	vis.sprite_frames = frames
	vis.play("crawl")
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(40, 28)
	shape.shape = rect
	area.add_child(vis)
	area.add_child(shape)
	add_child(area)

func _pit(center: Vector2, size: Vector2) -> void:
	var area := Area2D.new()
	area.position = center
	area.collision_layer = 4
	area.collision_mask = 2
	area.set_script(preload("res://scripts/pit.gd"))
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = size
	shape.shape = rect
	area.add_child(shape)
	add_child(area)
