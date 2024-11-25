extends Interactable
class_name CuttingBoard

var items: Array = []
var item_height: float = 10.0
var craft_output: String = ""
var is_locked: bool = false

var recipes = {
	["Chocolate", "Flour", "Sugar"]: "Brownie",
	["Sugar", "Vanilla"]: "Cookie",
	["Chocolate", "Flour", "Sugar", "Vanilla"]: "Cake"
}

func _on_interacted() -> void:
	if is_locked and player.state == player.PlayerState.CARRYING_ITEM: return
	handle_item_interaction()
	super()

func _on_hold_interacted() -> void:
	if is_locked or items.size() == 0: return

	var ingredient_names = []
	for item in items:
		ingredient_names.append(item["name"])
	ingredient_names.sort()

	reset_item_positions()
	empty_self()
	craft_item(ingredient_names)
	is_locked = true
	super()

func _physics_process(_delta: float) -> void:
	if current_hold_time > 0:
		move_items_to_target(Vector2.ZERO, 0.05 * current_hold_time / required_hold_time)
	else:
		arrange_items_on_board()

	# hacky: Fixes edge case where the player is able to put down the item they are picking up, causing a soft-lock
	if player.carried_item_name == "":
		player.carried_item.texture = null
		player.carried_item_name = ""
		player.carried_item.texture = null
		player.carried_item.visible = false
		if player.is_holding:
			player.state = Player.PlayerState.FROZEN
		else:
			player.state = Player.PlayerState.NORMAL

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

func handle_item_interaction() -> void:
	if player.carried_item_name != "":
		var allowed_items = ["Chocolate", "Flour", "Sugar", "Vanilla"]
		if allowed_items.find(player.carried_item_name) != -1:
			add_item_to_board(player.carried_item)
	elif items.size() > 0 and player.state != player.PlayerState.CARRYING_ITEM and not is_locked:
		var last_item = items[items.size() - 1]
		last_item["item"]._on_interacted()	# causes the player to pickup the last item on the board
		craft_output = ""
		is_locked = false
		items.pop_back()
	print_items_on_board()

func add_item_to_board(carried_item: Sprite2D) -> void:
	var item_pickup = ItemPickup.new()
	item_pickup.item_name = player.carried_item_name
	add_child(item_pickup)
	var sprite = Sprite2D.new()
	sprite.texture = carried_item.texture
	sprite.region_enabled = true
	sprite.region_rect = carried_item.region_rect
	item_pickup.add_child(sprite)
	item_pickup.icon = sprite
	items.append({"name": player.carried_item_name, "item": item_pickup})

	player.carried_item_name = ""
	player.carried_item.visible = false
	player.state = player.PlayerState.NORMAL
	play_audio("res://assets/bread.mp3")

func craft_item(ingredient_names: Array) -> void:
	print("Crafting with: ", ingredient_names)
	var recipe = recipes.get(ingredient_names, "Garbage")
	craft_output = recipe
	create_item_pickup(recipe)
	play_audio("res://assets/cake.mp3")
	$templabel.text = "Created a " + recipe

func create_item_pickup(recipe: String):
	var item_pickup = load("res://interactable/item_pickup.tscn").instantiate()
	add_child(item_pickup)
	item_pickup.item_name = recipe
	var sprite = item_pickup.icon
	sprite.texture = load("res://assets/tileset/interiors/1_Interiors/Theme_Sorter_Black_Shadow/12_Kitchen_Black_Shadow_16x16.png")
	match recipe:
		"Brownie":
			sprite.region_rect = Rect2(80, 752, 16, 16)
		"Cookie":
			sprite.region_rect = Rect2(112, 736, 16, 16)
		"Cake":
			sprite.region_rect = Rect2(176, 752, 16, 16)	
		_:
			sprite.texture = load("res://assets/tileset/exteriors/ME_Theme_Sorter_16x16/3_City_Props_16x16.png")
			sprite.region_rect = Rect2(32, 912, 16, 16)
	sprite.region_enabled = true
	return item_pickup
	

func print_items_on_board() -> void:
	var item_names = []
	for item in items:
		item_names.append(item["name"])
	print("Items on cutting board: ", item_names)
	$templabel.text = str(item_names)

func reset_item_positions() -> void:
	for item in items:
		item.position = Vector2.ZERO

func play_audio(audio_path: String) -> void:
	var audio_stream = AudioStreamPlayer.new()
	audio_stream.stream = load(audio_path)
	add_child(audio_stream)
	audio_stream.play()

func empty_self() -> void:
	for child in get_children():
		if child is StaticBody2D:
			child.queue_free()
	items.clear()
	craft_output = ""

func unlock() -> void:
	is_locked = false
