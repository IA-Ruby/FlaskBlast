extends CharacterBody2D

const SPEED = 5000.0
var light_variation := .1

@onready var animation_player = $AnimationPlayer
@onready var object_light = $Light2D/ObjectLight
@onready var shadow_light = $Light2D/ShadowLight
@onready var inventory_ui = $Inventory_Ui

func _ready():
	Global.set_player_reference(self)

func _physics_process(delta):
	move_player(delta)

func move_player(delta):
	var direction = Input.get_vector("left","right","up","down")	
	
	update_sprite(direction)
	
	if direction:
		self.velocity = SPEED * direction * delta 
		if direction.y != 0:
			self.velocity *=  Vector2(1,0.5) 
		if Input.is_action_pressed("sprint"):
			self.velocity *= 2
	else:
		self.velocity = Vector2.ZERO
		
	move_and_slide()
	
func update_sprite(direction):
	if(direction.x > 0):
		if(direction.y > 0): 
			animation_player.play("down_right")
		elif(direction.y < 0): 
			animation_player.play("top_right")
		else: 
			animation_player.play("right")
			
	if(direction.x < 0):
		if(direction.y > 0): 
			animation_player.play("down_left")
		elif(direction.y < 0): 
			animation_player.play("top_left")
		else: 
			animation_player.play("left")
	
	if(direction.x == 0):
		if(direction.y > 0): 
			animation_player.play("down")
		if(direction.y < 0): 
			animation_player.play("top")

func _input(event):
	if event.is_action_pressed("inventory"):
		inventory_ui.visible = !inventory_ui.visible
		get_tree().paused = !get_tree().paused
