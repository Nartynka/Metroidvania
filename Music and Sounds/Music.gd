extends Node

export(Array, AudioStream) var queue = []

var queue_index = 0

onready var musicPlayer = $AudioStreamPlayer

func _ready():
	queue.shuffle()

func play_queue():
	assert(queue.size()>0)
	musicPlayer.stream = queue[queue_index]
	musicPlayer.play()
	queue_index += 1
	if queue_index == queue.size():
		queue_index = 0

func _on_AudioStreamPlayer_finished():
	play_queue()
