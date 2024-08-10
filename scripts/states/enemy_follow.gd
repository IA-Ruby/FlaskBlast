class_name EnemyFollow
extends State

@export var enemy : CharacterBody2D
var player : CharacterBody2D

func Enter():
	player = get_tree().get_first_node_in_group("player")

func Physics_Update(delta):
	enemy.direction = player.global_position - enemy.global_position
	if enemy.direction.length() < 150 or enemy.speed == 300:
		enemy.velocity = enemy.direction.normalized() * enemy.speed * delta
	else:
		Transitioned.emit(self,"EnemyIdle")
