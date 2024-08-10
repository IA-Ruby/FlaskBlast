class_name EffectSprite
extends Control

@export var type : String
@export var color : Color
@export var damage : int
@export var time : float

@onready var sprite = $Control/Sprite
@onready var damage_label = $Control/DamageLabel

@onready var vanish = $Vanish
@onready var canvas_layer = $CanvasLayer

func _ready():	
	if type: 
		sprite.play(type)
	if damage:
		damage_label.visible = true
		damage_label.text = str(damage)
		damage_label.position = damage_label.position + Vector2(randf_range(-10,10),randf_range(-10,10))
		damage_label.set("theme_override_colors/font_color",color)
	if time: 
		vanish.set_wait_time(time)
	vanish.start()
	
func _process(_delta):
	if get_parent().health.shield == 0 and type == "shield":
		self.queue_free()
	
func _on_vanish_timeout():
	self.queue_free()

func _on_label_vanish_timeout():
	damage_label.visible = false
