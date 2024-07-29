@tool
extends Node2D

@export var potion_name := ""
@export var potion_color: Color
@export var potion_power := 0
@export var potion_size := 0
@export var potion_target := 0
@export var potion_type := 0

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
