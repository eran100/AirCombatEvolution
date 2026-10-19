extends Node3D
## Flat arcade movement. The visual child never changes the flight heading or altitude.

@export_range(1.0, 100.0, 0.5) var flight_speed: float = 28.0
@export_range(1.0, 360.0, 1.0) var turn_speed_degrees: float = 120.0
@export var gameplay_altitude: float = 12.0
@export var steering_camera: Camera3D

@onready var aircraft_visual: Node3D = $AircraftVisual


func _ready() -> void:
	position.y = gameplay_altitude


func _physics_process(delta: float) -> void:
	var steering: Vector2 = Input.get_vector(
		"steer_left", "steer_right", "steer_up", "steer_down"
	)
	var heading_change: float = 0.0
	var maximum_turn: float = deg_to_rad(turn_speed_degrees) * delta
	if not steering.is_zero_approx():
		var desired_direction: Vector3 = _screen_to_world_direction(steering)
		var desired_heading: float = atan2(-desired_direction.x, -desired_direction.z)
		var heading_error: float = wrapf(desired_heading - rotation.y, -PI, PI)
		heading_change = clampf(heading_error, -maximum_turn, maximum_turn)
		rotation.y += heading_change

	var forward: Vector3 = Vector3.FORWARD.rotated(Vector3.UP, rotation.y)
	position += forward * flight_speed * delta
	position.y = gameplay_altitude
	# Signed actual turning drives presentation, including return to level flight.
	var turn_fraction: float = heading_change / maximum_turn if maximum_turn > 0.0 else 0.0
	aircraft_visual.set_turn_fraction(turn_fraction)


func _screen_to_world_direction(steering: Vector2) -> Vector3:
	var screen_right: Vector3 = Vector3.RIGHT
	var screen_up: Vector3 = Vector3.FORWARD
	if is_instance_valid(steering_camera):
		screen_right = steering_camera.global_basis.x
		screen_up = steering_camera.global_basis.y
		screen_right.y = 0.0
		screen_up.y = 0.0
		screen_right = screen_right.normalized()
		screen_up = screen_up.normalized()
	return (screen_right * steering.x - screen_up * steering.y).normalized()
