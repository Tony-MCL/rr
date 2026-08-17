# Ricochet Rush – Phase 1 Verification

**Phase:** 1 – Physics and firing foundation  
**Status:** Verified complete  
**Date:** 2026-08-17

## Scope verified

Phase 1 established the minimum physical firing environment without adding Phase 2 lifecycle systems.

Implemented and verified:

- Gameplay shell;
- fixed portrait playfield with left, right, and top physical boundaries;
- fixed top-mounted Cannon component;
- drag-to-aim input;
- approximately ±85 degree aiming clamp;
- no upward aiming;
- tap/click firing;
- 40 px Cannonball using RigidBody2D physics;
- muzzle spawning and launch velocity;
- wall ricochet behavior;
- open bottom playfield;
- BottomExit detection and cannonball removal;
- cannon remains rotatable while a cannonball is active;
- fired cannonball path is not affected by later cannon movement.

## Desktop verification

Verified in Godot 4.7.1 stable on Windows.

Observed behavior:

- cannon remains anchored;
- drag direction matches pointer direction;
- drag does not fire;
- short click fires one cannonball;
- cannonball starts at the muzzle and follows the selected angle;
- cannonball bounces against playfield boundaries;
- cannonball exits through the bottom;
- BottomExit reports `BALL EXITED` once per exiting cannonball;
- cannon can be rotated while cannonballs remain active.

Multiple ordinary cannonballs can currently exist at the same time. This is intentional at the Phase 1 boundary. Blocking ordinary firing during an active shot belongs to Phase 2 BallManager ownership.

## Android checkpoint

Verified on a physical Samsung SM-S918B through Godot Remote Debug.

Observed behavior:

- portrait layout runs correctly;
- playfield boundaries render correctly;
- touch drag aims the cannon;
- touch tap fires cannonballs;
- cannonball physics and wall ricochets run correctly;
- bottom exit works on device;
- no obvious performance or touch-input fault was observed during the checkpoint.

## Android development environment used

Working local setup during verification:

- Godot 4.7.1 stable;
- Android SDK under `C:\Users\Tony\AppData\Local\Android\Sdk`;
- Android SDK Build-Tools 35.0.1;
- Microsoft OpenJDK 17.0.20, Godot Java SDK path set to `C:\Program Files\Microsoft\jdk-17.0.20.8-hotspot`;
- Android application ID used for the debug preset: `com.morningcoffeelabs.ricochetrush`.

These machine-specific paths are verification notes, not project requirements for other development machines.

## Phase boundary

Not implemented in Phase 1:

- BallManager;
- shot IDs;
- active-shot blocking;
- ammunition;
- ball catcher;
- targets;
- scoring;
- objectives;
- levels.

These remain owned by later phases according to `06_BUILD_PLAN.md`.
