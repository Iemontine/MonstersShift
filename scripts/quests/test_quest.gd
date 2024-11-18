extends Quest
class_name TestQuest

func start() -> void:
	QuestSignals.test_quest.emit()
	super()

func get_quest_name() -> String:
	return "Test Quest"
