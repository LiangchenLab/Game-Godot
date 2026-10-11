extends Node2D

## 岭行关卡：Kenney 像素资源 + 远景/装饰铺陈（画面不能只剩色条+一条平台）

const GRASS_L := preload("res://assets/tile_grass_l.png")
const GRASS_M := preload("res://assets/tile_grass_m.png")
const GRASS_R := preload("res://assets/tile_grass_r.png")
const DIRT := preload("res://assets/tile_dirt.png")
const SPIKE_TEX := preload("res://assets/spike.png")
const COIN_TEX := preload("res://assets/coin_sheet.png")
const FLAG_TEX := preload("res://assets/flag.png")
const CHECK_TEX := preload("res://assets/checkpoint.png")
const CLOUD_TEX := preload("res://assets/cloud.png")
const SLIME_TEX := preload("res://assets/slime_sheet.png")
const BG_FAR := preload("res://assets/bg_far.png")
const SUN_TEX := preload("res://assets/sun.png")
const TREE_TEX := preload("res://assets/decor_tree.png")
const PINE_TEX := preload("res://assets/decor_pine.png")
const BUSH_TEX := preload("res://assets/decor_bush.png")
const MUSH_TEX := preload("res://assets/decor_mushroom.png")

var coin_total := 0

func _ready() -> void:
	_scenery()
	_build()
	call_deferred("_announce")

func _announce() -> void:
	var hud := get_tree().get_first_node_in_group("hud")
	if hud:
		hud.set_total(coin_total)

## 远景：太阳 + 重复山景条 + 云层（z 在平台后）
func _scenery() -> void:
	var sun := Sprite2D.new()
	sun.texture = SUN_TEX
	sun.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sun.position = Vector2(980, 110)
	sun.scale = Vector2(2.2, 2.2)
	sun.z_index = -20
	add_child(sun)

	# 远景山带：沿关卡横向平铺
	var far_w := BG_FAR.get_width() * 2.5
	var x := -80.0
	while x < 5200.0:
		var hill := Sprite2D.new()
		hill.texture = BG_FAR
		hill.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		hill.centered = false
		hill.position = Vector2(x, 280)
		hill.scale = Vector2(2.5, 2.2)
		hill.modulate = Color(0.85, 0.92, 0.88, 0.95)
		hill.z_index = -15
		add_child(hill)
		x += far_w * 0.85

	# 中景再铺一层略深、略低，做出景深
	x = -40.0
	while x < 5200.0:
		var mid := Sprite2D.new()
		mid.texture = BG_FAR
		mid.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		mid.centered = false
		mid.position = Vector2(x, 360)
		mid.scale = Vector2(2.0, 1.8)
		mid.modulate = Color(0.55, 0.72, 0.58, 0.75)
		mid.z_index = -12
		add_child(mid)
		x += far_w * 0.7

	for pos in [
		Vector2(160, 100), Vector2(520, 70), Vector2(980, 120), Vector2(1400, 60),
		Vector2(1900, 95), Vector2(2500, 75), Vector2(3100, 110), Vector2(3700, 65),
		Vector2(4300, 90), Vector2(4900, 80),
	]:
		var cloud := Sprite2D.new()
		cloud.texture = CLOUD_TEX
		cloud.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		cloud.position = pos
		cloud.scale = Vector2(1.6, 1.4)
		cloud.modulate = Color(1, 1, 1, 0.9)
		cloud.z_index = -10
		add_child(cloud)

func _build() -> void:
	# Act1 教学
	_run(0, 28, 560)
	_decor_row(0, 28, 560, 0.35)
	_run(1000, 6, 560)
	_run(1280, 10, 560)
	_decor_row(1280, 10, 560, 0.4)
	_spikes(1480, 560)

	# Act2 加压
	_run(1680, 6, 430)
	_decor_row(1680, 6, 430, 0.5)
	_run(2000, 12, 560)
	_decor_row(2000, 12, 560, 0.3)
	_moving(Vector2(2480, 470))
	_run(2740, 8, 400)
	_checkpoint(Vector2(2860, 368))
	_run(3120, 14, 560)
	_decor_row(3120, 14, 560, 0.25)
	_slime(Vector2(3360, 520), 3160, 3500)
	_spikes(3520, 560)
	_spikes(3580, 560)

	# Act3 收尾
	_run(3760, 4, 480)
	_run(4000, 4, 400)
	_run(4240, 4, 320)
	_run(4480, 12, 560)
	_decor_row(4480, 12, 560, 0.45)
	_goal(Vector2(4760, 500))
	_pit(Vector2(2600, 980), Vector2(5400, 80))

	for pos in [
		Vector2(220, 490), Vector2(420, 490), Vector2(680, 490),
		Vector2(1100, 490), Vector2(1400, 490),
		Vector2(1760, 360), Vector2(1880, 360), Vector2(2200, 490),
		Vector2(2480, 390), Vector2(2860, 320), Vector2(3280, 490),
		Vector2(3840, 410), Vector2(4080, 330), Vector2(4320, 250),
		Vector2(4600, 490), Vector2(4700, 490),
	]:
		_coin(pos)
	_spawn(Vector2(80, 512))

func _spawn(at: Vector2) -> void:
	var player := preload("res://scenes/player.tscn").instantiate()
	player.position = at
	add_child(player)

## 平台：左右边角草皮 + 双层泥土，避免「一条绿色胶带」
func _run(x: int, tiles: int, top: int) -> void:
	for i in tiles:
		var tex: Texture2D = GRASS_M
		if i == 0:
			tex = GRASS_L
		elif i == tiles - 1:
			tex = GRASS_R
		_sprite(tex, Vector2(x + 16 + i * 32, top), 1.0, 0)
		_sprite(DIRT, Vector2(x + 16 + i * 32, top + 32), 1.0, 0)
		_sprite(DIRT, Vector2(x + 16 + i * 32, top + 64), 1.0, 0)
	var size := Vector2(tiles * 32, 96)
	_solid(Vector2(x + size.x * 0.5, top + 32), size)

## 平台上稀疏摆树/灌木/蘑菇（不挡关键路径）
func _decor_row(x: int, tiles: int, top: int, density: float) -> void:
	var step := 3 if density < 0.35 else 2
	var i := 1
	while i < tiles - 1:
		if randf() > density:
			i += step
			continue
		var kind := i % 4
		var tex: Texture2D = BUSH_TEX
		var sc := 2.0
		if kind == 0:
			tex = TREE_TEX
			sc = 2.4
		elif kind == 1:
			tex = PINE_TEX
			sc = 2.4
		elif kind == 2:
			tex = MUSH_TEX
			sc = 1.8
		var spr := _sprite(tex, Vector2(x + 16 + i * 32, top - 20), sc, -1)
		spr.z_index = -1
		i += step

func _sprite(tex: Texture2D, at: Vector2, scale: float, z: int) -> Sprite2D:
	var s := Sprite2D.new()
	s.texture = tex
	s.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	s.position = at
	s.scale = Vector2(scale, scale)
	s.z_index = z
	add_child(s)
	return s

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
	vis.scale = Vector2(1.5, 1.5)
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
	vis.scale = Vector2(2.5, 2.5)
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
	vis.scale = Vector2(2.5, 2.5)
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
	vis.texture = GRASS_M
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
