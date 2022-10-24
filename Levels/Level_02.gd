extends "res://Levels/Level.gd"

onready var boss = $BossEnemy
onready var doorBlock = $EnterDoorBlock
onready var doorBlock2 = $ExitDoorBlock

func _ready():
	boss.visible = false
	boss.set_process(false)

func _on_Trigger_area_triggered():
	if is_instance_valid(boss):
		SoundFx.play("Step", 10)
		SoundFx.play("Step", 10)
		block_door(true)
		boss.set_process(true)
		boss.visible = true

func _on_BossEnemy_boss_died():
	SoundFx.play("Step", 10)
	SoundFx.play("Step", 10)
	SoundFx.play("Powerup", 10, 0.3)
	block_door(false)

func block_door(value):
	doorBlock.visible = value
	doorBlock2.visible = value
	doorBlock.set_collision_mask_bit(0, value)
	doorBlock2.set_collision_mask_bit(0, value)
