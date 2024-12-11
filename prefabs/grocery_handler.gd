extends Node2D

var correct_selections = 0
var total_selections = 0
@onready var grocery_item1 = $GroceryItem1
@onready var grocery_item2 = $GroceryItem2
@onready var grocery_item3 = $GroceryItem3
@export var player: Player

func _ready():
	# Connect signals from all grocery items
	grocery_item1.connect("item_selected", Callable(self, "_on_item_selected"))
	grocery_item2.connect("item_selected", Callable(self, "_on_item_selected"))
	grocery_item3.connect("item_selected", Callable(self, "_on_item_selected"))
	
	# Initially enable only the first item
	grocery_item1.enabled = false
	grocery_item1.visible = false
	grocery_item2.enabled = false
	grocery_item2.visible = false
	grocery_item3.enabled = false
	grocery_item3.visible = false
	
func enable_grocery_items():
	grocery_item1.enabled = true
	grocery_item1.visible = true

func _on_item_selected(is_correct: bool):
	total_selections += 1
	if is_correct:
		correct_selections += 1
	
	match total_selections:
		1:
			grocery_item1.enabled = false
			grocery_item1.visible = false
			grocery_item2.enabled = true
			grocery_item2.visible = true
		2:
			grocery_item2.enabled = false
			grocery_item2.visible = false
			grocery_item3.enabled = true
			grocery_item3.visible = true
		3:
			grocery_item3.enabled = false
			grocery_item3.visible = false
			_check_final_result()

func _check_final_result():
	if correct_selections == 2: 	# don't care about the third item
		print("success")
		StoryManager.transition_to_event(StoryManager.Event.WIDOW_DAY_GAME_CORRECT)
	else:
		# TODO: failure?
		StoryManager.transition_to_event(StoryManager.Event.WIDOW_DAY_GAME_CORRECT)
		print("fail")
	SceneManager.switch_scene(player, "Town", false, "Door_Conbini1")
