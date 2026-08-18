# Ricochet Rush – Phase 2 Verification

**Phase:** 2 – Shot lifecycle, ammunition, and catcher  
**Status:** Verified complete  
**Date:** 2026-08-18

## Scope verified

Phase 2 established the shot lifecycle and ammunition foundation on top of the verified Phase 1 physics and firing behavior.

Implemented and verified:

- BallManager owns cannonball spawning and shot lifecycle;
- unique sequential shot IDs;
- tracking of all active balls belonging to a shot;
- ordinary firing blocked while a shot remains active;
- cannon remains aimable while a shot is active;
- AmmoController owns current ammunition;
- temporary Gameplay start ammunition configured to 5;
- one ammunition unit committed when an ordinary shot is fired;
- next ordinary ball becomes available only after the active shot completes;
- next shot uses the cannon's current angle;
- standard horizontally moving ball catcher;
- every caught cannonball returns exactly +1 ammunition;
- ammunition may exceed the starting amount;
- ammunition may be spent down to zero;
- bonus-ball spawning API from a world position, attached to the active shot ID;
- a shot completes only when all balls belonging to that shot have been removed;
- explicit `shot_completed(shot_id)` signal;
- technical stuck-ball failsafe with a default timeout of 120 seconds.

## Desktop verification

Verified in Godot on Windows.

Observed behavior:

- starting ammunition is 5;
- tap/click fires one ordinary cannonball;
- repeated ordinary firing is blocked while the current shot is active;
- cannon can still be rotated while the current shot is active;
- an ordinary bottom exit removes the ball without returning ammunition;
- catcher contact reports `BALL CAUGHT`, removes the ball from active tracking, and returns +1 ammunition;
- after the final related ball is removed, the shot completes once and the next ball is loaded when ammunition remains;
- bonus balls spawned during verification shared the active shot ID and delayed shot completion until every related ball had exited or been caught;
- multiple caught balls allowed ammunition to rise from the starting value of 5 to 10 during verification;
- the accumulated ammunition could then be fired and lost normally until 0 remained;
- the stuck-ball failsafe was verified with a temporarily reduced timeout and normal configuration restored to 120 seconds afterward;
- no functional fault was observed during the final desktop checkpoint.

The temporary keyboard bonus-ball test trigger used during development was removed before final Phase 2 verification. The production-facing `spawn_bonus_ball(...)` BallManager API remains available for later gameplay systems.

## Android checkpoint

Verified on a physical Android phone through the existing Godot Android development workflow.

Observed behavior:

- portrait gameplay runs smoothly;
- touch drag continues to aim the cannon;
- touch tap fires normally;
- only one ordinary shot is active at a time;
- cannon remains aimable during an active shot;
- bottom exit behavior works correctly;
- catcher detection works correctly;
- catcher returns ammunition correctly;
- shot completion and next-ball loading work correctly;
- ammunition can be consumed down to zero;
- no obvious touch, lifecycle, physics, or performance fault was observed during the checkpoint.

## Phase boundary

Not implemented in Phase 2:

- permanent inventory or cross-level ammunition persistence;
- real bonus targets that invoke bonus-ball spawning;
- peg or target gameplay;
- scoring;
- objectives;
- level framework;
- progression;
- final catcher art, effects, or polish.

These remain owned by later phases according to `06_BUILD_PLAN.md`.

## Verification result

Phase 2 is verified complete on desktop and Android. The shot lifecycle, ammunition flow, catcher behavior, multi-ball shot ownership, and technical stuck-ball protection are stable enough to serve as the foundation for Phase 3 level framework work.
