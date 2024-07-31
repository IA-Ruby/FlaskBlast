extends State
class_name EnemyFollow

@export var enemy : CharacterBody2D
var player : CharacterBody2D

func Enter():
	player = get_tree().get_first_node_in_group("player")

func Physics_Update(delta):
	if enemy.has_method("update_sprite"):
		enemy.update_sprite()
	enemy.direction = player.global_position - enemy.global_position
	if enemy.direction.length() < 150 or enemy.SPEED == 300:
		enemy.velocity = enemy.direction.normalized() * enemy.SPEED * delta
	else:
		Transitioned.emit(self,"EnemyIdle")
