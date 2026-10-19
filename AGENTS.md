# Development guidelines

## Engine and GDScript

- Target Godot 4.x, currently configured for Godot 4.7, and use GDScript.
- Prefer typed GDScript: annotate variables, parameters, and return values where their types are known and useful.
- Follow Godot 4 APIs and the existing project conventions. Keep code direct and readable.

## Structure and implementation

- Build modular, reusable scenes around clear responsibilities.
- Keep gameplay state and logic separate from visual presentation where practical; visual effects must not own gameplay rules.
- Make movement frame-rate independent by using the frame delta or the appropriate physics tick.
- Develop gamepad-first, especially for the target handheld. Keep the controls and feedback comfortable to use with a controller.
- Prefer simple, maintainable implementations. Avoid unnecessary complexity, speculative frameworks, placeholder systems, and external plugins.
- Preserve all existing gameplay behavior when modifying existing features. Do not regress or remove working gameplay to implement a new change.
- Complete one small milestone at a time and keep changes within the active milestone.

## Testing and reporting

- Use relevant checks available in the project, such as Godot project/editor validation and focused runtime checks when applicable.
- Report the exact checks run and their actual results. Clearly state when a check could not be run or when gameplay has not yet been exercised.
- Do not claim that unrun checks passed. Report discovered issues and any remaining uncertainty.

## Project status

- Update `PROJECT_STATUS.md` whenever milestone work changes what is completed, known to be an issue, planned next, or tested.
- Keep the status factual and scoped to work that has actually been completed.
