extends CharacterBody2D

const SPEED = 10000.0

@onready var sprite = $Sprite2D

func _physics_process(delta):
	var direction = Input.get_vector("left","right","up","down")
	
	if direction == Vector2(1,0):
		sprite.flip_h = false
	if direction == Vector2(-1,0):
		sprite.flip_h = true
		
	if direction:
		self.velocity = SPEED * direction * delta 
		if direction.y != 0:
			self.velocity *=  Vector2(1,0.5) 
		if Input.is_action_pressed("sprint"):
			self.velocity *= 2
	else:
		self.velocity = Vector2.ZERO
		
	move_and_slide()
