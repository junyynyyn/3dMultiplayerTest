extends Node

@onready var main_menu_container: HBoxContainer = $"--- Menu ---/StartMenu/MainMenuContainer"
@onready var host_container: HBoxContainer = $"--- Menu ---/StartMenu/HostContainer"
@onready var status: Label = $"--- Menu ---/StartMenu/Status"
@onready var ip_input: LineEdit = $"--- Menu ---/StartMenu/MainMenuContainer/IPInput"

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
	pass # Replace with function body.

func _on_connection_failed():
	status.text = "Failed to Connect"
	
func _on_connected_to_server():
	main_menu_container.hide()
	status.text = "Connected to " + ip_input.text
