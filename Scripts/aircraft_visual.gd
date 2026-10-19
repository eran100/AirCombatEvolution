extends Node3D
## Presentation only: bank around the local forward axis and spin the propeller.

@export_range(0.0, 70.0, 1.0) var banking_strength_degrees: float = 32.0
@export_range(0.1, 20.0, 0.1) var banking_response: float = 7.0
@export_range(0.0, 60.0, 0.5) var propeller_speed: float = 35.0

var _turn_fraction: float = 0.0

@onready var propeller: Node3D = $Propeller


func set_turn_fraction(value: float) -> void:
	_turn_fraction = clampf(value, -1.0, 1.0)


func _process(delta: float) -> void:
	var target_bank: float = _turn_fraction * deg_to_rad(banking_strength_degrees)
	rotation.z = lerp_angle(rotation.z, target_bank, 1.0 - exp(-banking_response * delta))
	propeller.rotation.z = wrapf(propeller.rotation.z + propeller_speed * delta, -PI, PI)
