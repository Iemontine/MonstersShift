extends TextureRect
@onready var label = $Label

var chatbox_on_cooldown:bool 

func _ready() -> void:
	visible = false
	chatbox_on_cooldown = false

func say(text:String,duration:float) -> void:
	if !chatbox_on_cooldown:
		visible = true
		label.text = text
		# print(label.text)
		start_timer(duration)

func start_timer(duration: float):
	var timer = Timer.new()
	timer.wait_time = duration
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "on_timer_completed"))
	get_tree().root.add_child(timer)
	timer.start()


func on_timer_completed():
	visible = false
	chatbox_on_cooldown = true
	start_cooldown_timer(5)

func start_cooldown_timer(duration: float):
	var timer = Timer.new()
	timer.wait_time = duration
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "on_cooldown_completed"))
	get_tree().root.add_child(timer)
	timer.start()


func on_cooldown_completed():
	chatbox_on_cooldown = false
