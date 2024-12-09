extends ProgressBar

@onready var wood: Sprite2D = $Wood
@onready var wood_2: Sprite2D = $Wood2
@onready var wood_3: Sprite2D = $Wood3
@onready var wood_4: Sprite2D = $Wood4
@onready var sound: AudioStreamPlayer = $PlankBreakSound  # Add a child AudioStreamPlayer node for the sound

var last_progress = 100  # Start at maximum progress

func _process(delta: float) -> void:
	var progress = value  # Get the current progress value

	# Check if the progress decreased enough to remove a wood
	if progress <= 80 and last_progress > 80:
		play_sound()
	elif progress <= 60 and last_progress > 60:
		play_sound()
	elif progress <= 40 and last_progress > 40:
		play_sound()
	elif progress <= 20 and last_progress > 20:
		play_sound()

	# Update visibility of wood sprites based on progress
	wood.visible = progress > 20
	wood_2.visible = progress > 40
	wood_3.visible = progress > 60
	wood_4.visible = progress > 80

	# Update the last progress value
	last_progress = progress

func play_sound() -> void:
	if not sound.is_playing():
		sound.play()
