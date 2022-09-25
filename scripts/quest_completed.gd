extends Node

onready var quest_completed_text := $"."
onready var portal := $"../Portal/Portal"
onready var broken_portal := $"../Portal/PortalBroken"

var show_text = false
var completed = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	quest_completed_text.visible = false
	portal.visible = false
	portal.disable_portal_entry = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(get_tree().get_nodes_in_group("collectibles").size() == 0):
		if(completed == false):
			show_portal_open()

		completed = true

	quest_completed_text.visible = show_text


func show_portal_open() -> void:
	broken_portal.visible = false
	portal.visible = true
	portal.disable_portal_entry = false
	show_text = true
	yield(get_tree().create_timer(5), "timeout")
	show_text = false
