extends CanvasLayer
class_name QTE

var arrow_speed = 100  # Speed at which the arrow moves

func _ready():
	connect("QTE_starts", Callable(self, "_on_QTE_starts"))
	emit_signal("QTE_starts")

func _on_QTE_starts():
	set_process(true)

func _process(delta):
	var arrow = $Arrow
	var fail = $Fail
	arrow.position.x -= arrow_speed * delta
	arrow.print_tree_pretty()
	if arrow.get_node("StaticBody2D").get_overlapping_bodies().has(fail):
		print("fail")
		set_process(false)
		# Handle collision with "Fail" node
