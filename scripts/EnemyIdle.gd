extends State
class_name EnemyIdle

@export var enemy: CharacterBody2D
var player : CharacterBody2D

var wander_time : float

func randomize_wander():
	enemy.direction = Vector2(randi_range(-1,1),randi_range(-1,1))
	wander_time = randf_range(2,5) 
	enemy.update_sprite()
		
func Enter():
	player = get_tree().get_first_node_in_group("player")
	randomize_wander()
	
func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()

func Physics_Update(delta):
	var direction = player.global_position - enemy.global_position
	if enemy:
		enemy.velocity = enemy.direction.normalized() * enemy.SPEED * delta
	if direction.length() < 150:
		Transitioned.emit(self,"EnemyFollow")
