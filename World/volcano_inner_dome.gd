extends MeshInstance3D

@export var terrain: Terrain3D

@onready var vol_zone: Zone = get_parent()

func _ready() -> void:
	vol_zone.zone_spawned.connect(func():
		visible = true
		terrain.visible = false
	)
	
	vol_zone.zone_destroyed.connect(func():
		visible = false
		terrain.visible = true
	)
	
