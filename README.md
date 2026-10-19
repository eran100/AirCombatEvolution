# Air Combat Evolution

Air Combat Evolution is an offline, single-player, low-poly 3D arcade air-combat game. It follows military aviation across seven historical eras, with each era remaining playable as development continues. The current prototype contains one controllable WWI biplane and a simple flight test environment.

## Technology stack

- **Engine:** Godot 4.7.2
- **Language:** GDScript
- **Renderer:** Mobile
- **Configured viewport:** 1280 × 800 (16:10)
- **3D physics engine:** Jolt Physics

## Target hardware

- **Development:** macOS on Apple Silicon
- **Target:** Lenovo Legion Go 2 running SteamOS
- **Performance target:** 60 FPS

## Gameplay vision

The game uses an angled top-down/isometric camera and prioritizes clear, responsive arcade controls. Fixed-wing aircraft turn automatically toward the direction indicated by the left stick and bank visually. Players do not control altitude continuously; a dedicated maneuver button performs loops or vertical 180-degree reversals.

Helicopters arrive in the Korean War era and use Cleared Hot-inspired controls, with movement independent from aiming. They begin as transports, then progress to armed utility and early attack roles in Vietnam. Later eras add more advanced systems gradually; the 2020s era introduces stealth and additional weapons.

## Historical era roadmap

1. World War I
2. World War II
3. Korean War
4. Vietnam War
5. Early 1980s
6. 2000s
7. 2020s

**Current milestone:** 4.1 — First playable flight prototype (complete; manual playtesting passed).

## Open the project

1. Install Godot 4.7.2.
2. Open Godot and choose **Import** (or **Scan**), then select this folder's `project.godot` file.
3. Open the imported project in the editor and press **F5** to run the configured main scene.
4. Press **F8** in the editor to stop the prototype.

Alternatively, launch from the project directory with Godot on your PATH:

```sh
godot --path .
```

## Flight controls

- **Gamepad:** Point the left stick toward the desired direction on the screen. A radial deadzone of 0.2 filters small stick movements.
- **Keyboard:** WASD or arrow keys steer in the same screen directions; combinations steer diagonally.
- The aircraft flies continuously at a constant speed and gradually turns toward the requested heading. Release the input to keep the current heading.
- Altitude is fixed. Banking and the spinning propeller are visual effects.

## Prototype structure and tuning

- `Scenes/FlightPrototype.tscn`: Main scene, daylight, fixed-angle tracking camera, and control instructions.
- `Scenes/PlayerAircraft.tscn`: Reusable biplane assembled from primitive meshes. Local forward is negative Z.
- `Scenes/TestEnvironment.tscn`: Flat terrain, fields, roads, trees, barns, and a visual grass airstrip.
- `Scripts/player_flight.gd`: Aircraft speed (28 units/s), turn speed (120 degrees/s), altitude (12 units), and camera-relative steering.
- `Scripts/aircraft_visual.gd`: Bank strength (32 degrees), bank response, and propeller animation.
- `Scripts/follow_camera.gd`: Position follow response. The child camera's orthographic size and angle are adjustable in the main scene.

Movement and presentation tuning values are exported in the Inspector. The configured viewport remains 1280 × 800 (16:10), using the existing Mobile renderer and Jolt configuration. The prototype uses no collision physics.

## Automated checks

Run from the project directory:

```sh
godot --version
godot --headless --editor --path . --quit
godot --headless --path . --fixed-fps 60 --quit-after 180
godot --headless --path . --script res://Tests/flight_prototype_check.gd
git diff --check
```

The focused script checks scene configuration, input mappings, steering, movement, cosmetic banking, and camera follow numerically. Headless checks do not verify flight feel, rendered appearance, real controller input, or target-device performance. See `PROJECT_STATUS.md` for actual results and the remaining manual tests.
