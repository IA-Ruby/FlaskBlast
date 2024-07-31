extends CharacterBody2D

const MAX_SPEED = 1000.0
var SPEED = MAX_SPEED

var can_be_slowed = true
var slow = 0
var can_be_stunned = true
var stunned = false
var can_move = true

var direction : Vector2
@onready var hitbox_component = $Hitbox_Component
@onready var check_light = $Check_light
@onready var collision_shape = $CollisionShape
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var health_component = $Health_Component
@onready var hit_zone = $HitZone

func _ready():
	pass
	
func _physics_process(_delta):
	check_light_nearby()
	if can_move:
		for entity in hit_zone.get_overlapping_bodies():
			if entity == Global.player_node:
				var new_attack = Attack.new()
				new_attack.attack_damage = 1
				new_attack.attack_type = "enemy"
				Global.player_node.hitbox_component.damage(new_attack)
		move_and_slide()
				
func update_sprite():
	if animated_sprite_2d:
		if(direction.x > 0):
			if(direction.y > 0): 
				animated_sprite_2d.play("down_right")
			elif(direction.y < 0): 
				animated_sprite_2d.play("top_right")
			else: 
				animated_sprite_2d.play("right")
				
		if(direction.x < 0):
			if(direction.y > 0):
				animated_sprite_2d.play("down_left")
			elif(direction.y < 0): 
				animated_sprite_2d.play("top_left")
			else: 
				animated_sprite_2d.play("left")
		
		if(direction.x == 0):
			if(direction.y > 0): 
				animated_sprite_2d.play("down")
			if(direction.y < 0): 
				animated_sprite_2d.play("top")

func check_light_nearby():
	for area in check_light.get_overlapping_areas():
		if area is LightComponent:
			if area.emit_light:
				can_move = false
			else:
				can_move = true
	for area in hitbox_component.get_overlapping_areas():
		if area is LightComponent:
			if area.emit_light:
				can_move = false
				visible = false
				collision_shape.disabled = true
				health_component.can_take_damage = false
			else:
				can_move = true
				visible = true
				collision_shape.disabled = false
				health_component.can_take_damage = true
