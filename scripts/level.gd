extends Node2D

const GROUND := Color("2f6b4f")
const STONE := Color("3d4c59")
const COIN := Color("f2c14e")
const FLAG := Color("e24b4b")

func _ready() -> void:
	_build()

func _build() -> void:
	_platform(Vector2(420, 560), Vector2(780, 48), GROUND)
	_platform(Vector2(1180, 500), Vector2(280, 40), STONE)
	_platform(Vector2(1560, 420), Vector2(220, 36), STONE)
	_moving_platform(Vector2(1960, 470))
	_platform(Vector2(2420, 400), Vector2(260, 36), STONE)
	_platform(Vector2(2860, 500), Vector2(420, 48), GROUND)
	_platform(Vector2(3400, 560), Vector2(520, 48), GROUND)

	for coin_pos in [
		Vector2(520, 470), Vector2(760, 430), Vector2(1180, 430),
		Vector2(1560, 350), Vector2(1960, 390), Vector2(2300, 330),
		Vector2(2580, 330), Vector2(3100, 430),
	]:
		_coin(coin_pos)

	_goal(Vector2(3520, 500))
	_pit(Vector2(2000, 980), Vector2(4200, 80))
	_spawn_player(Vector2(120, 500))

func _spawn_player(at: Vector2) -> void:
	var player := preload("res://scenes/player.tscn").instantiate()
	player.position = at
	add_child(player)

func _platform(center: Vector2, size: Vector2, color: Color) -> void:
	var body := StaticBody2D.new()
	body.position = center
	body.add_child(_box_visual(size, color))
	body.add_child(_box_shape(size))
	add_child(body)

func _moving_platform(center: Vector2) -> void:
	var body := AnimatableBody2D.new()
	body.position = center
	body.set_script(preload("res://scripts/moving_platform.gd"))
	var size := Vector2(160, 28)
	body.add_child(_box_visual(size, Color("d08a3a")))
	body.add_child(_box_shape(size))
	add_child(body)

func _coin(at: Vector2) -> void:
	var area := Area2D.new()
	area.position = at
	area.collision_layer = 4
	area.collision_mask = 2
	area.set_script(preload("res://scripts/coin.gd"))
	var vis := Polygon2D.new()
	vis.color = COIN
	vis.polygon = PackedVector2Array([
		Vector2(0, -12), Vector2(10, 0), Vector2(0, 12), Vector2(-10, 0)
	])
	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 12.0
	shape.shape = circle
	area.add_child(vis)
	area.add_child(shape)
	add_child(area)

func _goal(at: Vector2) -> void:
	var area := Area2D.new()
	area.position = at
	area.collision_layer = 4
	area.collision_mask = 2
	area.set_script(preload("res://scripts/goal.gd"))
	var pole := Polygon2D.new()
	pole.color = Color("f4f1ea")
	pole.polygon = PackedVector2Array([Vector2(-3, -70), Vector2(3, -70), Vector2(3, 20), Vector2(-3, 20)])
	var flag := Polygon2D.new()
	flag.color = FLAG
	flag.polygon = PackedVector2Array([Vector2(3, -70), Vector2(36, -56), Vector2(3, -42)])
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(40, 90)
	shape.position = Vector2(8, -25)
	shape.shape = rect
	area.add_child(pole)
	area.add_child(flag)
	area.add_child(shape)
	add_child(area)

func _pit(center: Vector2, size: Vector2) -> void:
	var area := Area2D.new()
	area.position = center
	area.collision_layer = 4
	area.collision_mask = 2
	area.set_script(preload("res://scripts/pit.gd"))
	area.add_child(_box_shape(size))
	add_child(area)

func _box_visual(size: Vector2, color: Color) -> Polygon2D:
	var vis := Polygon2D.new()
	vis.color = color
	var half := size * 0.5
	vis.polygon = PackedVector2Array([
		Vector2(-half.x, -half.y), Vector2(half.x, -half.y),
		Vector2(half.x, half.y), Vector2(-half.x, half.y),
	])
	return vis

func _box_shape(size: Vector2) -> CollisionShape2D:
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = size
	shape.shape = rect
	return shape
