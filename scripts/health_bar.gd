extends Control

@onready var health_1 = $Health1
@onready var health_2 = $Health2
@onready var health_3 = $Health3
@onready var health_4 = $Health4
@onready var health_5 = $Health5

var full_heart = 0
var half_heart = 1
var no_heart = 2

var full_shield = 3
var half_shield_full_heart = 4
var half_shield_half_or_no_heart = 5

func update_health_bar(health, shield):
	check_heart(health_1,health,shield)
	check_heart(health_2,health-2,shield-2)
	check_heart(health_3,health-4,shield-4)
	check_heart(health_4,health-6,shield-6)
	check_heart(health_5,health-8,shield-8)

func check_heart(heart,health,shield):
	if health < 0:
		heart.frame = no_heart
		if shield == 1:
			heart.frame = half_shield_half_or_no_heart
		if shield > 1:
			heart.frame = full_shield 
	if health == 1:
		heart.frame = half_heart
		if shield == 1:
			heart.frame = half_shield_half_or_no_heart
		if shield > 1:
			heart.frame = full_shield 
	if health > 1: 
		heart.frame = full_heart
		if shield == 1:
			heart.frame = half_shield_full_heart
		if shield > 1:
			heart.frame = full_shield 
