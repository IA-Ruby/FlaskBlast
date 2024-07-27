extends Camera2D

@export var randomStrength := 10.0
@export var shakeFade := 5.0

var shake_strength = 0.0

func apply_shake():
	shake_strength = randomStrength
	
func _process(delta):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shakeFade*delta)
	self.offset = randomOffset()
	
func randomOffset():
	return Vector2(randf_range(-shake_strength, shake_strength),randf_range(-shake_strength, shake_strength))
