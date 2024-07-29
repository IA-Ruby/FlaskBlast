extends StaticBody2D

@onready var light = $Light

var player_inside = false
var interactable = true

@export var start_light = false

func _ready():
	if start_light == true:
		interactable = false
		light.turn_on()

func _process(_delta):
	if Input.is_action_just_pressed("Interact") and player_inside and interactable:
		light.turn_on()
		interactable = false
		Global.interact_nearby = false
		
func _on_area_2d_body_entered(body):
	if body == Global.player_node:
		if interactable == true:
			Global.interact_nearby = true
		player_inside = true

func _on_area_2d_body_exited(body):
	if body == Global.player_node:
		Global.interact_nearby = false
	player_inside = false
