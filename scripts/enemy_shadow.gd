extends CharacterBody2D

const MAX_SPEED = 1000.0
var speed = MAX_SPEED

var can_be_slowed = true
var can_be_stunned = true
var stunned = false
var no_light = true

var direction : Vector2
@onready var hitbox_component = $HitboxComponent
@onready var check_light = $CheckLight
@onready var collision_shape = $CollisionShape
@onready var animated_sprite = $AnimatedSprite
@onready var health_component = $HealthComponent
@onready var hit_zone = $HitZone
	
func _physics_process(_delta):
	check_light_nearby()
	if no_light and !stunned:
		for entity in hit_zone.get_overlapping_bodies():
			if entity == Global.player_node:
				var new_attack = Attack.new()
				new_attack.attack_damage = 1
				new_attack.attack_type = "enemy"
				Global.player_node.hitbox_component.damage(new_attack)
		update_sprite()
		move_and_slide()
	if stunned:
		animated_sprite.stop()
				
func update_sprite():
	#if animated_sprite:
	if(direction.x > 0):
		if(direction.y > 0): 
			animated_sprite.play("down_right")
		elif(direction.y < 0): 
			animated_sprite.play("top_right")
		else: 
			animated_sprite.play("right")
			
	if(direction.x < 0):
		if(direction.y > 0):
			animated_sprite.play("down_left")
		elif(direction.y < 0): 
			animated_sprite.play("top_left")
		else: 
			animated_sprite.play("left")
	
	if(direction.x == 0):
		if(direction.y > 0): 
			animated_sprite.play("down")
		if(direction.y < 0): 
			animated_sprite.play("top")

func check_light_nearby():
	for area in check_light.get_overlapping_areas():
		if area is LightComponent:
			if area.emit_light:
				no_light = false
			else:
				no_light = true
	for area in hitbox_component.get_overlapping_areas():
		if area is LightComponent:
			if area.emit_light:
				no_light = false
				visible = false
				collision_shape.disabled = true
				health_component.can_take_damage = false
			else:
				no_light = true
				visible = true
				collision_shape.disabled = false
				health_component.can_take_damage = true
