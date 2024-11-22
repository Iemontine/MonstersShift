class_name ItemPickup
extends Interactable

@export var item_name:String
@export var item_texture:Texture
var item: Item
@onready var icon = $ItemIcon

func _ready() -> void:
	pass
	item = Item.new()
	item.sprite = item_texture
	icon.texture = item_texture
	super()
	
func _on_interacted() -> void:
	print("interacted")
	player.state = Player.PlayerState.HOLDING_ITEM
	player.item = item
	player.state = Player.PlayerState.FROZEN
	player.travel_to_anim("PickupCarry")
	start_timer(0.5)

func start_timer(duration: float):
	var timer = Timer.new()
	timer.wait_time = duration
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "on_timer_completed"))
	get_tree().root.add_child(timer)
	timer.start()

func on_timer_completed():
	player.state = Player.PlayerState.HOLDING_ITEM
