extends MeshInstance2D


var bullet_speed = 2000
var ammo = preload("res://prefabs/ammo/ammo.tscn")

@onready var fire_point = $FirePoint

func _physics_process(_delta):
	
	if Input.is_action_just_pressed("LMB"):
		fire()
		
func fire():
	var bullet_instance = ammo.instantiate()
	bullet_instance.position = get_global_position()
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(global_rotation))
	fire_point.get_tree().get_root().call_deferred("add_child", bullet_instance)
	
	
	
