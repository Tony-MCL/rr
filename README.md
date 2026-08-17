# Ricochet Rush

Ricochet Rush is a portrait-format physics-based arcade and level game built with Godot.

## Production engine version

**Godot 4.7.1-stable**

Use this exact version on active development machines unless an engine upgrade is deliberately reviewed, tested, and approved according to `docs/06_BUILD_PLAN.md`.

## Project status

Phase 0 — Production foundation.

The repository contains the clean production project. Prototype code is not part of this foundation.

## Open the project

1. Install Godot 4.7.1-stable.
2. Clone this repository.
3. Import/open `project.godot` in Godot.
4. Run the project.

The current startup scene is intentionally empty. A successful run should open a blank portrait-format window without missing-resource errors.

## Project structure

```text
res://
├── assets/
├── autoload/
├── components/
├── core/
├── data/
├── levels/
├── scenes/
├── ui/
├── tests/
├── docs/
├── project.godot
└── README.md
```

See `docs/03_PROJECT_STRUCTURE.md` for ownership and architecture, `docs/06_BUILD_PLAN.md` for production phases, and `docs/07_WORKFLOW.md` for the working method.
