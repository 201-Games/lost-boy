extends KinematicBody2D

onready var animated_sprite := $AnimatedSprite
onready var diaglog_box := $DialogBox/Label

signal on_pickup_collectible(type)

const SPEED := 75
const DIRECTION_TO_FRAME := {
	Vector2.DOWN: 0,
	Vector2.RIGHT: 2,
	Vector2.UP: 4,
}

var velocity := Vector2.ZERO
var direction := Vector2.RIGHT

var can_pickup := false
var current_item_in_area = []


func _ready() -> void:
	diaglog_box.visible = false
	animated_sprite.flip_h = false if direction.x == 1 else true

func _process(delta: float) -> void:
	if(can_pickup and Input.is_action_just_pressed("doing")):
		pickup_collectible()


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

func pickup_collectible() -> void:
	for item in current_item_in_area:
		if(item.is_in_group("mushroom_orange")):
			emit_signal("on_pickup_collectible", "mushroom_orange")
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
		current_item_in_area.append(body)
		show_dialog_box("Press F to collect")



func _on_CollectArea_body_exited(body: Node) -> void:
	if(body.is_in_group("collectibles")):
		can_pickup = false
		var item_index = current_item_in_area.find(body)
		current_item_in_area.remove(item_index)

	if(current_item_in_area.size() == 0):
		hide_dialog_box()


