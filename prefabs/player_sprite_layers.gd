class_name PlayerSpriteLayers
extends Node2D

signal animation_state_finished(state_name,state_duration)
signal animation_state_started(state_name)
signal animation_set_hitbox(counter, track, timer_value, direction)
signal make_sound(state_name, sound_name)

var shader = preload("res://shaders/simple_ramp_shader.gdshader")

@export var color_00undr: Color
@export var color_01body: Color = SKIN_COLOR.pick_random()
@export var color_02sock: Color = CLOTHES_COLOR.pick_random()
@export var color_03fot1: Color
@export var color_04lwr1: Color = CLOTHES_COLOR.pick_random()
@export var color_05shrt: Color = CLOTHES_COLOR.pick_random()
@export var color_06lwr2: Color
@export var color_07fot2: Color
@export var color_08lwr3: Color
@export var color_09hand: Color
@export var color_10outr: Color
@export var color_11neck: Color
@export var color_12face: Color
@export var color_13hair: Color
@export var color_14head: Color
@export var color_15over: Color

const DEFAULT_COLORS = [
	Color("#58E0A0"),
	Color("#289860"),
	Color("#205040"),
	Color("#181818"),
	Color("#F8A070"),
	Color("#D84848"),
	Color("#942132"),
	Color("#181818")
]
const SKIN_COLOR = [
	Color(0.851, 0.596, 0.471),
	Color(0.407, 0.238, 0.152),
	Color(0.916, 0.732, 0.644),
	Color(0.67, 0.418, 0.291)
]
const CLOTHES_COLOR = [
	Color(0.864, 0.499, 0.785),
	Color(0.336, 0.671, 0.643),
	Color(0.25, 0.25, 0.25), #gray
	Color(0.009, 0.003, 0.001), # black
	Color(1.0, 1.0, 1.0), #white
	Color(0.003, 0.307, 0.609),
	Color(0.612, 0.141, 0.188),
	Color(0.275, 0.256, 0.077),
	Color(0.707, 0.4, 0.23),
	Color(0.601, 0.601, 0.601),
	Color(0.353, 0.362, 0.532),
	Color(0.181, 0.378, 0.416), 
	
]


var palettes

func load_palettes():
	var farmer_base_path = "res://assets/characters/farmer_base/"
	palettes = {
		"3color": {
			"base_file": farmer_base_path + "_supporting files/palettes/base ramps/3-color base ramp (00a).png",
			"file": farmer_base_path + "_supporting files/palettes/mana seed 3-color ramps.png",
			"base": null,
			"palettes": null
		},
		"4color": {
			"base_file": farmer_base_path + "_supporting files/palettes/base ramps/4-color base ramp (00b).png",
			"file": farmer_base_path + "_supporting files/palettes/mana seed 4-color ramps.png",
			"base": null,
			"palettes": null
		},
		"hair": {
			"base_file": farmer_base_path + "_supporting files/palettes/base ramps/hair color base ramp.png",
			"file": "",
			"base": null,
			"palettes": null
		},
		"skin": {
			"base_file": farmer_base_path + "_supporting files/palettes/base ramps/skin color base ramp.png",
			"file": "",
			"base": null,
			"palettes": null
		},
		"weapon_tool": {
			"base_file": farmer_base_path + "_supporting files/palettes/base ramps/weapon and tool color base ramps.png",
			"file": "",
			"base": null,
			"palettes": null
		}
	}
	for bp in palettes.values():
		var base_texture = load(bp["base_file"])
		bp["base"] = MSCAPaletteSwaps.create_palette_from_image(base_texture.get_image())
		if bp["file"] != "":
			bp["palettes"] = []
			var _palettes = load(bp["file"])
			var palettes_image = _palettes.get_image()
			var palettes_count = palettes_image.get_height() / 2
			for p in palettes_count:
				var start_y = p * 2
				var palette_image = palettes_image.get_region(Rect2i(0, start_y, palettes_image.get_width(), 2))
				var new_palette = MSCAPaletteSwaps.create_palette_from_image(palette_image)
				if new_palette.size() > 0:
					bp["palettes"].append(new_palette)

