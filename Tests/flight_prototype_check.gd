extends SceneTree
## Focused headless checks. These cannot assess rendering, hardware input, or flight feel.

const MAIN_SCENE: String = "res://Scenes/FlightPrototype.tscn"
const ACTIONS: Array[StringName] = [&"steer_left", &"steer_right", &"steer_up", &"steer_down"]

var _failures: int = 0
var _checks: int = 0


func _initialize() -> void:
	_run.call_deferred()


func _run() -> void:
	_check(ProjectSettings.get_setting("application/run/main_scene") == MAIN_SCENE, "main scene configured")
	_check(ProjectSettings.get_setting("display/window/size/viewport_width") == 1280, "viewport width")
	_check(ProjectSettings.get_setting("display/window/size/viewport_height") == 800, "16:10 viewport height")
	_check(_has_key(&"steer_left", KEY_A) and _has_key(&"steer_left", KEY_LEFT), "A / Left mappings")
	_check(_has_key(&"steer_right", KEY_D) and _has_key(&"steer_right", KEY_RIGHT), "D / Right mappings")
	_check(_has_key(&"steer_up", KEY_W) and _has_key(&"steer_up", KEY_UP), "W / Up mappings")
	_check(_has_key(&"steer_down", KEY_S) and _has_key(&"steer_down", KEY_DOWN), "S / Down mappings")
	for action: StringName in ACTIONS:
		_check(is_equal_approx(InputMap.action_get_deadzone(action), 0.2), "%s deadzone" % action)
	_check(_has_axis(&"steer_left", JOY_AXIS_LEFT_X, -1.0), "left stick left")
	_check(_has_axis(&"steer_right", JOY_AXIS_LEFT_X, 1.0), "left stick right")
	_check(_has_axis(&"steer_up", JOY_AXIS_LEFT_Y, -1.0), "left stick up")
	_check(_has_axis(&"steer_down", JOY_AXIS_LEFT_Y, 1.0), "left stick down")

	var packed: PackedScene = load(MAIN_SCENE) as PackedScene
	_check(packed != null, "main scene loads")
	if packed == null:
		quit(1)
		return
	var scene: Node3D = packed.instantiate() as Node3D
	root.add_child(scene)
	var player = scene.get_node("PlayerAircraft")
	var visual = player.get_node("AircraftVisual")
	var rig = scene.get_node("FollowCamera")
	var camera: Camera3D = rig.get_node("Camera3D")
	player.set_physics_process(false)
	visual.set_process(false)
	rig.set_process(false)
	_check(player.steering_camera == camera and rig.target == player, "camera references resolve")
	_check(camera.current and camera.projection == Camera3D.PROJECTION_ORTHOGONAL, "active orthographic camera")
	_release_actions()
	Input.action_press(&"steer_right", 0.1)
	_check(_steering().is_zero_approx(), "small input ignored by radial deadzone")
	_release_actions()

	# Exercise all cardinal and diagonal directions through the actual flight update.
	var directions: Array[Vector2] = [
		Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT,
		Vector2(-1, -1), Vector2(1, -1), Vector2(-1, 1), Vector2(1, 1)
	]
	for direction: Vector2 in directions:
		_release_actions()
		player.position = Vector3(0, player.gameplay_altitude, 0)
		player.rotation = Vector3.ZERO
		_press_direction(direction)
		_check(_steering().length() <= 1.00001, "bounded input %s" % direction)
		var before: Vector3 = player.position
		player._physics_process(1.0 / 60.0)
		_check(absf(player.rotation.y) <= deg_to_rad(player.turn_speed_degrees) / 60.0 + 0.00001, "limited turn %s" % direction)
		_check(is_equal_approx(player.position.distance_to(before), player.flight_speed / 60.0), "constant speed %s" % direction)
		for frame in range(120):
			player._physics_process(1.0 / 60.0)
		var expected: Vector3 = Vector3(direction.x, 0, direction.y).normalized()
		var forward: Vector3 = Vector3.FORWARD.rotated(Vector3.UP, player.rotation.y)
		_check(forward.dot(expected) > 0.9999, "screen direction reached %s" % direction)
		_check(is_equal_approx(player.position.y, player.gameplay_altitude), "fixed altitude %s" % direction)
		var heading: float = player.rotation.y
		_release_actions()
		player._physics_process(0.5)
		_check(is_equal_approx(player.rotation.y, heading), "release holds heading %s" % direction)

	# Equal elapsed time at several tick rates gives equal straight-line travel and heading.
	for tick_rate: int in [30, 60, 120]:
		player.position = Vector3(0, player.gameplay_altitude, 0)
		player.rotation = Vector3.ZERO
		for frame in range(tick_rate):
			player._physics_process(1.0 / tick_rate)
		_check(absf(player.position.z + player.flight_speed) < 0.002, "one-second travel at %s Hz" % tick_rate)
		Input.action_press(&"steer_right")
		for frame in range(tick_rate):
			player._physics_process(1.0 / tick_rate)
		_check(absf(player.rotation.y + PI / 2.0) < 0.0001, "same heading at %s Hz" % tick_rate)
		_release_actions()

	# Banking is cosmetic, signed, smoothed, and returns to neutral.
	player.rotation = Vector3.ZERO
	Input.action_press(&"steer_right")
	player._physics_process(1.0 / 60.0)
	visual.rotation.z = 0.0
	visual._process(1.0 / 60.0)
	_check(visual.rotation.z < 0.0 and absf(visual.rotation.z) < deg_to_rad(visual.banking_strength_degrees), "smooth right bank")
	player.rotation = Vector3.ZERO
	_release_actions()
	Input.action_press(&"steer_left")
	player._physics_process(1.0 / 60.0)
	visual.rotation.z = 0.0
	visual._process(1.0 / 60.0)
	_check(visual.rotation.z > 0.0, "left bank")
	_check(is_zero_approx(player.rotation.x) and is_zero_approx(player.rotation.z), "bank does not rotate gameplay root")
	_check(is_equal_approx(player.position.y, player.gameplay_altitude), "bank does not change gameplay altitude")
	_release_actions()
	player._physics_process(1.0 / 60.0)
	for frame in range(120):
		visual._process(1.0 / 60.0)
	_check(absf(visual.rotation.z) < 0.0001, "bank returns to neutral")

	var view_basis: Basis = camera.global_basis
	rig.global_position = player.global_position - Vector3(20, 0, 10)
	var old_distance: float = rig.global_position.distance_to(player.global_position)
	rig._process(1.0 / 60.0)
	var new_distance: float = rig.global_position.distance_to(player.global_position)
	_check(new_distance < old_distance and new_distance > 0.0, "camera follows without snapping")
	player.rotation.y += 1.0
	for frame in range(120):
		rig._process(1.0 / 60.0)
	_check(camera.global_basis.is_equal_approx(view_basis), "camera angle independent of aircraft heading")
	_check(rig.global_position.distance_to(player.global_position) < 0.001, "camera converges on aircraft")

	print("Flight prototype: %d checks, %d failures. Visual and hardware tests remain manual." % [_checks, _failures])
	scene.free()
	quit(1 if _failures > 0 else 0)


func _check(condition: bool, description: String) -> void:
	_checks += 1
	if not condition:
		_failures += 1
		push_error("FAIL: " + description)


func _has_key(action: StringName, key: Key) -> bool:
	for event: InputEvent in InputMap.action_get_events(action):
		if event is InputEventKey and event.physical_keycode == key:
			return true
	return false


func _has_axis(action: StringName, axis: JoyAxis, value: float) -> bool:
	for event: InputEvent in InputMap.action_get_events(action):
		if event is InputEventJoypadMotion and event.axis == axis and is_equal_approx(event.axis_value, value):
			return true
	return false


func _steering() -> Vector2:
	return Input.get_vector("steer_left", "steer_right", "steer_up", "steer_down")


func _release_actions() -> void:
	for action: StringName in ACTIONS:
		Input.action_release(action)


func _press_direction(direction: Vector2) -> void:
	if direction.x < 0.0:
		Input.action_press(&"steer_left")
	elif direction.x > 0.0:
		Input.action_press(&"steer_right")
	if direction.y < 0.0:
		Input.action_press(&"steer_up")
	elif direction.y > 0.0:
		Input.action_press(&"steer_down")
