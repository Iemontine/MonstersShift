extends Interactable
class_name Factory

@export var item_name: String
@export var item_texture: Texture2D
@export var item_region_rect: Rect2

func _ready() -> void:
	produce_item()
	super()

func _on_interacted() -> void:
	# TODO: ensure only 1 item is available at any given time, currently multiple can be produced if the player is holding something
	produce_item()

func produce_item() -> void:
	print("produce")
	var item_pickup = create_item_pickup()
	add_child(item_pickup)
	# play_audio("res://assets/factory_produce.mp3")

func play_audio(audio_path: String) -> void:
	var audio_stream = AudioStreamPlayer.new()
	audio_stream.stream = load(audio_path)
	add_child(audio_stream)
	audio_stream.play()

func create_item_pickup() -> Node:
	var item_pickup = load("res://interactable/item_pickup.tscn").instantiate()
	item_pickup.item_name = item_name
	var sprite = item_pickup.get_node("Sprite2D")
	sprite.texture = item_texture
	sprite.region_enabled = true
	sprite.region_rect = item_region_rect
	return item_pickup
