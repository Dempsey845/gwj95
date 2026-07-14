extends TextureProgressBar

@export var water_level: WaterLevel

func _ready() -> void:
	water_level.water_level_changed.connect(_on_water_level_changed)

func _on_water_level_changed(new_water_level: float):
	value = new_water_level / water_level.max_water_level
