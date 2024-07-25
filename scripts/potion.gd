@tool
extends Node2D

@export var amount = ""
@export var potion_name = ""
@export var potion_effect = ""
@export var potion_texture: Texture 
@export var potion_color: Color
@export var potion_size := 0:
	set(value):
		potion_size = clamp(value,0, 11)
		
var scene_path: String = "res://scenes/potion.tscn"

@onready var sprite = $Sprite2D
		
func _ready():
	if not Engine.is_editor_hint():
		sprite.texture = potion_texture
		sprite.frame = potion_size
		sprite.material.set_shader_parameter("new_color", potion_color)

func _process(_delta):
	if Engine.is_editor_hint():
		sprite.texture = potion_texture
		sprite.frame = potion_size
		sprite.material.set_shader_parameter("new_color", potion_color)
		
func add_potion():
	var potion = {
		"amount" : amount,
		"name": potion_name,
		"effect": potion_effect,
		"texture": potion_texture,
		"color": potion_color,
		"size": potion_size,
		"scene_path": scene_path,
	}
	if Global.player_node:
		Global.add_potion(potion)
		self.queue_free()		

