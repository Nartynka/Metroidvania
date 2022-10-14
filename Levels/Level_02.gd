extends "res://Levels/Level.gd"

onready var doorBlock = $EnterDoorBlock
onready var doorBlock2 = $ExitDoorBlock


func _on_Trigger_area_triggered():
	block_door(true)

func _on_BossEnemy_boss_died():
	block_door(false)

func block_door(value):
	doorBlock.visible = value
	doorBlock2.visible = value
	doorBlock.set_collision_mask_bit(0, value)
	doorBlock2.set_collision_mask_bit(0, value)
