extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	self.visible = false


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu_ui/settings_ui/settings.tscn")


func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu_ui/start_ui/main_menu.tscn")