func _ready():
	load_palettes()

func _process(_delta: float) -> void:
	set_layer_shader("00undr", color_00undr)
	set_layer_shader("01body", color_01body)
	set_layer_shader("02sock", color_02sock)
	set_layer_shader("03fot1", color_03fot1)
	set_layer_shader("04lwr1", color_04lwr1)
	set_layer_shader("05shrt", color_05shrt)
	set_layer_shader("06lwr2", color_06lwr2)
	set_layer_shader("07fot2", color_07fot2)
	set_layer_shader("08lwr3", color_08lwr3)
	set_layer_shader("09hand", color_09hand)
	set_layer_shader("10outr", color_10outr)
	set_layer_shader("11neck", color_11neck)
	set_layer_shader("12face", color_12face)
	set_layer_shader("13hair", color_13hair)
	set_layer_shader("14head", color_14head)
	set_layer_shader("15over", color_15over)
	
func random_color() -> Color:
	var r = randi()%2
	var g = randi()%2
	var b = randi()%2
	return Color(r,g,b)

func set_layer_shader(layer_name: String, base_color: Color):
	var layer_node = get_node_or_null(layer_name)
	if layer_node == null: return
	var shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	var default_colors = get_default_colors_for_layer(layer_name)
	var colors = generate_color_ramp(base_color, default_colors.size())
	for i in range(default_colors.size()):
		var original_color = default_colors[i]
		var replace_color = colors[i] if colors.size() > i else original_color
		shader_material.set_shader_parameter("original_" + str(i), original_color)
		shader_material.set_shader_parameter("replace_" + str(i), replace_color)
	var root_alpha = get_parent().modulate.a
	shader_material.set_shader_parameter("alpha_modulation", root_alpha)
	layer_node.material = shader_material

func generate_color_ramp(base_color: Color, num_colors: int) -> Array:
	var colors = [base_color]
	var step = 1.0 / (num_colors - 1)
	for i in range(1, num_colors):
		var darker_color = base_color.lerp(Color("#181818"), step * i)
		colors.append(darker_color)
	return colors

func get_default_colors_for_layer(layer_name: String) -> Array:
	match layer_name:
		"13hair":
			return palettes["hair"]["base"]
		"12face", "01body":
			return palettes["skin"]["base"]
		"11neck", "14head", "15over":
			return palettes["4color"]["base"]
		"10outr", "00undr", "02sock", "09hand", "03fot1", "04lwr1", "05shrt", "06lwr2", "07fot2", "08lwr3":
			return palettes["3color"]["base"]
		_:
			return DEFAULT_COLORS

func set_corresponding_layers_to_animframe(animframe:int, flipped:bool = false):
	#the Animation Tree must be disabled when you use this
	var corresponding_layers = [$"00undr",$"01body",$"02sock",$"03fot1",$"04lwr1",$"05shrt",$"06lwr2",$"07fot2",$"08lwr3",$"09hand",$"10outr",$"11neck",$"12face",$"13hair",$"14head",$"15over"]
	for l in corresponding_layers:
		if l != null:
			l.frame = animframe
			l.flip_h = flipped

func change_child_position(sprite_layer, pos):
	var spr_layer = self.get_node(sprite_layer)
	if (pos != null && spr_layer != null): self.move_child(spr_layer, pos)

func emit_animation_state_finished(state_name:String,wait_time:float = 0.0):
	emit_signal("animation_state_finished", state_name, wait_time)

func emit_animation_state_started(state_name:String):
	emit_signal("animation_state_started", state_name)

func set_hitbox(counter, track, timer_value, direction):
	emit_signal("animation_set_hitbox", counter, track, timer_value, direction)

func emit_sound(state_name:String, sound_name:String):
	emit_signal("make_sound", state_name, sound_name)
