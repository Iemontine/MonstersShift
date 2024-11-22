extends Interactable
class_name CuttingBoard


var held_boards: Array = []
var h: float = 20.0

func _on_interacted() -> void:
	var cutting_board = StaticBody2D.new()
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/tileset/interiors/1_Interiors/Theme_Sorter_Black_Shadow/12_Kitchen_Black_Shadow_16x16.png")
	sprite.region_enabled = true
	sprite.region_rect = Rect2(208, 576, 16, 16)
	cutting_board.add_child(sprite)
	add_child(cutting_board)
	held_boards.append(cutting_board)
	super()

func _physics_process(_delta: float) -> void:
	var total_width = held_boards.size() * 16
	var start_x = -total_width / 2.0
	for i in range(held_boards.size()):
		var board = held_boards[i]
		board.position.x = start_x + i * 16 + 8
		board.position.y = -h