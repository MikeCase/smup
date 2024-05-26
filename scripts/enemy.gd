extends CharacterBody2D

signal died()

@export_group("Stats")
@export var HP: float = 10
@export var dmg: int = 3

@export_group("Multiplyers")
@export var waveMultiplyer: int

@export_group("Enemy Dependencies")
@export var hitParticle : PackedScene
@export var deathParticle: PackedScene
@export var dropItem: Array[PackedScene]

var motion = Vector2()

@onready var health_label = $HealthLabel
@onready var _player = get_parent().get_node("Player")
@onready var _ui = get_parent().get_node("UI")


func _ready():
	HP = HP * waveMultiplyer
	dmg = HP * waveMultiplyer
	died.connect(_ui._on_died)
	died.connect(_player._on_enemy_died)
	set_health_label()
	
func _physics_process(_delta):
	var travel_velocity = randf_range(95.0, 300.0)
	var Player = get_parent().get_node("Player")
	position += (Player.position - position)/travel_velocity
	look_at(Player.position)
	move_and_collide(motion)

func set_health_label():
	health_label.text = str(HP)

func show_particle(body, particle):
	var _Particle = particle.instantiate()
	_Particle.position = body.global_position
	_Particle.rotation = body.global_rotation
	_Particle.emitting = true
	get_tree().current_scene.add_child(_Particle)

func drop_item():
	var item_idx = randi_range(0, len(dropItem)-1)
	var _item = dropItem[item_idx].instantiate()
	_item.position = global_position
	_item.rotation = global_rotation
	get_tree().current_scene.add_child.call_deferred(_item, true)
	
func die(body):
	if dropItem:
		drop_item()
	show_particle(body, deathParticle)
	died.emit()
	queue_free()
	
func take_damage(body):
	show_particle(body, hitParticle)
	HP -= body.dmg
	set_health_label()
	body.queue_free()
	if HP <= 1:
		die(body)
		
func _on_area_2d_body_entered(body):
	if "Ammo" in body.name:
		take_damage(body)
		
