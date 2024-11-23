extends Interactable
class_name CuttingBoard

var items: Array = []
var h: float = 10.0
var craft_output: String = ""

func _on_interacted() -> void:

	var carried_item_name = player.carried_item_name
	var carried_item = player.carried_item

	if craft_output != "":
		# placeholder
		print("Cake picked up!")
		for child in get_children():
			if child is StaticBody2D:
				child.queue_free()
		craft_output = ""
		return
	elif carried_item_name != "":
		var crafting_item = StaticBody2D.new()
		var sprite = Sprite2D.new()
		sprite.texture = carried_item.texture
		sprite.region_enabled = true
		sprite.region_rect = carried_item.region_rect
		crafting_item.add_child(sprite)
		add_child(crafting_item)
		items.append({"name": player.carried_item_name, "item": crafting_item})
		var item_names = []
		for item in items:
			item_names.append(item["name"])
		print("Items on cutting board: ", item_names)

		player.carried_item_name = ""
		player.state = player.PlayerState.NORMAL

		var audio_stream = AudioStreamPlayer.new()
		audio_stream.stream = load("res://assets/bread.mp3")
		add_child(audio_stream)
		audio_stream.play()

	super()

func _on_hold_interacted() -> void:
	if items.size() == 0: return
		
	for item in items:
		item.position = Vector2.ZERO
	
	for child in get_children():
		if child is StaticBody2D:
			child.queue_free()
	
	items.clear()

	var item_pickup = load("res://interactable/item_pickup.tscn").instantiate()
	item_pickup.item_name = "cake"
	var sprite = item_pickup.get_node("ItemSprite")
	sprite.texture = load("res://assets/tileset/interiors/1_Interiors/Theme_Sorter_Black_Shadow/12_Kitchen_Black_Shadow_16x16.png")
	sprite.region_enabled = true
	sprite.region_rect = Rect2(144, 736, 16, 16)
	add_child(item_pickup)
	
	var audio_stream = AudioStreamPlayer.new()
	audio_stream.stream = load("res://assets/cake.mp3")
	add_child(audio_stream)
	audio_stream.play()
	

	# TODO: determine output, placeholder is cake
	craft_output = "cake"
	
	super()

func _physics_process(_delta: float) -> void:
	if current_hold_time > 0:
		for item in items:
			var target_position = Vector2.ZERO
			item["item"].position = item["item"].position.lerp(target_position, 0.05 * current_hold_time / required_hold_time)
	else:
		var total_width = items.size() * 16
		var start_x = -total_width / 2.0
		for i in range(items.size()):
			var item = items[i]["item"]
			var target_position = Vector2(start_x + i * 16 + 8, -h)
			item.position = item.position.lerp(target_position, 0.1)
