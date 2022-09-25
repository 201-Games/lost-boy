extends StaticBody2D

onready var portal_entry = $PortalEntry/CollisionShape2D

export var disable_portal_entry = true

func _ready() -> void:
	portal_entry.disabled = disable_portal_entry

func _process(delta: float) -> void:
	portal_entry.disabled = disable_portal_entry

func _on_PortalEntry_body_entered(body: Node) -> void:
	if body.name == "Player" and body.has_method("show_dialog_box"):
		body.show_dialog_box("Press F to enter")


func _on_PortalEntry_body_exited(body: Node) -> void:
	if body.name == "Player" and body.has_method("hide_dialog_box"):
		body.hide_dialog_box()
