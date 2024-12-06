extends CanvasLayer
class_name QTE

signal QTE_starts

@export var speed_curve : Curve
var time_passed = 0.0
var is_active = false
var tween

@onready var arrow : StaticBody2D = $Control/Arrow
@onready var arrow_collision : CollisionShape2D = arrow.get_node("CollisionShape2D")
var direction = Vector2.LEFT

func _process(delta):
	var canvas = $CanvasModulate
	print(canvas.color)
	
	if Input.is_action_just_pressed("ui_cancel"):
		reset()
	if not is_active: return

	time_passed += delta * 0.4
	
	#print("Time passed: ", time_passed)
	
	# Calculate the offset based on the curve value
	var curve_value = speed_curve.sample_baked(time_passed)

	if direction == Vector2.LEFT:
		arrow.position.x -= curve_value
	elif direction == Vector2.RIGHT:
		arrow.position.x += curve_value

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
				is_active = false
				break
			elif collider.name.begins_with("Bad"):
				print("Bad")
				_fade_out()
				is_active = false
				break
			elif collider.name.begins_with("Perfect"):
				print("Perfect")
				_fade_out()
				is_active = false
				break

func _ready():
	reset()
	connect("QTE_starts", Callable(self, "_on_QTE_starts"))
	emit_signal("QTE_starts")

func _on_QTE_starts():
	time_passed = 0.0
	is_active = true

func _fade_out():
	if tween and tween.is_valid():
		tween.tween_property($CanvasModulate, "color:a", 0, 1).set_trans(Tween.EASE_OUT)

func reset():
	tween = get_tree().create_tween().set_parallel()
	tween.tween_property($CanvasModulate, "color:a", 1, 1).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, "scale", Vector2(1, 1), 1).from(Vector2(0.1, 0.1)).set_trans(Tween.TRANS_BOUNCE)
	time_passed = 0.0
	arrow.position = Vector2(211, 55)
	is_active = false
	emit_signal("QTE_starts")
