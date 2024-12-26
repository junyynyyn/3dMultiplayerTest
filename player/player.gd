extends CharacterBody3D

@export var SPEED = 5.0
@export var JUMP_VELOCITY = 4.5
@export var SENSITIVITY = 0.01

@export var max_health = 10
var health: int = max_health:
	set(value):
		health = value
		health_bar_ui.value = value

@export var damage = 2
@export var fire_rate = 2.0
@export var reload_speed = 1.0
@export var max_ammo = 10
var ammo: int = max_ammo:
	set(value):
		ammo = value
		ammo_ui.text = str(ammo) + "/" + str(max_ammo)

@onready var camera_holder: Node3D = $CameraHolder
@onready var player_camera: Camera3D = $CameraHolder/PlayerCamera
@onready var ray_cast_3d: RayCast3D = $CameraHolder/PlayerCamera/RayCast3D

@onready var fire_rate_timer: Timer = $FireRateTimer
@onready var reload_timer: Timer = $ReloadTimer

@onready var ammo_ui: Label = $UI/UIFrame/AmmoUI
@onready var health_bar_ui: ProgressBar = $UI/UIFrame/HealthBarUI

func _ready() -> void:
	# Confine Mouse to the Window
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Set 
	fire_rate_timer.wait_time = 1 / fire_rate
	reload_timer.wait_time = reload_speed
	
func _process(delta: float) -> void:
	if (fire_rate_timer.is_stopped() and reload_timer.is_stopped()):
		if (Input.is_action_just_pressed("fire")):
			fire()
			ammo -= 1
			fire_rate_timer.start()
			if (ammo <= 0):
				reload_timer.start()

func _physics_process(delta: float) -> void:
	# Basic Movement Code
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (camera_holder.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camera_holder.rotate_y(-event.relative.x * SENSITIVITY)
		player_camera.rotate_x(-event.relative.y * SENSITIVITY)
		player_camera.rotation.x = clamp(player_camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func fire() -> void:
	print(ray_cast_3d.get_collision_point())

func _on_reload_timer_timeout() -> void:
	ammo = max_ammo
