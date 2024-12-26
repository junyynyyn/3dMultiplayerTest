extends Node

@onready var main_menu_container: HBoxContainer = $"--- Menu ---/StartMenu/MainMenuContainer"
@onready var host_container: HBoxContainer = $"--- Menu ---/StartMenu/HostContainer"
@onready var status: Label = $"--- Menu ---/StartMenu/Status"
@onready var ip_input: LineEdit = $"--- Menu ---/StartMenu/MainMenuContainer/IPInput"
@onready var level_container: Node = $"--- Level ---"
@onready var start_menu: Control = $"--- Menu ---/StartMenu"


@export var level_scene: PackedScene

func _ready() -> void:
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.connected_to_server.connect(_on_connected_to_server)

func _on_host_button_pressed() -> void:
	host_container.show()
	main_menu_container.hide()
	status.text = "Hosting Game:"
	Lobby.create_game()

func _on_join_button_pressed() -> void:
	Lobby.join_game(ip_input.text)
	status.text = "Connecting..."

func _on_start_button_pressed() -> void:
	hide_menu.rpc()
	start_game.call_deferred()

func _on_connection_failed():
	status.text = "Failed to Connect"
	
func _on_connected_to_server():
	main_menu_container.hide()
	status.text = "Connected to " + ip_input.text

func start_game():
	for c in level_container.get_children():
		level_container.remove_child(c)
		#c.level_complete.disconnect(_on_level_complete)
		c.queue_free()
	
	var new_level = level_scene.instantiate()
	level_container.add_child(new_level)
	#new_level.level_complete.connect(_on_level_complete)
	
@rpc("call_local", "authority", "reliable")
func hide_menu():
	start_menu.hide()
