extends Node2D

@onready var area_2d = $Area2D

var player_inside = false

func _process(delta):
	if Input.is_action_just_pressed("Interact"):
		Global.player_node.win()

func _on_area_2d_body_entered(body):
	if body == Global.player_node:
		Global.interact_nearby = true
		player_inside = true

func _on_area_2d_body_exited(body):
	if body == Global.player_node:
		Global.interact_nearby = false
		player_inside = false
