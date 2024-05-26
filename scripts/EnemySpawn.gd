extends Node2D

@export var enemyScene: PackedScene
@export var spawnDelay: float = 5.0
@export var spawnWave: int = 1

@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	set_timeout()
	spawn_enemy(spawnWave)

func spawn_enemy(wave):
	var e = enemyScene.instantiate()
	var spawn_location = $spawnPath/spawnLocation
	spawn_location.progress_ratio = randf()
	var direction = spawn_location.rotation + PI / 2
	e.position = spawn_location.position
	e.waveMultiplyer = wave
	#e.died.connect($UI._on_died)
	direction += randf_range(-PI / 4, PI / 4)
	e.rotation = direction
	get_tree().current_scene.add_child.call_deferred(e,true)
	

func set_timeout():
	timer.stop()
	#print(spawnDelay)
	if spawnDelay <= 0.5:
		spawnDelay = 0.5
	timer.set_wait_time(spawnDelay)
	timer.start()
	
func _on_timer_timeout():
	spawn_enemy(spawnWave)
	spawnDelay -= 0.1
	set_timeout()
