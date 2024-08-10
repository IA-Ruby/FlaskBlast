extends Node2D

@onready var interact_component = $InteractComponent

var player_inside = false

func _ready():
	interact_component.interact = Callable(self,"_on_interact")

func _on_interact():
	Global.player_node.win()
