extends CharacterBody2D

const SPEED = 5000.0
var light_ready := true

@onready var animation_player = $AnimationPlayer
@onready var object_light = $Node2D/ObjectLight
@onready var shadow_light = $Node2D/ShadowLight
@onready var timer = $Timer

func _physics_process(delta):
	change_intensity(delta)
	var direction = Input.get_vector("left","right","up","down")	
	
	if(direction.x > 0):
		if(direction.y > 0): 
			animation_player.play("down_right")
		elif(direction.y < 0): 
			animation_player.play("top_right")
		else: 
			animation_player.play("right")
			
	if(direction.x < 0):
		if(direction.y > 0): 
			animation_player.play("down_left")
		elif(direction.y < 0): 
			animation_player.play("top_left")
		else: 
			animation_player.play("left")
	
	if(direction.x == 0):
		if(direction.y > 0): 
			animation_player.play("down")
		if(direction.y < 0): 
			animation_player.play("top")
		
	if direction:
		self.velocity = SPEED * direction * delta 
		if direction.y != 0:
			self.velocity *=  Vector2(1,0.5) 
		if Input.is_action_pressed("sprint"):
			self.velocity *= 2
	else:
		self.velocity = Vector2.ZERO
		
	move_and_slide()

func change_intensity(delta):
	if light_ready == true && object_light.texture_scale < .05:
		change_light(.01, delta)
	if Input.is_action_pressed("lightup") && light_ready == true:
		change_light(.05, delta)		
		if object_light.texture_scale >= .15:
			light_ready = false
			object_light.texture_scale = 0
			shadow_light.texture_scale = 0
			timer.start()
	else:
		if object_light.texture_scale > .05: 
			change_light(-.1, delta)
		
	
func change_light(value, delta):
	object_light.texture_scale += value * delta
	shadow_light.texture_scale += value * delta
	object_light.texture_scale = clamp(object_light.texture_scale, 0, 0.15)
	shadow_light.texture_scale = clamp(shadow_light.texture_scale, 0, 0.15)

func _on_timer_timeout():
	light_ready = true
