extends Node2D
class_name EffectComponent

const STATUS_SPRITE = preload("res://scenes/status_sprite.tscn")

@export var health : HealthComponent

@onready var poisoned_timer = $PoisonedTimer
@onready var poison_damage_timer = $PoisonedTimer/PoisonDamageTimer
@onready var burning_timer = $BurningTimer
@onready var burn_damage_timer = $BurningTimer/BurnDamageTimer
@onready var slowed_timer = $SlowedTimer
@onready var stunned_timer = $StunnedTimer
@onready var shielded_timer = $ShieldedTimer
@onready var haste_timer = $HasteTimer
@onready var light_timer = $LightTimer

func apply_status(damage,status, potency):
	match status:
		"poison": poisoned(potency)
		"burn": burning(potency)
		"slow": slowed(damage, potency)
		"stun": stunned(damage, potency)
		"heal": healed(potency)
		"shield": shielded(potency)
		"haste": haste(potency)
		"light": light(potency)
		"enemy": dark(damage)

func play_effect(damage, color, time, type):
	var new_sprite = STATUS_SPRITE.instantiate()
	print(position)
	new_sprite.type = type
	if color: 
		new_sprite.color = color
	if damage: 
		new_sprite.damage = damage
	if time: 
		new_sprite.time = time
	add_child(new_sprite)
	
func poisoned(potency):
	poisoned_timer.set_wait_time(5*potency)
	poisoned_timer.start()
	if poison_damage_timer.time_left == 0:
		poison_damage_timer.set_wait_time(1.5)
		poison_damage_timer.start()
	play_effect(null,null,null,"poison")
		
func burning(potency):
	burning_timer.set_wait_time(5)
	burning_timer.start()
	if !burn_damage_timer.is_connected("timeout",_on_burn_damage_timer):
		burn_damage_timer.timeout.connect(_on_burn_damage_timer.bind(potency))
	if burn_damage_timer.time_left == 0:
		burn_damage_timer.set_wait_time(1)
		burn_damage_timer.start()
	play_effect(null,null,null,"burn")
	
func slowed(damage, potency):
	print(potency)
	if get_parent().can_be_slowed:
		get_parent().slow = 1.5*potency
		slowed_timer.set_wait_time(5)
		slowed_timer.start()
		play_effect(damage,Color.html("#8fd3ff"),5,"slow")
		
func stunned(damage, potency):
	if get_parent().can_be_stunned:
		get_parent().stunned = true
		stunned_timer.set_wait_time(0.5*potency)
		stunned_timer.start()
		play_effect(damage,Color.html("#fbff86"),0.5*potency,"stun")
	
func healed(potency):
	health.health += 2*potency
	if health.health > health.MAX_HEALTH :
		health.health = health.MAX_HEALTH
	health.update_health_bar()
	play_effect(2*potency,Color.html("#e83b3b"),null,"heal")

func shielded(potency):
	health.shield += 1*potency
	if health.shield > health.MAX_SHIELD :
		health.shield = health.MAX_SHIELD
	health.update_health_bar()
	shielded_timer.set_wait_time(15)
	shielded_timer.start()
	play_effect(1*potency,Color.html("#c7dcd0"),15,"shield")

func haste(potency):
	get_parent().SPEED += 500*potency
	if get_parent() == Global.player_node:
		get_parent().STAMINA += 10 * potency
		get_parent().stamina_regen += 10 * potency
		play_effect(10*potency,Color.html("#1ebc73"),30/potency,"haste")
	else:
		play_effect(null,Color.html("#1ebc73"),30/potency,"haste")
	haste_timer.set_wait_time(30/potency)
	haste_timer.start()
	
func light(potency):
	if get_parent() == Global.player_node:
		get_parent().LIGHT += 20 * potency
		get_parent().light_regen += 10
		light_timer.set_wait_time(30/potency)
		light_timer.start()
		play_effect(20*potency,Color.html("#ffffff"),30/potency,"light")
	else: 
		var new_attack = Attack.new()
		new_attack.attack_damage = 10*potency
		new_attack.knockback_damage = 5*potency
		health.damage(new_attack)
		play_effect(new_attack.attack_damage,Color.html("#ffffff"),null,null)

func dark(damage):
	play_effect(damage, Color.html("#2e222f"), null, null)

func _on_poison_damage_timer_timeout():
	if poisoned_timer.time_left > 0:
		var new_attack = Attack.new()
		new_attack.attack_damage = 1
		health.damage(new_attack)
		play_effect(new_attack.attack_damage,Color.html("#239063"),null,"poison")
	else:
		poison_damage_timer.stop()

func _on_burn_damage_timer(potency):
	if burning_timer.time_left > 0:
		var new_attack = Attack.new()
		new_attack.attack_damage = potency
		health.damage(new_attack)
		play_effect(new_attack.attack_damage,Color.html("#fb6b1d"),null,"burn")
	else:
		burn_damage_timer.stop()
	
func _on_burn_damage_timer_timeout():
	pass # Replace with function body.

func _on_slowed_timer_timeout():
	get_parent().slow = 0.0

func _on_stunned_timer_timeout():
	get_parent().stunned = false

func _on_shielded_timer_timeout():
	health.shield = 0
	health.update_health_bar()

func _on_haste_timer_timeout():
	get_parent().SPEED = get_parent().MAX_SPEED
	if get_parent().has_method("move_player"):
		get_parent().stamina_regen = get_parent().DEFAULT_STAMINA_REGEN

func _on_light_timer_timeout():
	get_parent().light_regen = get_parent().DEFAULT_LIGHT_REGEN
