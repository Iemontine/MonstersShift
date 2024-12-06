#Global Class: NpcController
extends Node

var npc: NPC

func set_target_npc(npc_name: String) -> void:
	var current_scene = get_tree().current_scene
	npc = current_scene.get_node_or_null(npc_name)

func _on_dialogic_signal(argument:String):
	print(argument)
	if argument == "control_npc":
		control_npc()
	elif argument == "uncontrol_npc":
		uncontrol_npc()

func control_npc() -> void:
	npc.state = NPC.NPCState.CONTROLLED

func uncontrol_npc() -> void:
	npc.state = NPC.NPCState.NORMAL

func playAnimation(animName: String, direction_x: int = 0, direction_y: int = 0) -> void:
	if npc:
		npc.playAnimation(animName, Vector2(direction_x, direction_y))

func animationComplete() -> void:
	if npc:
		npc.animationComplete()

func setSpeed(speed: float) -> void:
	if npc:
		npc.setSpeed(speed)

func sprint() -> void:
	if npc:
		npc.sprint()

func resetSpeed() -> void:
	if npc:
		npc.resetSpeed()

func moveUp() -> void:
	if npc:
		npc.move(Vector2.UP)

func moveDown() -> void:
	if npc:
		npc.move(Vector2.DOWN)

func moveLeft() -> void:
	if npc:
		npc.move(Vector2.LEFT)

func moveRight() -> void:
	if npc:
		npc.move(Vector2.RIGHT)

func stop() -> void:
	if npc:
		npc.stop()

func switchScene(destination_scene: String, destination_loadzone: String) -> void:
	if npc:
		npc.switchScene(destination_scene, destination_loadzone)

func advanceStory() -> void:
	if npc:
		npc.advanceStory()

func hideSprite() -> void:
	if npc:
		npc.visible = false
