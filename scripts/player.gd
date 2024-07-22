extends CharacterBody2D

const SPEED = 10000.0

func _physics_process(delta):
	var direction = Input.get_vector("left","right","up","down")
	
	if direction:
		self.velocity = SPEED * direction * delta 
		if Input.is_action_pressed("sprint"):
			self.velocity *= 2
	else:
		self.velocity = Vector2.ZERO
		
	move_and_slide()
