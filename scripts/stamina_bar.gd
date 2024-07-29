extends Control

@onready var sprite = $Sprite

func update_stamina_bar(value):
	sprite.frame = clamp(value/5,0,19)
