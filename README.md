# Air Combat Evolution

Air Combat Evolution is an offline, single-player, low-poly 3D arcade air-combat game. It follows military aviation across seven historical eras, with each era remaining playable as development continues. The initial milestone prepares the Godot project; gameplay has not yet been implemented.

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

**Current milestone:** World War I — Project initialization.

## Open the project

1. Install Godot 4.7.2.
2. Open Godot and choose **Import** (or **Scan**), then select this folder's `project.godot` file.
3. Open the imported project in the editor. The project is in its initialization milestone and does not yet contain a playable scene.

The project settings are defined in `project.godot` and should be changed through the Godot editor when a future task calls for them.
