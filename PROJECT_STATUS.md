# Project status

## Current milestone

- **Era:** World War I
- **Milestone:** 4.1 — First playable flight prototype
- **Status:** Complete. Manual playtesting passed, as confirmed by the user.

## Implemented features

- Reusable primitive-mesh WWI biplane with separate fuselage, upper/lower wings, tail, and animated propeller; simple canvas, red, and dark materials.
- Continuous forward flight at a fixed altitude with configurable speed and gradual, configurable turning.
- Screen-relative left-stick, WASD, and arrow-key steering, including diagonals and a 0.2 radial deadzone. Releasing input preserves the current heading.
- Smooth visual banking based on actual turning, with configurable strength and response; banking returns to neutral and does not affect gameplay heading or altitude.
- Smooth position-tracking orthographic camera with a consistent angled top-down view, independent of aircraft turns.
- Flat 8,000 × 8,000 terrain with fields, crossing roads, primitive trees and barns, and a visual grass airstrip for movement references.
- Basic daylight, shadows, and minimal control instructions.
- Main scene configured as `res://Scenes/FlightPrototype.tscn`. Existing Mobile renderer, Jolt setting, and 1280 × 800 (16:10) viewport preserved.
- Focused reproducible headless checks in `Tests/flight_prototype_check.gd`.
- No external assets, plugins, combat, missions, AI, or manual altitude controls added.

## Manual playtesting results

The user confirmed milestone 4.1 passed manual playtesting:

- Keyboard steering works correctly.
- Gamepad left-stick steering feels good.
- The aircraft turns and banks smoothly.
- The aircraft returns to level flight.
- Camera tracking works.
- Automatic forward movement works.

The accepted flight behavior is preserved. Visual issues below are documented for future work.

## Known visual issues

- Aircraft edges appear slightly pixelated.
- Aircraft shadows are too dark and harsh.
- The aircraft may be too small on screen.

## Known limitations

- Performance on the Lenovo Legion Go 2 / SteamOS and the 60 FPS target are unverified.
- Terrain is finite, with most landmarks near the starting area. There are no boundaries, wrapping, or recentering; sustained straight flight can leave the scenery and eventually the ground surface.
- Scenery is visual only. There is no collision, landing, or terrain interaction in this milestone.
- Exactly opposite steering chooses a consistent turn side because both turn directions are equally short.

## Validation results

Commands rerun for milestone completion from the project directory using Godot 4.7.2:

- `godot --version` — exit 0; reported `4.7.2.stable.official.ed1daf0bf`.
- `godot --headless --editor --path . --quit` — exit 0 with no errors, including no GDScript parse or missing-resource errors.
- `godot --headless --path . --fixed-fps 60 --quit-after 180` — exit 0 with no errors; configured main scene ran for 180 simulated frames (3 seconds). This exercises startup and regular update callbacks, not rendered visuals or frame-rate performance.
- `godot --headless --path . --script res://Tests/flight_prototype_check.gd` — exit 0; **81 checks, 0 failures**. Checks cover the main scene and camera references, 16:10 viewport, keyboard/stick mappings, deadzone, eight steering directions, bounded turn steps, constant movement speed, heading hold, fixed altitude, travel and heading at 30/60/120 Hz, cosmetic bank sign/smoothing/leveling, and fixed-angle camera follow.
- `git diff --check` — exit 0; no whitespace errors.

Headless validation does not establish flight feel, visual behavior, actual keyboard/controller event delivery, or hardware performance.

Godot validation ran with permission to write its normal settings and logs outside the workspace. The earlier sandbox-related settings, logging, and certificate-store errors did not recur during completion validation.

## Remaining manual checks

Milestone 4.1 manual acceptance is complete. Additional checks for future work:

1. Assess the documented pixelated edges, harsh shadows, and possible aircraft sizing issue at the intended 16:10 resolution.
2. Check propeller appearance and window resizing; these were not explicitly covered by the reported playtest results.
3. Test on Lenovo Legion Go 2 / SteamOS for controller compatibility and 60 FPS performance. The reported playtest did not specify target hardware or measured performance.

## Recommended next milestone

- Milestone 4.2: the dedicated pitch-up maneuver, with its controls and behavior scoped before implementation. No maneuver work is included in milestone 4.1.
- Track the documented visual issues for a separately scoped polish task while preserving the accepted flight behavior.
