extends Node2D

@onready var canvas_modulate = $CanvasModulate
@onready var objectives = $Objectives

func _ready():
	Global.set_main_reference(self)
