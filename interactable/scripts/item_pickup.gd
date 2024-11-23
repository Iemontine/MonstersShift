class_name ItemPickup
extends Interactable

@export var item_name: String
@onready var icon = $ItemSprite

func _on_interacted() -> void:
	if player.state == Player.PlayerState.CARRYING_ITEM: return
	set_texture()
	player.carried_item_name = item_name
	player.state = Player.PlayerState.FROZEN
	player.travel_to_anim("PickupCarry")
	start_timer()

func set_texture() -> void:
	player.carried_item.texture = $ItemSprite.texture
	player.carried_item.region_enabled = true
	player.carried_item.region_rect = $ItemSprite.region_rect

func start_timer() -> void:
	var timer = Timer.new()
	timer.wait_time = 0.39
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_animation_complete"))
	add_child(timer)
	timer.start()

func _on_animation_complete() -> void:
	player.state = Player.PlayerState.CARRYING_ITEM
	unlock_cutting_board()
	queue_free()

func unlock_cutting_board() -> void:
	var cutting_board = get_parent().get_node_or_null("CuttingBoard")
	if cutting_board:
		cutting_board.unlock()
