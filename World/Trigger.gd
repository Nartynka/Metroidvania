extends Area2D

signal area_triggered
var enable = true

func _on_Trigger_body_entered(body):
	if body is Player && enable:
		emit_signal("area_triggered")
		enable = false
