extends GroceryItem
class_name GroceryItemNight


#TODO: add triggers for visibility and enabled

func show_grocery_ui():
	super()
	for child in grocery_ui.get_children():
		child.position.y += 100
	grocery_ui.get_node("Hint").visible = false
	grocery_ui.get_node("Paper").visible = false
	var canvas = get_tree().current_scene.get_node_or_null("CanvasModulate")
	canvas.color = Color(0.121, 0.173, 0.367) * 0.7

func enable_grocery_item():
	enabled = true
	visible = true

func _on_yes_pressed() -> void:
	super()
	enabled = false
	visible = false
	get_tree().current_scene.get_node_or_null("CanvasModulate").color = Color(0.121, 0.173, 0.367)
	StoryManager.transition_to_event(StoryManager.Event.GRABBED_NIGHT_ITEM)
