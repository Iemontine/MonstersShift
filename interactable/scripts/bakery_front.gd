extends Area2D


func _on_body_entered(body: Node2D) -> void:
	body.textbox.say("That smells fantastic! I wonder what they have?", 3)
