extends GPUParticles3D

func _ready() -> void:
	emitting = true

func _on_timer_timeout() -> void:
	queue_free()
