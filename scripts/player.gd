extends KinematicBody2D

signal on_pickup_collectible(type)
signal on_change_scene(scene, key_scene)

export(String, "start", "main", "end") var teleport_to

onready var animated_sprite := $AnimatedSprite
onready var diaglog_box := $DialogBox/Label

const SPEED := 75
const DIRECTION_TO_FRAME := {
	Vector2.DOWN: 0,
	Vector2.RIGHT: 2,
	Vector2.UP: 4,
}
const SCENES := {
	"start": "res://scenes/Start.tscn",
	"main": "res://scenes/Main.tscn",
	"end": "res://scenes/End.tscn"
}

var velocity := Vector2.ZERO
var direction := Vector2.RIGHT

var can_teleport := false
var is_doing_teleport := false
var can_pickup := false
var current_items_in_area = []

func _ready() -> void:
	diaglog_box.visible = false
	animated_sprite.flip_h = false if direction.x == 1 else true

func _process(delta: float) -> void:
	if(can_pickup and Input.is_action_just_pressed("doing")):
		pickup_collectible_item()

	if(can_teleport and not is_doing_teleport and Input.is_action_just_pressed("doing")):
		teleport()


func _physics_process(delta: float) -> void:
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = move_and_slide(direction * SPEED)

	if(velocity.x != 0 or velocity.y != 0):
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")

	set_sprite_direction()


func set_sprite_direction() -> void:
	var direction_key := direction.round()

	direction_key.x = abs(direction_key.x)
	if direction_key in DIRECTION_TO_FRAME:
		animated_sprite.flip_h = sign(direction.x) == -1


func teleport() -> void:
	SceneTransition.change_scene(SCENES[teleport_to], teleport_to)
	is_doing_teleport = true


func pickup_collectible_item() -> void:
	for item in current_items_in_area:
		var collectible_type

		if(item.is_in_group("mushroom_orange")):
			collectible_type = "mushroom_orange"
		elif(item.is_in_group("mushroom_brown")):
			collectible_type = "mushroom_brown"
		elif(item.is_in_group("stone_yellow")):
			collectible_type = "stone_yellow"
		elif(item.is_in_group("stone_red")):
			collectible_type = "stone_red"

		emit_signal("on_pickup_collectible", collectible_type)
		item.queue_free()


func show_dialog_box(text: String) -> void:
	diaglog_box.text = text
	diaglog_box.visible = true


func hide_dialog_box() -> void:
	diaglog_box.text = ""
	diaglog_box.visible = false


func _on_CollectArea_body_entered(body: Node) -> void:
	if(body.is_in_group("collectibles")):
		can_pickup = true
		current_items_in_area.append(body)
		show_dialog_box("Press F to collect")


func _on_CollectArea_body_exited(body: Node) -> void:
	if(body.is_in_group("collectibles")):
		var item_index = current_items_in_area.find(body)
		current_items_in_area.remove(item_index)

		if(current_items_in_area.size() == 0):
			can_pickup = false
			hide_dialog_box()


func _on_TeleportArea_area_entered(area: Area2D) -> void:
	if(area.is_in_group("portal_area")):
		can_teleport = true


func _on_TeleportArea_area_exited(area: Area2D) -> void:
	if(area.is_in_group("portal_area")):
		can_teleport = false
