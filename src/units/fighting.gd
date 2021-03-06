extends TextureProgress

export var _fighting_range = 200
export var damage = 15
export var atk_freq = 0.5
export var max_health = 1000

onready var attack_timer = $AttackTimer
onready var kill_sound = $KillSound

var target = null
var in_range = false

signal lost_health
signal death
signal killed


func get_fighting_range():
	return _fighting_range


func fight(to_fight):
	if target == null:
		target = to_fight
		attack_timer.start(atk_freq)
	
	in_range = true
	
	
func lose_health(dmg):
	self.set_value(self.get_value() - dmg)
	
	if is_dead():
		emit_signal("death")
		print("RIP! %s is dead" % self)
	else:
		emit_signal("lost_health", dmg)


func is_dead():
	return self.get_value() <= 0


func _kill():
	kill_sound.play()
	_stop_fighting()
	emit_signal("killed")
	print ("%s killed %s!!" % [self, target])


func _stop_fighting():
	target = null
	attack_timer.stop()


func _attack():
	if target == null || not in_range:
		return
	
	var dmg = rand_range(damage / 2, damage)
	print ("%s attacks %s for %d dmg!" % [self, target, dmg])
	target.lose_health(dmg)
	if target.is_dead():
		_kill()


func _on_AttackTimer_timeout():
	_attack()


# TODO: fix lol!
func _on_Worker_target_out_of_reach():
	in_range = false
