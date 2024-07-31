extends Control
class_name HealthBar

@export var health = HealthComponent

@onready var heart_1 = $Heart1
@onready var heart_2 = $Heart2
@onready var heart_3 = $Heart3
@onready var heart_4 = $Heart4
@onready var heart_5 = $Heart5

const full_heart = 0
const half_heart = 1
const no_heart = 2

const full_shield = 3
const half_shield_full_heart = 4
const half_shield_half_or_no_heart = 5

func update_health_bar():
	check_heart(heart_1,health.health,health.shield)
	check_heart(heart_2,health.health-2,health.shield-2)
	check_heart(heart_3,health.health-4,health.shield-4)
	check_heart(heart_4,health.health-6,health.shield-6)
	check_heart(heart_5,health.health-8,health.shield-8)

func check_heart(heart,health_value,shield):
	if health_value <= 0:
		heart.frame = no_heart
		if shield == 1:
			heart.frame = half_shield_half_or_no_heart
		if shield > 1:
			heart.frame = full_shield 
	if health_value == 1:
		heart.frame = half_heart
		if shield == 1:
			heart.frame = half_shield_half_or_no_heart
		if shield > 1:
			heart.frame = full_shield 
	if health_value > 1: 
		heart.frame = full_heart
		if shield == 1:
			heart.frame = half_shield_full_heart
		if shield > 1:
			heart.frame = full_shield 
