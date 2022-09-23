extends KinematicBody2D

onready var animated_sprite := $AnimatedSprite
onready var diaglog_box := $DialogBox/Label

const SPEED := 75
const DIRECTION_TO_FRAME := {
	Vector2.DOWN: 0,
	Vector2.RIGHT: 2,
	Vector2.UP: 4,
}

var velocity := Vector2.ZERO
var direction := Vector2.RIGHT


func _ready() -> void:
	diaglog_box.visible = false
	animated_sprite.flip_h = false if direction.x == 1 else true


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

func show_dialog_box(text: String) -> void:
	diaglog_box.text = text
	diaglog_box.visible = true

func hide_dialog_box() -> void:
	diaglog_box.text = ""
	diaglog_box.visible = false



