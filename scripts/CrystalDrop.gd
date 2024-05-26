extends Node2D

signal crystal_pickup(value)

@export var crystal_value: int = 1

@onready var player = get_parent().get_node("Player")

func _ready():
	crystal_pickup.connect(player._on_crystal_pickup)
	
func pickup_item():
	crystal_pickup.emit(crystal_value)
	queue_free()

func _on_area_2d_body_entered(body):
	if body == player:
		pickup_item()
