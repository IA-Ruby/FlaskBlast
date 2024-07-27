extends Node2D

@onready var object_light = $ObjectLight
@onready var shadow_light = $ShadowLight

@export var color = Color(1.0,1.0,1.0,1.0)
@export var energy_on := 1.0
@export var energy_off := 0.0

func _ready():
	object_light.color = color
	object_light.energy = energy_on 
	shadow_light.color = color
	object_light.energy = energy_on 

func update_light(light):
	if light:
		self.scale = Vector2(1,1)
		object_light.energy = energy_on
		object_light.set_blend_mode(0)
		shadow_light.energy = energy_on
		shadow_light.set_blend_mode(0)
		shadow_light.shadow_enabled = true
	else:
		self.scale = Vector2(2,2)
		object_light.energy = energy_off
		object_light.set_blend_mode(2)
		shadow_light.energy = energy_off
		shadow_light.set_blend_mode(2)
		shadow_light.shadow_enabled = false
		
func turn_on():
	self.visible = true
	
func turn_off():
	self.visible = false
