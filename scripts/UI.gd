extends CanvasLayer
class_name UI

@onready var score_label = %Score
@onready var crystal_count_label = %CrystalCount
@onready var health_label = %Health
@onready var _atk_label = %Atk
@onready var _def_label = %Def


@onready var _player = get_parent().get_node("Player")


var score = 0:
	set(new_score):
		score = new_score
		_update_score_label()

func _on_died() -> void:
	score += 100
	
func _update_atk_label():
	_atk_label.text = "ATK: " + str(_player.attack)
	
func _update_def_label():
	_def_label.text = "Def: " + str(_player.defense)

func _update_crystal_label():
	crystal_count_label.text = "Crystals: " + str(_player.crystals)

func _update_score_label():
	score_label.text = "Score: " + str(score)

func _update_health_label():
	health_label.text = "Health: " + str(_player.health)
