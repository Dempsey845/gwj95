extends StaticBody3D

@onready var first_dialogue: DialogueController = $FirstDialogue
@onready var waiting_dialogue: DialogueController = $WaitingDialogue
@onready var key_dialgoue: DialogueController = $KeyDialgoue
@onready var interact_zone: InteractZone = $InteractZone

var started: bool

enum DialogueStage {
	first,
	waiting,
	complete
}

var dialogue_stage: DialogueStage = DialogueStage.first

func _ready() -> void:
	interact_zone.interacted.connect(func():
		if DialogueManager.instance.in_dialogue:
			return

		match dialogue_stage:
			DialogueStage.first:
				first_dialogue.start()
				dialogue_stage = DialogueStage.waiting
			DialogueStage.waiting:
				waiting_dialogue.start()
			DialogueStage.complete:
				key_dialgoue.start()
	)

	DialogueManager.instance.jellyfish_objective_complete.connect(func():
		dialogue_stage = DialogueStage.complete
	)
	