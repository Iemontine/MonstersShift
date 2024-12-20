extends CanvasLayer
class_name QTE_Day

signal QTE_starts

@export var speed_curve : Curve
var time_passed = 0.0
var qte_time_passed = 0.0
var tween
var qte_timer: Timer
var minigame_timer: Timer
var minigame_active = false
var qte_active = false
var lives = 3
var time_per_qte = 5

@onready var arrow : StaticBody2D = $Control/Arrow
@onready var arrow_collision : CollisionShape2D = arrow.get_node("CollisionShape2D")
@export var player:Player
var direction = Vector2.LEFT

var min_x = 0.0
var max_x = 0.0
var true_min_x = INF
var true_max_x = -INF

var normal_speed = 50
var perfect_speed = 100
var normal_anim = "WalkCarry"
var perfect_anim = "RunCarry"

func _ready():
	_calculate_min_max()
	$CanvasModulate.color.a = 0
	connect("QTE_starts", Callable(self, "_on_QTE_starts"))
	_initialize_timers()
	if player:
		player.connect("path_follow_completed", Callable(self, "_on_path_follow_completed"))

func _initialize_timers():
	qte_timer = Timer.new()
	qte_timer.set_wait_time(1)
	qte_timer.set_one_shot(false)
	qte_timer.connect("timeout", Callable(self, "_on_qte_timer_timeout"))
	add_child(qte_timer)

	minigame_timer = Timer.new()
	minigame_timer.set_wait_time(1)
	minigame_timer.set_one_shot(false)
	minigame_timer.connect("timeout", Callable(self, "_on_minigame_timer_timeout"))
	add_child(minigame_timer)

func _physics_process(_delta: float) -> void:
	if not qte_active: return

	handle_collisions()
	if minigame_active:
		handle_movement()
		if qte_active:
			player.travel_to_anim("JumpCarry", player.direction)

func handle_movement():
	var normalized_position = (arrow.position.x - min_x) / (max_x - min_x)
	var speed = speed_curve.sample_baked(normalized_position)

	if direction == Vector2.LEFT:
		arrow.position.x -= speed
	elif direction == Vector2.RIGHT:
		arrow.position.x += speed
	
	true_min_x = min(true_min_x, arrow.position.x)
	true_max_x = max(true_max_x, arrow.position.x)
	# print("True Min X: ", true_min_x, " True Max X: ", true_max_x, " Calculated Min X: ", min_x, " Calculated Max X: ", max_x)

func handle_collisions():
	var space_state = get_tree().root.get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = arrow_collision.shape
	query.transform = arrow_collision.global_transform
	query.collision_mask = arrow.collision_layer

	var result = space_state.intersect_shape(query)
	for collision in result:
		var collider = collision.collider
		if collider is StaticBody2D and collider.name.begins_with("Bounce"):
			direction = -direction

	if Input.is_action_just_pressed("ui_accept"):
		_process_collision_result(result)

func _process_collision_result(result):
	for collision in result:
		var collider = collision.collider
		if collider.name.begins_with("Perfect"):
			_handle_qte_result("Perfect", perfect_speed, perfect_anim)
			await get_tree().create_timer(1.5).timeout
			set_player_speed(normal_speed)
			set_player_movement_anim(normal_anim)
			minigame_timer.start()
			break
		elif collider.name.begins_with("Good"):
			_handle_qte_result("Good", normal_speed, normal_anim)
			break
		elif collider.name.begins_with("Bad"):
			_handle_qte_result("Bad", normal_speed, normal_anim, true)
			break

func _handle_qte_result(result_type: String, speed: float, anim: String, should_lose_life: bool = false):
	print(result_type)
	_fade_out()
	set_player_speed(speed)
	set_player_movement_anim(anim)
	qte_active = false
	if should_lose_life:
		lose_life()
	minigame_timer.start()

