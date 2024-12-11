extends Interactable
class_name GroceryItem

signal item_selected(is_correct: bool)

@export var enabled: bool = false
@export var sprite_1: Texture
@export var sprite_2: Texture
@export var sprite_3: Texture
@export var exclamation_sprite: Sprite2D
@export var hint_texture: Texture
@export var correct_index: int = 0

var is_paper_down: bool = false
var current_button_index: int = -1

#func _ready():
	#exclamation_sprite.visible = false
	#if StoryManager.current_event != StoryManager.Event.WIDOW_BEFORE_DAY_GAME && StoryManager.current_event != StoryManager.Event.WIDOW_DAY_GAME_CORRECT:
		#exclamation_sprite.visible = true
	#if StoryManager.current_event == StoryManager.Event.NIGHT_ENTER_CONBINI && StoryManager.current_event != StoryManager.Event.WIDOW_SUCCESS_NIGHT:
		#exclamation_sprite.visible = true
	#else:
		#exclamation_sprite.visible = false

var grocery_ui: Control
var canvas_layer: CanvasLayer


func _on_interacted() -> void:
	if enabled:
		PlayerController.control_player()
		PlayerController.stop()
		enabled = false
		canvas_layer = get_node_or_null("../../CanvasLayer")
		if !canvas_layer: canvas_layer = get_node_or_null("../CanvasLayer")
		if canvas_layer:
			grocery_ui = canvas_layer.get_node_or_null("GroceryUI")
			show_grocery_ui()
		print("grocery item interaacted")
	super()

func show_grocery_ui():
	canvas_layer.visible = true
	
	_set_button_icons()
	_set_hint_texture()
	_connect_buttons()
	grocery_ui.visible = true
	grocery_ui.modulate.a = 1
	
	# Darken the background behind the UI
	var canvas_modulate: CanvasModulate = get_tree().current_scene.get_node_or_null("CanvasModulate")
	canvas_modulate.color = Color(0.7, 0.7, 0.7)

	# Hide the prompt initially
	grocery_ui.get_node("Prompt_Label").visible = false
	grocery_ui.get_node("Prompt").visible = false
	
	# Animate nodes
	var paper: Control = grocery_ui.get_node("Paper")
	var hint: Control = grocery_ui.get_node("Hint")
	var tween: Tween = get_tree().create_tween().set_parallel(true).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(paper, "position:y", paper.position.y, 0.5).from(paper.position.y + 150)
	tween.tween_property(hint, "position:y", hint.position.y, 0.5).from(hint.position.y + 150)

func hide_grocery_ui() -> void:
	var canvas_modulate: CanvasModulate = get_parent().get_parent().get_node("CanvasLayer/CanvasModulate")
	var tween: Tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(canvas_modulate, "color:a", 0, 0.5)

func _set_button_icons() -> void:
	grocery_ui.get_node("Button1").icon = sprite_1
	grocery_ui.get_node("Button2").icon = sprite_2
	grocery_ui.get_node("Button3").icon = sprite_3

func _set_hint_texture() -> void:
	var hint: TextureRect = grocery_ui.get_node("Hint")
	if hint_texture:
		hint.texture = hint_texture
	else:
		hint.texture = [sprite_1, sprite_2, sprite_3][correct_index]

func _connect_buttons() -> void:
	for i in range(3):
		grocery_ui.get_node("Button" + str(i + 1)).connect("pressed", Callable(self, "_on_button_pressed").bind(i))
	
	var prompt: Control = grocery_ui.get_node("Prompt")
	prompt.get_node("Yes").connect("pressed", Callable(self, "_on_yes_pressed"))
	prompt.get_node("No").connect("pressed", Callable(self, "_on_no_pressed"))

func _disconnect_buttons() -> void:
	for i in range(3):
		var button = grocery_ui.get_node("Button" + str(i + 1))
		button.disconnect("pressed", Callable(self, "_on_button_pressed"))
	
	var prompt: Control = grocery_ui.get_node("Prompt")
	prompt.get_node("Yes").disconnect("pressed", Callable(self, "_on_yes_pressed"))
	prompt.get_node("No").disconnect("pressed", Callable(self, "_on_no_pressed"))

func _on_button_pressed(button_index: int) -> void:
	current_button_index = button_index
	_show_prompt()
	animate_nodes_down()

func _on_yes_pressed() -> void:
	print("Item button_index selected: ", current_button_index)
	var is_correct = current_button_index == correct_index
	emit_signal("item_selected", is_correct)
	
	_disconnect_buttons()
	grocery_ui.visible = false
	get_tree().current_scene.get_node_or_null("CanvasModulate").color = Color(1, 1, 1)

	_animate_nodes(-150, 0.5, Tween.TRANS_ELASTIC)

	PlayerController.uncontrol_player()

func _on_no_pressed() -> void:
	grocery_ui.get_node("Prompt_Label").visible = false
	grocery_ui.get_node("Prompt").visible = false
	grocery_ui.get_node("Button" + str(current_button_index + 1)).set_pressed_no_signal(false)
	animate_nodes_up()

func _show_prompt() -> void:
	var prompt_label: Label = grocery_ui.get_node("Prompt_Label")
	var prompt: Control = grocery_ui.get_node("Prompt")
	
	prompt_label.visible = true
	prompt.visible = true

	var tween: Tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(prompt_label, "modulate:a", 1, 0.5)
	tween.tween_property(prompt, "modulate:a", 1, 0.5)

func _hide_prompt() -> void:
	var prompt_label: Label = grocery_ui.get_node("Prompt_Label")
	var prompt: Control = grocery_ui.get_node("Prompt")
	var canvas_modulate: CanvasModulate = get_parent().get_parent().get_node("CanvasLayer/CanvasModulate")
	
	var tween: Tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(prompt_label, "modulate:a", 0, 0.5)
	tween.tween_property(prompt, "modulate:a", 0, 0.5)
	tween.tween_property(canvas_modulate, "color:a", 0, 0.5)
	# tween.connect("finished", Callable(self, "_on_tween_finished"))

func animate_nodes_down() -> void:
	if is_paper_down: return
	
	_animate_nodes(150, 0.5, Tween.TRANS_ELASTIC)
	is_paper_down = true

func animate_nodes_up() -> void:
	if not is_paper_down: return
	
	_animate_nodes(-150, 0.5, Tween.TRANS_ELASTIC)
	is_paper_down = false

func _animate_nodes(offset: float, duration: float, transition: int) -> void:
	var paper: Control = grocery_ui.get_node("Paper")
	var hint: Control = grocery_ui.get_node("Hint")
	
	var tween: Tween = get_tree().create_tween().set_parallel(true).set_trans(transition)
	tween.tween_property(paper, "position:y", paper.position.y + offset, duration)
	tween.tween_property(hint, "position:y", hint.position.y + offset, duration)
