extends Control
@export var drop_down_menu_res : OptionButton = null
var mouse_sens = preload("res://scripts/character_movement.gd")

func _ready():
	if drop_down_menu_res == null:
		print("Error: drop_down_menu_res is null!")
		return
	add_res()
	
func add_res():
	drop_down_menu_res.add_item("2560x1440")
	drop_down_menu_res.add_item("1920x1080")
	drop_down_menu_res.add_item("1600x900")
	drop_down_menu_res.add_item("1280x720")
	drop_down_menu_res.add_item("1280x960")
	print(drop_down_menu_res.item_count)

	

func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0,value)
	if value < -40:
		AudioServer.set_bus_mute(0,true)
	else: 
		AudioServer.set_bus_mute(0, false)


func _on_sensitivity_slider_value_changed(value: float) -> void:
	SettingsManager.mouse_sens = value
	
func back_to_main_menu():
	get_tree().change_scene_to_file("res://scenes/menu_ui/start_ui/main_menu.tscn")


func _on_option_button_item_selected(index):
	var current_selected = index

	if current_selected ==0:
		DisplayServer.window_set_size(Vector2(2560,1440))
		
	if current_selected ==1:
		DisplayServer.window_set_size(Vector2(1920,1080))
		
	if current_selected ==2:
		DisplayServer.window_set_size(Vector2(1600,900))
		
	if current_selected ==3:
		DisplayServer.window_set_size(Vector2(1280,720))
		
	if current_selected ==4:
		DisplayServer.window_set_size(Vector2(1280,960))
		
	
