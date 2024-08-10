class_name InteractComponent
extends Area2D

@onready var canvas_layer = $CanvasLayer

var interact : Callable = func():
	pass

func _input(event):
	if event.is_action_pressed("Interact") and canvas_layer.visible == true:
		interact.call()

func _on_body_entered(body):
	if body == Global.player_node:
		canvas_layer.visible = true
		
func _on_body_exited(body):
	if body == Global.player_node:
		canvas_layer.visible = false
	
