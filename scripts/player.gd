extends CharacterBody2D

@onready var main = get_tree().get_root().get_child(1)
const POTION_PROJECTILE = preload("res://scenes/potion_projectile.tscn")

const MAX_SPEED = 5000.0
var speed = MAX_SPEED

var STAMINA := 100.0:
	set(value):
		STAMINA = clamp(value, 0.0,100.0)
const DEFAULT_STAMINA_REGEN = 10.0
var stamina_regen := 10.0
var stamina_can_regen := true

var LIGHT := 100.0:
	set(value):
		LIGHT = clamp(value,0.0,100.0)
const DEFAULT_LIGHT_REGEN = 20.0
var light_regen := 20.0
var light_can_regen := false

var can_be_slowed = true
var can_be_stunned = true
var stunned = false

var full_stop = false

@onready var camera = $Camera
@onready var animation_player = $AnimationPlayer
@onready var light_player = $LightComponent
@onready var inventory_ui = $InventoryUI
@onready var general_ui = $GeneralUI
@onready var inventory_hotbar = $GeneralUI/InventoryHotbar
@onready var stamina_bar = $GeneralUI/StaminaBar
@onready var health_bar = $GeneralUI/HealthBar
@onready var light_bar = $GeneralUI/LightBar
@onready var stamina_timer = $StaminaTimer
@onready var light_timer = $LightTimer
@onready var hitbox_component = $HitboxComponent
@onready var health_component = $HealthComponent
@onready var reset_timer = $ResetTimer
@onready var died_screen = $Died
@onready var win_screen = $Win

func _ready():
	Global.set_player_reference(self)

func _physics_process(delta):
	if !stunned and !full_stop:
		if stamina_can_regen:
			STAMINA += stamina_regen * delta
		move_player(delta)
		stamina_bar.update_stamina_bar(STAMINA)

		if light_can_regen:
			LIGHT += light_regen * delta
		check_light(delta)
		light_bar.update_light_bar(LIGHT)
	
func _input(event):
	if !full_stop:
		if event.is_action_pressed("use_potion") and inventory_ui.visible == false and !stunned:
			if Global.get_potion():
				use_potion()
				Global.remove_potion(Global.active_slot+(Global.inventory_row*5))
				Global.fill_hotbar_row()
						
		if event.is_action_pressed("inventory"):
			if Global.crafting:
				Global.crafting = false
			else:
				inventory_hotbar.visible = !inventory_hotbar.visible
				general_ui.visible = !general_ui.visible
				inventory_ui.visible = !inventory_ui.visible 
				if !inventory_ui.visible:
					Global.crafting = false
				
				Global.potion_to_swap = null
				Global.fill_hotbar_row()
				Global.inventory_updated.emit()
			
		if event.is_action_pressed("craft_potion"):
			if !Global.crafting:
				Global.crafting = true
				inventory_hotbar.visible = !inventory_hotbar.visible
				inventory_ui.visible = !inventory_ui.visible 
				general_ui.visible = !general_ui.visible
				Global.craft_index = Global.active_slot+(Global.inventory_row*5)
				Global.inventory_updated.emit()
			else:
				Global.crafting = false
				inventory_hotbar.visible = !inventory_hotbar.visible
				general_ui.visible = !general_ui.visible
				inventory_ui.visible = !inventory_ui.visible 
				Global.potion_to_swap = null
				Global.fill_hotbar_row()
				Global.inventory_updated.emit()
			
		if event.is_action_pressed("change_hotbar"):
			Global.change_inventory_row()
			
		if event.is_action_pressed("slot1"): 
			Global.active_slot = 0
			Global.inventory_updated.emit()
			
		if event.is_action_pressed("slot2"): 
			Global.active_slot = 1
			Global.inventory_updated.emit()
			
		if event.is_action_pressed("slot3"):
			Global.active_slot = 2
			Global.inventory_updated.emit()
			
		if event.is_action_pressed("slot4"):
			Global.active_slot = 3
			Global.inventory_updated.emit()
			
		if event.is_action_pressed("slot5"): 
			Global.active_slot = 4
			Global.inventory_updated.emit()
			
		if event.is_action_pressed("scrow_right"):
			Global.active_slot -= 1
			if Global.active_slot < 0: Global.active_slot = 4
			Global.inventory_updated.emit()
			
		if event.is_action_pressed("scrow_left"): 
			Global.active_slot += 1
			if Global.active_slot > 4: Global.active_slot = 0
			Global.inventory_updated.emit()
	
