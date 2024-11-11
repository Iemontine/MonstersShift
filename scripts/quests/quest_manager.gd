extends Node
class_name QuestManager

var quest_list : Dictionary[String,Quest]


var _active_quest : String


func _init() -> void:
	pass

func accept_quest(quest:Quest) -> void:
	if quest.get_quest_name() == "null quest":
		printerr("cannot add null quest to questlog")
		return
	elif quest_list.has(quest.get_quest_name()):
		printerr("cannot add a quest thats already accepted")
		return
	
	quest_list[quest.get_quest_name()] = quest
	
func set_active_quest(quest:Quest) -> void:
	if quest.get_quest_name() == "null quest":
		printerr("cannot set null quest as active quest")
		return
	elif not quest_list.has(quest.get_quest_name()):
		printerr("cannot set a quest that hasn't been accepted as active quest")
		return
	
	_active_quest = quest.get_quest_name()
