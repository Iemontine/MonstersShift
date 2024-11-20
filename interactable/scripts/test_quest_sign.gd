extends Interactable
class_name TestQuestSign

var quest_accepted : bool = false

@onready var quest:TestQuest = TestQuest.new()

func _on_interacted() -> void:
	if not quest_accepted:
		quest_manager.accept_quest(quest)
		quest_accepted = true
