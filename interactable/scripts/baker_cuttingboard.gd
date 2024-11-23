extends Interactable
class_name CuttingBoard

var items: Array = []
var item_height: float = 10.0
var craft_output: String = ""
var is_locked: bool = false

func _on_interacted() -> void:
	if is_locked: return
	handle_item_interaction()
	super()

func _on_hold_interacted() -> void:
	if is_locked or items.size() == 0: return
	reset_item_positions()
	empty_self()
	create_item_pickup()
	play_audio("res://assets/cake.mp3")
	craft_output = "cake"
	is_locked = true
	super()

func _physics_process(_delta: float) -> void:
	if current_hold_time > 0:
		move_items_to_target(Vector2.ZERO, 0.05 * current_hold_time / required_hold_time)
	else:
		arrange_items_on_board()

func handle_item_interaction() -> void:
	var carried_item_name = player.carried_item_name
	var carried_item = player.carried_item

	if carried_item_name != "":
		add_item_to_board(carried_item)
		player.carried_item_name = ""
		player.state = player.PlayerState.NORMAL
		play_audio("res://assets/bread.mp3")

func add_item_to_board(carried_item) -> void:
	var crafting_item = StaticBody2D.new()
	var sprite = Sprite2D.new()
	sprite.texture = carried_item.texture
	sprite.region_enabled = true
	sprite.region_rect = carried_item.region_rect
	crafting_item.add_child(sprite)
	add_child(crafting_item)
	items.append({"name": player.carried_item_name, "item": crafting_item})
	print_items_on_board()

func print_items_on_board() -> void:
	var item_names = []
	for item in items:
		item_names.append(item["name"])
	print("Items on cutting board: ", item_names)
	$templabel.text = str(item_names)

func reset_item_positions() -> void:
	for item in items:
		item.position = Vector2.ZERO

func create_item_pickup() -> void:
	var item_pickup = load("res://interactable/item_pickup.tscn").instantiate()
	item_pickup.item_name = "cake"
	var sprite = item_pickup.get_node("ItemSprite")
	sprite.texture = load("res://assets/tileset/interiors/1_Interiors/Theme_Sorter_Black_Shadow/12_Kitchen_Black_Shadow_16x16.png")
	sprite.region_enabled = true
	sprite.region_rect = Rect2(144, 736, 16, 16)
	add_child(item_pickup)

func play_audio(audio_path: String) -> void:
	var audio_stream = AudioStreamPlayer.new()
	audio_stream.stream = load(audio_path)
	add_child(audio_stream)
	audio_stream.play()

func move_items_to_target(target_position: Vector2, lerp_factor: float) -> void:
	for item in items:
		item["item"].position = item["item"].position.lerp(target_position, lerp_factor)

func arrange_items_on_board() -> void:
	var total_width = items.size() * 16
	var start_x = -total_width / 2.0
	for i in range(items.size()):
		var item = items[i]["item"]
		var target_position = Vector2(start_x + i * 16 + 8, -item_height)
		item.position = item.position.lerp(target_position, 0.1)

func empty_self() -> void:
	for child in get_children():
		if child is StaticBody2D:
			child.queue_free()
	items.clear()
	craft_output = ""

func unlock() -> void:
	is_locked = false
