extends Node3D
## Follow position only. The child camera keeps a fixed angle and screen axes.

@export var target: Node3D
@export_range(0.1, 20.0, 0.1) var follow_response: float = 6.0


func _ready() -> void:
	if is_instance_valid(target):
		global_position = target.global_position


func _process(delta: float) -> void:
	if is_instance_valid(target):
		global_position = global_position.lerp(
			target.global_position, 1.0 - exp(-follow_response * delta)
		)
