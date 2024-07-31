extends CharacterBody2D

var SPEED := 300.0

@onready var death_zone = $DeathZone
var direction : Vector2

func _ready():
	pass
	
func _process(_delta):
	for entity in death_zone.get_overlapping_bodies():
		if entity == Global.player_node:
			var new_attack = Attack.new()
			new_attack.attack_damage = 1
			new_attack.attack_type = "enemy"
			Global.player_node.hitbox_component.damage(new_attack)
	move_and_slide()
