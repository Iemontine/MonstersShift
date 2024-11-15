class_name Player
extends CharacterBody2D

@onready var animationPlayer = $SpriteLayers/AnimationPlayer
@onready var animationTree = $SpriteLayers/AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var interact_box = $InteractBox

const ACCELERATION = 10
const FRICTION = 10

@export var speed = 100
var last_direction = Vector2.ZERO
@export var camera: NodePath
var frozen = false
var enter_scene: bool = false
var walk_to: bool = false
var ignore_loadzone = false
var cutscene_walk: bool = false
var cutscene_walk_direction: Vector2

func _ready():
	animationTree.set_animation_player(animationPlayer.get_path())
	animationTree.active = true

func travel_to_anim(animName:String, direction = null):
	if direction != null: last_direction = direction
	
	animationTree.set("parameters/"+animName+"/blend_position", last_direction)
	animationState.travel(animName)
	# TODO: reimplement the interact box moving based on direction

func handle_interaction():
	if frozen and not walk_to:
		return
		
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = interact_box.shape
	query.transform = interact_box.global_transform
	query.collision_mask = collision_layer

	var result = space_state.intersect_shape(query)
	for collision in result:
		var collider = collision.collider
		if collider is Interactable:
			collider.interact()


func _physics_process(_delta):
	move_and_slide()
	
	if Input.is_action_just_pressed("ui_accept"):
		handle_interaction()


func _on_freeze():
	frozen = true


func _on_unfreeze():
	frozen = false
