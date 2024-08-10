class_name HealthComponent
extends Node2D

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
	if Invencibility_time > 0: invencibility_timer.set_wait_time(Invencibility_time)

func damage(attack: Attack):
	if !can_take_damage and attack.attack_type == "enemy":
		pass
	else:
		shield -= attack.attack_damage
		if shield <= 0:
			health += shield
			shield = 0
			if health <= 0:
				if get_parent() == Global.player_node:
					Global.player_node.lose()
					pass
				else:
					get_parent().queue_free()
		if attack.attack_type == "enemy":
			can_take_damage = false
			invencibility_timer.start()
	if health_bar:
		health_bar.update_health_bar()
func update_health_bar():
	health_bar.update_health_bar()

func _on_invencibility_timer_timeout():
	can_take_damage = true
