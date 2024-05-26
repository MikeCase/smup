extends CharacterBody2D

signal enemy_died

@export_group("Multiplyers")
@export var attack: float = 0.0:
	set(value):
		attack = value
		#_ui._update_atk_label()

@export var defense: float = 0.0:
	set(value):
		defense = value
		_ui._update_def_label()

@export_group("Stats")
# ATK, DEF, STA, HEALTH, ATK_SPD, SCORE, CRYSTALS
@export var speed = 200
@export var bullet_speed = 1000

@export var autofire_delay = 1:
	set(value):
		autofire_delay = value
		if autofire_delay <= 0.01:
			autofire_delay = 0.02

# Doing it this way helps me update labels automagically so I don't have to 
# remember to put _ui._update_whatever_label() every time I update the value.
@export var health = 100:
	set(value):
		health = value
		_ui._update_health_label()

@export_group("Inventory")
@export var crystals: int = 0:
	set(value):
		crystals = value
		_ui._update_crystal_label()

@export_group("Character Dependencies")
@export var ammoPrefab: PackedScene
var enemies_terminated: int = 0:
	set(value):
		enemies_terminated = value
		if enemies_terminated >= 5:
			print("Decreasing autofire delay")
			enemies_terminated = 0
			autofire_delay -= 0.1
			print(autofire_delay)

@onready var muzzle_flash = $weapon/FirePoint/MuzzleFlash
@onready var timer = $Timer
@onready var fire_point = $weapon/FirePoint
@onready var _ui = get_parent().get_node("UI")

# Called when the node enters the scene tree for the first time.
func _ready():
	
	_ui._update_crystal_label()
	_ui._update_health_label()
	_ui._update_atk_label()
	_ui._update_def_label()
	timer.start()

func _process(_delta):
	if crystals >= 3:
		level_up()
	
		
func level_up():
	attack += crystals * 0.23
	defense += crystals * 0.23
	_ui._update_atk_label()
	crystals = 0

func _physics_process(_delta):
	
	if Input.is_action_just_pressed("LMB"):
		fire()
	look_at(get_global_mouse_position())
	var move_input = Input.get_axis("move_backward", "move_forward")
	velocity = transform.x * move_input * speed
	move_and_slide()


func fire():
	#muzzle_flash.emitting = true
	var bullet_instance = ammoPrefab.instantiate()
	bullet_instance.position = fire_point.get_global_position()
	bullet_instance.rotation_degrees = rotation_degrees - 90.0
	bullet_instance.dmg = attack
	bullet_instance.apply_impulse(Vector2(bullet_speed, 0).rotated(global_rotation), Vector2())
	get_tree().current_scene.add_child(bullet_instance, true)
	
	
	
func take_damage(damage):
	health -= (damage - defense)
	if health <= 0:
		die()

func die():
	get_tree().reload_current_scene()
	
func _set_af_timeout():
	timer.stop()
	timer.set_wait_time(autofire_delay)
	timer.start()

func _on_health_pickup(value):
	health += value

func _on_crystal_pickup(value):
	crystals += value
	
func _on_area_2d_body_entered(body):
	if "Enemy" in body.name:
		take_damage(body.dmg)
	
func _on_timer_timeout():
	#fire()
	pass
	
func _on_enemy_died():
	enemies_terminated += 1
	_set_af_timeout()
