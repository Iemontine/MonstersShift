extends Path2D

@onready var car = $PathFollow2D/AnimatedSprite2D
@onready var path = $PathFollow2D
var speed = 100

func _ready() -> void:
	_pick_random_car()

func _process(delta: float) -> void:
	# Move the car along the pathA
	path.progress += speed * delta
	
	if path.progress_ratio >= 0.9:
		path.progress_ratio = 0 
		_pick_random_car()

func _pick_random_car() -> void:
	
	var random_car = "car" + str(randi_range(1, 6))
	print(random_car)
	car.play(random_car)
	
	speed = randi_range(150, 200)
	
