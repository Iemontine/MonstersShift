extends CanvasLayer
class_name QTE

signal QTE_starts

@export var speed_curve : Curve
var time_passed = 0.0
var qte_time_passed = 0.0
var tween
var qte_timer: Timer
var minigame_timer: Timer
var minigame_active = false
var qte_active = false
var lives = 2

@onready var arrow : StaticBody2D = $Control/Arrow
@onready var arrow_collision : CollisionShape2D = arrow.get_node("CollisionShape2D")
var direction = Vector2.LEFT

var min_x = 0.0
var max_x = 0.0
var true_min_x = INF
var true_max_x = -INF

func _ready():
	_calculate_min_max()
	$CanvasModulate.color.a = 0
	connect("QTE_starts", Callable(self, "_on_QTE_starts"))
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
	if qte_active:
		handle_movement()

func handle_movement():
	# Turn the current position to a value between 0 and 1 based on its position extremas
	var normalized_position = (arrow.position.x - min_x) / (max_x - min_x)	

	# Get the speed based on the curve
	var speed = speed_curve.sample_baked(normalized_position)

	if direction == Vector2.LEFT:
		arrow.position.x -= speed
	elif direction == Vector2.RIGHT:
		arrow.position.x += speed

	# Track the true min and max positions of the arrow
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
		if collider is StaticBody2D:
			if collider.name.begins_with("Bounce"):
				direction = -direction

	if Input.is_action_just_pressed("ui_accept"):
		for collision in result:
			var collider = collision.collider
			if collider.name.begins_with("Good"):
				print("Good")
				_fade_out()
				qte_active = false
				break
			elif collider.name.begins_with("Bad"):
				print("Bad")
				_fade_out()
				qte_active = false
				break
			elif collider.name.begins_with("Perfect"):
				print("Perfect")
				_fade_out()
				qte_active = false
				break

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
	lives = 2
	minigame_active = true
	time_passed = 0.0
	minigame_timer.start()

func _on_minigame_timer_timeout():
	if minigame_active:
		time_passed += 1
		print("Minigame time: ", time_passed, " seconds")
		if time_passed == 5 or time_passed == 13 or time_passed == 20:
			print("QTE event triggered at ", time_passed, " seconds")
			reset()
			emit_signal("QTE_starts")
			qte_timer.start()
		if time_passed > 40:
			minigame_active = false
			print("Minigame ended")
		minigame_timer.start()

func _on_qte_timer_timeout():
	if qte_active:
		qte_time_passed += 1
		if qte_time_passed >= 3:
			print("QTE failed, losing a life")
			lives -= 1
			if lives <= 0:
				print("Game Over")
				minigame_active = false
			_fade_out()
			qte_active = false
		else:
			print("Seconds until QTE timeout: ", 3 - qte_time_passed)
		qte_timer.start()
