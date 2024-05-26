extends Node2D

signal health_pickup(value)

@export var health: int = 10

@onready var player = get_parent().get_node("Player")

func _ready():
	health_pickup.connect(player._on_health_pickup)
	
func pickup_item():
	health_pickup.emit(health)
	queue_free()

func _on_area_2d_body_entered(body):
	if body == player:
		pickup_item()
