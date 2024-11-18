extends Interactable
class_name TestQuestSign



@onready var surroundings:CanvasModulate = get_parent().get_node("Surroundings")
@onready var light:PointLight2D = get_parent().get_node("TreehouseLight")
@onready var quest:TestQuest = TestQuest.new()

func _on_interacted() -> void:
	quest_manager.accept_quest(quest)
