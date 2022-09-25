extends Node


onready var animation_player := $AnimationPlayer
onready var main_level_text := $main_level
onready var end_level_text := $end_level

var target
var key_target

func _ready() -> void:
	main_level_text.visible = false
	end_level_text.visible = false


func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("skip_dialog")):
		if(target and key_target):
			get_tree().change_scene(target)
			get(key_target + "_level_text").visible = false
			animation_player.play_backwards("dissolve")


func change_scene(scene: String, key_scene: String) -> void:
	animation_player.play("dissolve")
	get(key_scene + "_level_text").visible = true
	yield(animation_player, "animation_finished")
	target = scene
	key_target = key_scene
