extends NPC
class_name WidowNPC

var player:Player
var player_in_area:bool = false

func _ready() -> void:
	state = NPCState.NORMAL # TODO: WIDOW_IDLE? widow states?
	$Glowingeye.visible = false
	$Glowingeye2.visible = false
	super._ready()

func _physics_process(_delta: float) -> void:
	if state == NPCState.CONTROLLED or state == NPCState.LOCKED:	# Important it is both CONTROLLED and LOCKED
		super._physics_process(_delta)
		return
		
	super._physics_process(_delta)

func on_interacted() -> void:
	print("Interacted with Widow")

func _on_area_2d_body_entered(_body: Object) -> void:
	if _body is Player:
		player = _body
		player_in_area = true

func _on_area_2d_body_exited(_body: Object) -> void:
	if _body is Player:
		player_in_area = false

func activate_glow() -> void:
	$Glowingeye.visible = true
	$Glowingeye2.visible = true
	$Glow.visible = true

func deactivate_glow() -> void:
	$Glowingeye.visible = false
	$Glowingeye2.visible = false
	$Glow.visible = false

func attack(direction: Vector2) -> void:
	state = NPCState.WIDOW_ATTACKING
	set_collision_layer_value(1, false) # Disable Collision Layer 1
	set_collision_mask_value(1, false) # Disable Collision Mask 1
	travel_to_anim("Hug", direction)


	var scream_sounds = [
		preload("res://assets/assets_widow/scream-with-echo-46585.mp3"),
		preload("res://assets/assets_widow/scream-noise-142446.mp3")
	]
	var scream_sound = scream_sounds[randi() % scream_sounds.size()]
	var scream_player = AudioStreamPlayer.new()
	scream_player.stream = scream_sound
	add_child(scream_player)
	scream_player.play()

	activate_glow()

	var player_position = get_tree().current_scene.get_node("Player").position

	var tween: Tween = get_tree().create_tween().set_parallel(true).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "modulate:a", 1, 0.3).from(0)
	tween.tween_property($Glow, "color:a", 1, 0.3).from(1).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, "position", player_position - direction * 4, 0.5).from(player_position - direction * 50).set_trans(Tween.TRANS_BOUNCE)
	

func backoff() -> void:
	state = NPCState.WIDOW_BACKING_OFF
	travel_to_anim("Evade", last_direction)
	
	var tween: Tween = get_tree().create_tween().set_parallel(true).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "modulate:a", 0, 0.5)
	tween.tween_property($Glow, "color:a", 0, 0.3).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, "position", position - last_direction * 50, 0.5)

	await get_tree().create_timer(0.5).timeout
	
	state = NPCState.WIDOW_IDLE
