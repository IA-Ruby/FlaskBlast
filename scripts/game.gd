extends Node2D

@onready var canvas_modulate = $CanvasModulate

func _process(delta):
	if Global.objective == 5:
		canvas_modulate.visible = false
