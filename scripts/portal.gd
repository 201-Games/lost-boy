extends StaticBody2D

func _on_PortalEntry_body_entered(body: Node) -> void:
	if body.name == "Player" and body.has_method("show_dialog_box"):
		body.show_dialog_box("Press F to enter")


func _on_PortalEntry_body_exited(body: Node) -> void:
	if body.name == "Player" and body.has_method("hide_dialog_box"):
		body.hide_dialog_box()
