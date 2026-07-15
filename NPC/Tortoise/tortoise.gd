extends StaticBody3D

@onready var first_dialogue: DialogueController = $FirstDialogue
@onready var waiting_dialogue: DialogueController = $WaitingDialogue
@onready var interact_zone: InteractZone = $InteractZone

var started: bool

func _ready() -> void:
	interact_zone.interacted.connect(func():
		if !started:
			first_dialogue.start()
			started = true
		else:
			waiting_dialogue.start()
	)
	