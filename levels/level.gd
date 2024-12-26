extends Node3D

@export var player_scene: PackedScene
@export var spawn_points: Array[Marker3D]
var spawn_point_index = 0

@onready var player_container: Node3D = $"--- Player ---/PlayerContainer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not multiplayer.is_server():
		return
		
	# multiplayer.peer_connected.connect(add_player())
	
	multiplayer.peer_disconnected.connect(delete_player)
	
	for id in multiplayer.get_peers():
		add_player(id)
		
	add_player(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_player(id):
	var player_instance = player_scene.instantiate()
	player_instance.position = spawn_points[spawn_point_index].position
	spawn_point_index += 1
	if spawn_point_index >= len(spawn_points):
		spawn_point_index = 0
	player_instance.name = str(id)
	player_container.add_child(player_instance)

func delete_player(id):
	pass
	#if not players_container.has_node(str(id)):
		#return
	#
	#players_container.get_node(str(id)).queue_free()
