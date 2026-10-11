extends Node2D

## 岭行关卡：对标经典横版层次（青空/山/灌木/云）+ Pixel Adventure 前景；非任天堂素材

const GRASS_L := preload("res://assets/tile_grass_l.png")
const GRASS_M := preload("res://assets/tile_grass_m.png")
const GRASS_R := preload("res://assets/tile_grass_r.png")
const DIRT := preload("res://assets/tile_dirt.png")
const STONE := preload("res://assets/tile_stone.png")
const SPIKE_TEX := preload("res://assets/spike.png")
const COIN_TEX := preload("res://assets/coin_sheet.png")
const FLAG_TEX := preload("res://assets/flag.png")
const CHECK_TEX := preload("res://assets/checkpoint.png")
const CLOUD_TEX := preload("res://assets/cloud.png")
const SLIME_TEX := preload("res://assets/slime_sheet.png")
const BG_SKY := preload("res://assets/bg_sky_tile.png")
const BG_MOUNTAINS := preload("res://assets/bg_mountains.png")
const BG_BUSHES := preload("res://assets/bg_bushes.png")
const SUN_TEX := preload("res://assets/sun.png")
const PIPE_TEX := preload("res://assets/pipe.png")
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

## 远景分层（对标经典横版读图顺序）：青空 → 山 → 灌木剪影 → 云/太阳 → 玩法层
func _scenery() -> void:
	# 纯色青空（禁止格子贴图铺满）
	var x := -64.0
	while x < 5400.0:
		var sky := Sprite2D.new()
		sky.texture = BG_SKY
		sky.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		sky.centered = false
		sky.position = Vector2(x, 0)
		sky.scale = Vector2(20, 9) # 大块铺色，看不出格子
		sky.z_index = -30
		add_child(sky)
		x += 64 * 20

	var sun := Sprite2D.new()
	sun.texture = SUN_TEX
	sun.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sun.position = Vector2(1100, 90)
	sun.scale = Vector2(2.6, 2.6)
	sun.z_index = -28
	add_child(sun)

	for pos in [
		Vector2(180, 100), Vector2(520, 70), Vector2(900, 120), Vector2(1400, 60),
		Vector2(1900, 95), Vector2(2500, 75), Vector2(3100, 110), Vector2(3700, 65),
		Vector2(4300, 90), Vector2(4900, 80),
	]:
		var cloud := Sprite2D.new()
		cloud.texture = CLOUD_TEX
		cloud.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		cloud.position = pos
		cloud.scale = Vector2(2.2, 2.0)
		cloud.z_index = -26
		add_child(cloud)

	var mw := BG_MOUNTAINS.get_width() * 1.8
	x = -100.0
	while x < 5200.0:
		var m := Sprite2D.new()
		m.texture = BG_MOUNTAINS
		m.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		m.centered = false
		m.position = Vector2(x, 250)
		m.scale = Vector2(1.8, 1.7)
		m.z_index = -20
		add_child(m)
		x += mw * 0.92

	var bw := BG_BUSHES.get_width() * 1.6
	x = -60.0
	while x < 5200.0:
		var b := Sprite2D.new()
		b.texture = BG_BUSHES
		b.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		b.centered = false
		b.position = Vector2(x, 455)
		b.scale = Vector2(1.6, 1.5)
		b.z_index = -10
		add_child(b)
		x += bw * 0.88

func _build() -> void:
	# Act1 教学：长平地 + 管子地标 + 成排苹果（经典横版引导）
	_run(0, 28, 560)
	_pipe(Vector2(720, 464))
	_decor_row(0, 28, 560, 0.55)
	_run(1000, 6, 560)
	_run(1280, 10, 560)
	_decor_row(1280, 10, 560, 0.5)
	_spikes(1480, 560)

	# Act2：石砖踏脚 + 高台 + 检查点 + 敌人
	_run(1680, 6, 430)
	_stone_stack(1880, 494, 3, 2)
	_decor_row(1680, 6, 430, 0.55)
	_run(2000, 12, 560)
	_pipe(Vector2(2280, 464))
	_decor_row(2000, 12, 560, 0.4)
	_moving(Vector2(2480, 470))
	_run(2740, 8, 400)
	_checkpoint(Vector2(2860, 368))
	_run(3120, 14, 560)
	_decor_row(3120, 14, 560, 0.35)
	_slime(Vector2(3360, 520), 3160, 3500)
	_spikes(3520, 560)
	_spikes(3580, 560)

	# Act3
	_run(3760, 4, 480)
	_run(4000, 4, 400)
	_run(4240, 4, 320)
	_run(4480, 12, 560)
	_pipe(Vector2(4680, 464))
	_decor_row(4480, 12, 560, 0.5)
	_goal(Vector2(4860, 500))
	_pit(Vector2(2600, 980), Vector2(5400, 80))

	# 成排收集物（经典横版密度）
	for i in 8:
		_coin(Vector2(160 + i * 36, 470))
	for i in 6:
		_coin(Vector2(1320 + i * 36, 470))
	for i in 5:
		_coin(Vector2(1760 + i * 36, 350))
	for pos in [
		Vector2(2200, 490), Vector2(2480, 390), Vector2(2860, 320),
		Vector2(3280, 490), Vector2(3840, 410), Vector2(4080, 330),
		Vector2(4320, 250), Vector2(4600, 490), Vector2(4780, 490),
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

## 平台上前景点缀：箱子/苹果状装饰（远景灌木已在 _scenery）
func _decor_row(x: int, tiles: int, top: int, density: float) -> void:
	var step := 3 if density < 0.35 else 2
	var i := 2
	while i < tiles - 2:
		if randf() > density:
			i += step
			continue
		var tex: Texture2D = BUSH_TEX if (i % 2 == 0) else MUSH_TEX
		var spr := _sprite(tex, Vector2(x + 16 + i * 32, top - 18), 1.8, -1)
		spr.z_index = -1
		i += step

## 绿管地标（原创像素，碰撞为实心）
func _pipe(at: Vector2) -> void:
	var spr := _sprite(PIPE_TEX, at, 1.0, 1)
	spr.centered = true
	_solid(at + Vector2(0, 20), Vector2(40, 90))

## 灰石砖块堆（经典横版中段变化）
func _stone_stack(x: int, top: int, w: int, h: int) -> void:
	for row in h:
		for col in w:
			_sprite(STONE, Vector2(x + 16 + col * 32, top - row * 32), 1.0, 0)
	_solid(Vector2(x + w * 16, top - (h - 1) * 16), Vector2(w * 32, h * 32))

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
