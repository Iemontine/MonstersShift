extends Node

var npc: NPC

func set_target_npc(npc_name: String) -> void:
	npc = get_node_or_null(npc_name)
	if npc:
		print("NPC Controller: Target NPC set to ", npc_name)
	else:
		print("NPC Controller: NPC not found")

func playAnimation(animName: String, direction: Vector2 = Vector2.ZERO) -> void:
	if npc:
		npc.playAnimation(animName, direction)

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
