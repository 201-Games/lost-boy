extends Node

onready var audio = $"."
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

func _process(delta: float) -> void:
	if(audio.playing == false):
		audio.play()
