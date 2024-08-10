class_name LightComponent
extends Node2D

@onready var object_light = $ObjectLight
@onready var shadow_light = $ShadowLight

@export var color := Color(1.0,1.0,1.0,1.0)
@export var energy_on := 1.0
@export var energy_off := 0.0
@export var start_on := true

var emit_light = true

func _ready():
	self.visible = GlobalCanvasModulate.visible
	update_light(start_on)
	object_light.color = color
	object_light.energy = energy_on
	shadow_light.color = color
	shadow_light.energy = energy_on
	
func update_light(light):
	if light:
		self.scale = Vector2(2,2)
		object_light.energy = energy_on
		shadow_light.energy = energy_on
		shadow_light.shadow_enabled = true
		emit_light = true
	else:
		self.scale = Vector2(1.5,1.5)
		object_light.energy = energy_off
		shadow_light.energy = energy_off
		shadow_light.shadow_enabled = false
		emit_light = false
		
func turn_on():
	self.visible = true
	
func turn_off():
	self.visible = false
