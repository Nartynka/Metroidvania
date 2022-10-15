extends CanvasLayer

onready var progressBar = $ProgressBar

export(int) var MAX_HEALTH = 100

func _ready():
	progressBar.max_value = MAX_HEALTH
	progressBar.value = MAX_HEALTH
	
func update(damage):
	progressBar.value -= damage
