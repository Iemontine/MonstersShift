extends Interactable
class_name CuttingBoard

var held_boards: Array = []
var h: float = 10.0
var finished_crafting = false

func _on_interacted() -> void:
	if finished_crafting:
		# placeholder
		print("Cake picked up!")
		for child in get_children():
			if child is StaticBody2D:
				child.queue_free()
		finished_crafting = false
		return

	var cutting_board = StaticBody2D.new()
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/tileset/interiors/1_Interiors/Theme_Sorter_Black_Shadow/12_Kitchen_Black_Shadow_16x16.png")
	sprite.region_enabled = true
	sprite.region_rect = Rect2(208, 576, 16, 16)
	cutting_board.add_child(sprite)
	add_child(cutting_board)
	held_boards.append(cutting_board)

	var audio_stream = AudioStreamPlayer.new()
	audio_stream.stream = load("res://assets/bread.mp3")
	add_child(audio_stream)
	audio_stream.play()

	super()

func _on_hold_interacted() -> void:
	if held_boards.size() == 0: return
		
	for board in held_boards:
		board.position = Vector2.ZERO
	
	for child in get_children():
		if child is StaticBody2D:
			child.queue_free()
	
	held_boards.clear()

	var new_object = StaticBody2D.new()
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/tileset/interiors/1_Interiors/Theme_Sorter_Black_Shadow/12_Kitchen_Black_Shadow_16x16.png")
	sprite.region_enabled = true
	sprite.region_rect = Rect2(144, 736, 16, 16)
	new_object.add_child(sprite)
	add_child(new_object)
	
	var audio_stream = AudioStreamPlayer.new()
	audio_stream.stream = load("res://assets/cake.mp3")
	add_child(audio_stream)
	audio_stream.play()

	finished_crafting = true

	super()

func _physics_process(_delta: float) -> void:
	if current_hold_time > 0:
		for board in held_boards:
			var target_position = Vector2.ZERO
			board.position = board.position.lerp(target_position, 0.05 * current_hold_time / required_hold_time)
	else:
		var total_width = held_boards.size() * 16
		var start_x = -total_width / 2.0
		for i in range(held_boards.size()):
			var board = held_boards[i]
			var target_position = Vector2(start_x + i * 16 + 8, -h)
			board.position = board.position.lerp(target_position, 0.1)
