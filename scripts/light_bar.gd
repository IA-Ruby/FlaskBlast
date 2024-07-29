extends Control

@onready var sprite = $Sprite

func update_light_bar(value):
	sprite.frame = clamp(value/5,0,19)
