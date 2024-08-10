class_name PotionProjectile
extends Node2D

@onready var sprite = $Sprite
@onready var aoe = $Aoe

@export var SPEED = 100.0

var direction : Vector2
var new_attack : Attack
var sprite_frame : int
var sprite_shader : Color

func _ready():
	sprite.frame = sprite_frame
	sprite.material.set_shader_parameter("new_color", sprite_shader)
	
func _physics_process(delta):
	position += direction * SPEED * delta
	sprite.rotation += 30 * delta
	if sprite.rotation > 360: 
		sprite.rotation -= 360

func _on_body_entered(body):
	if body is TileMap or body is StaticBody2D:
		if new_attack.attack_type == "aoe":
				for in_range in aoe.get_overlapping_areas():
					if in_range.has_method("damage"):
						in_range.damage(new_attack)
		queue_free()

func _on_area_entered(area):
	if area is HitboxComponent:
		if area.get_parent() != Global.player_node:
			if new_attack.attack_type == "single":
					if area.has_method("damage"):
						area.damage(new_attack)
			if new_attack.attack_type == "aoe":
				for in_range in aoe.get_overlapping_areas():
					if in_range.has_method("damage"):
						in_range.damage(new_attack)
			queue_free()
