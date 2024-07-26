@tool
extends Node2D

@export var amount := ""
@export var potion_name := ""
@export var potion_size := 0
@export var potion_color: Color
@export var potion_type := 0
@export var potion_area := 0
@export var potion_effect := 0 

var scene_path: String = "res://scenes/potion.tscn"

@onready var sprite = $Sprite2D
		
func _ready():
	if not Engine.is_editor_hint():
		sprite.frame = potion_size
		sprite.material.set_shader_parameter("new_color", potion_color)

func _process(_delta):
	if Engine.is_editor_hint():
		sprite.frame = potion_size
		sprite.material.set_shader_parameter("new_color", potion_color)
		
func add_potion(slot):
	var potion = {
		#"Item_texture": sprite.texture,
		"amount" : amount,
		"name": potion_name,
		"color": potion_color,
		"size": potion_size,
		"type": potion_type,
		"area": potion_area,
		"effect": potion_effect,
		"scene_path": scene_path,
	}
	if Global.player_node:
		Global.add_potion(potion,slot)
		self.queue_free()		
