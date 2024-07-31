extends Node2D
class_name HealthComponent

@onready var invencibility_timer = $InvencibilityTimer

@export var health_bar : HealthBar
@export var MAX_HEALTH := 10
@export var MAX_SHIELD := 10
@export var Invencibility_time := 0
var health
var shield 
var can_take_damage = true

func _ready():
	health = MAX_HEALTH
	shield = 0

func damage(attack: Attack):
	if !can_take_damage and attack.attack_type == "enemy":
		pass
	else:
		shield -= attack.attack_damage
		if shield <= 0:
			health += shield
			shield = 0
			if health <= 0 and get_parent() == Global.player_node:
				Global.player_node.lose()
				pass
		if health_bar:
			health_bar.update_health_bar()
		if attack.attack_type == "enemy":
			can_take_damage = false
			invencibility_timer.start()
	
func update_health_bar():
	health_bar.update_health_bar()

func _on_invencibility_timer_timeout():
	can_take_damage = true