func _calculate_min_max():
	var bounce_left = $Control/BounceLeft
	var bounce_right = $Control/BounceRight
	var bounce_left_shape = bounce_left.get_node("CollisionShape2D").shape as RectangleShape2D
	var bounce_right_shape = bounce_right.get_node("CollisionShape2D").shape as RectangleShape2D
	
	min_x = bounce_left.position.x + bounce_left_shape.size.x
	max_x = bounce_right.position.x - bounce_right_shape.size.x

func _on_QTE_starts():
	qte_time_passed = 0.0
	qte_active = true
	minigame_timer.stop()
	# Choose a random starting position for the arrow when the QTE starts
	# to ensure repeated QTEs do not become predictable
	arrow.position.x = randf_range(min_x, max_x)  # Set arrow to a random position between min_x and max_x

func _fade_out():
	tween = get_tree().create_tween().set_parallel()
	tween.tween_property($CanvasModulate, "color:a", 0, 1).set_trans(Tween.EASE_OUT)

func reset():
	var tween_length = 0.7

	tween = get_tree().create_tween().set_parallel()
	tween.tween_property($CanvasModulate, "color:a", 1, tween_length).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "scale", Vector2(1, 1), tween_length).from(Vector2(0.01, 0.01)).set_trans(Tween.TRANS_ELASTIC)
	arrow.position = Vector2(211, 55)

	qte_active = false
	await get_tree().create_timer(tween_length).timeout

func start_minigame():
	lives = 3
	minigame_active = true
	time_passed = 0.0
	visible = true
	minigame_timer.start()
	if player:
		set_player_speed(normal_speed)
		set_player_movement_anim(normal_anim)
		player.path_following = true
		player.state = Player.PlayerState.CONTROLLED
		player.follow_path()
		# Hacky hold logic, TODO: turn into function, reuse where available
		var texture = load("res://assets/tileset/interiors/1_Interiors/Theme_Sorter_Black_Shadow/16_Grocery_store_Black_Shadow_16x16.png")
		var atlas_texture = AtlasTexture.new()
		atlas_texture.atlas = texture
		atlas_texture.region = Rect2(224, 232, 16, 16)
		player.carried_item.texture = atlas_texture
	
func stop_minigame():
	minigame_active = false
	visible = false
	minigame_timer.stop()
	qte_timer.stop()

func _on_minigame_timer_timeout():
	if minigame_active:
		time_passed += 1
		print("Minigame time: ", time_passed, " seconds , Number of lives: ", lives)
		if int(time_passed) % 3 == 0:
			print("QTE event triggered at ", time_passed, " seconds")
			reset()
			set_player_speed(0)
			emit_signal("QTE_starts")
			qte_timer.start()
		else:
			minigame_timer.start()

func lose_life():
	lives -= 1
	if lives <= 0:
		print("Game Over")
		minigame_active = false
		if player:
			fail_player()


func _on_qte_timer_timeout():
	if qte_active:
		qte_time_passed += 1
		if qte_time_passed >= time_per_qte:
			lose_life()
			_fade_out()
			minigame_timer.start()
			qte_active = false
		else:
			print("Seconds until QTE timeout: ", time_per_qte - qte_time_passed)
			qte_timer.start()

func fail_player():
	player.path_following = false
	# why no work
	player.state = Player.PlayerState.LOCKED
	player.travel_to_anim("DeathBounce")
	stop_minigame()
	StoryManager.transition_to_event(StoryManager.Event.WIDOW_DAY_QTE_FAIL)
	player.carried_item.texture = null
	PlayerController.start_cutscene("widow_day_qte_fail")
	# Must disable path following to prevent player from contnuing to move after losing

func set_player_speed(_speed: float):
	if player: player.speed = _speed
	
func set_player_movement_anim(_movement_anim: String):
	if player:
		player.get_node("Movement").movement_anim = _movement_anim

func _on_path_follow_completed():
	stop_minigame()