func move_player(delta):
	if !stunned:
		var direction = Input.get_vector("left","right","up","down")	
		if direction:
			self.velocity = speed * direction * delta 
			if direction.y != 0:
				self.velocity *=  Vector2(1,0.5) 
			if Input.is_action_pressed("sprint") and STAMINA > 0.0:
				self.velocity *= 2
				STAMINA -= 25.0 * delta
				stamina_can_regen = false
				stamina_timer.start()
			self.velocity = self.velocity / (1.0 + (float(Global.item_amount)/15))
		else:
			self.velocity = Vector2.ZERO
		update_sprite(direction)
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

func check_light(delta):
	if Input.is_action_pressed("toggle_light") and LIGHT > 0.0:
		Global.player_light = true #Maybe useless
		light_player.update_light(true)
		light_timer.start()
		LIGHT -= 25.0 * delta
		light_can_regen = false
	else:
		Global.player_light = false
		light_player.update_light(false)

func use_potion():
	var potion = Global.get_potion()
	var new_attack = Attack.new()
	
	new_attack.effect_potency = potion.potion_potency
	
	match potion.potion_type:
		4: 
			new_attack.attack_effect = "burn"
			new_attack.attack_damage = 0
		5: 
			new_attack.attack_effect = "slow"
			new_attack.attack_damage = 1 + new_attack.effect_potency
		6: 
			new_attack.attack_effect = "stun"
			new_attack.attack_damage = 5 + new_attack.effect_potency
			new_attack.knockback_damage = 5
		7: 
			new_attack.attack_effect = "poison"
			new_attack.attack_damage = 0
		8: 
			new_attack.attack_effect = "light"
			new_attack.attack_damage = 0
		9: 
			new_attack.attack_effect = "shield"
			new_attack.attack_damage = 0
		10: 
			new_attack.attack_effect = "haste"
			new_attack.attack_damage = 0
		11: 
			new_attack.attack_effect = "heal"
			new_attack.attack_damage = 0
				
	if potion.potion_target== 0:
		hitbox_component.damage(new_attack)
	else:
		if potion.potion_target == 1:	
			new_attack.attack_type = "single"
		else: 
			new_attack.attack_type = "aoe"
		#3: new_attack.attack_type = "lingering" Not enough time ;-;
		throw_potion(potion, new_attack)
	
func throw_potion(potion : Potion, new_attack : Attack):
	var potion_instance = POTION_PROJECTILE.instantiate()
	potion_instance.new_attack = new_attack
	potion_instance.sprite_frame = potion.potion_sprite
	potion_instance.sprite_shader = potion.potion_color 
	potion_instance.position = global_position - Vector2(0,-16)
	potion_instance.direction = global_position.direction_to(get_global_mouse_position())
	main.add_child.call_deferred(potion_instance)
	
func win():
	full_stop = true
	win_screen.visible = true
	if reset_timer.time_left == 0:
		reset_timer.start()

func lose():
	full_stop = true
	died_screen.visible = true
	if reset_timer.time_left == 0:
		reset_timer.start()

func _on_light_timer_timeout():
	light_can_regen = true
	pass
	
func _on_stamina_timer_timeout():
	stamina_can_regen = true

func _on_reset_timer_timeout():
	get_tree().reload_current_scene()
