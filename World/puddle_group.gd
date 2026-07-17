class_name PuddleGroup
extends Node

@export var puddles: Array[WaterPuddle]

func reset_puddles():
    for puddle in puddles:
        puddle.reset()