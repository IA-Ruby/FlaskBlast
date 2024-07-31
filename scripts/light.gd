extends Node2D
class_name LightComponent

@onready var object_light = $ObjectLight
@onready var shadow_light = $ShadowLight

@export var color := Color(1.0,1.0,1.0,1.0)
@export var energy_on := 1.0
@export var energy_off := 0.0
@export var mode := 0

var emit_light = true

func _ready():
	object_light.color = color
	object_light.energy = energy_on
	shadow_light.color = color
	shadow_light.energy = energy_on
	object_light.set_blend_mode(mode)
	shadow_light.set_blend_mode(mode)
	
func update_light(light):
	if light:
		self.scale = Vector2(2,2)
		object_light.energy = energy_on
		shadow_light.energy = energy_on
		shadow_light.shadow_enabled = true
		object_light.set_blend_mode(mode)
		emit_light = true
	else:
		self.scale = Vector2(1.5,1.5)
		object_light.energy = energy_off
		shadow_light.energy = energy_off
		shadow_light.shadow_enabled = false
		shadow_light.set_blend_mode(2)
		emit_light = false
		
func turn_on():
	self.visible = true
	
func turn_off():
	self.visible = false
