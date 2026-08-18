# Ricochet Rush – Phase 4 Verification

**Phase:** 4 – Standard target geometry  
**Status:** Verified complete  
**Date:** 2026-08-18

## Scope verified

Phase 4 established the reusable static v1 target geometry and the shared physical target behavior required for later scoring and level construction.

Implemented and verified:

- cannonball working diameter retained at 40 px;
- Peg at 45 px diameter;
- StraightBlock at 50 × 30 px;
- CurvedBlockSmall and CurvedBlockLarge as standardized 30 px-thick modular track segments;
- shared `TargetBody` behavior for all standard target shapes;
- configurable Physical Role: `TARGET` or `SOLID`;
- configurable one-hit and three-hit targets;
- target states: `ACTIVE`, `DAMAGED`, `DESTROYED_DELAY`, and `REMOVED`;
- configurable removal delay through Inspector;
- protection against duplicate continuous-contact hits;
- standardized left/right snap points and tangent orientation for blocks;
- connected straight and curved block geometry with smooth physical surfaces;
- Solid elements confirmed to remain permanent and ignore target-hit behavior.

## Standard geometry baseline

The Phase 4 production baseline is:

| Component | Working geometry |
|---|---:|
| Cannonball | 40 px diameter |
| Peg | 45 px diameter |
| StraightBlock | 50 × 30 px |
| CurvedBlockSmall | 50 px snap-to-snap module, 30 px track thickness |
| CurvedBlockLarge | 50 px snap-to-snap module, 30 px track thickness |

The curved blocks are intentionally constructed as track segments rather than isolated decorative arcs.

Their end faces and snap orientation follow the local path tangent so connected pieces form a continuous playable surface.

## Desktop verification

Verified in Godot on Windows.

Observed behavior:

- cannonball collision and bounce remained stable against Peg, StraightBlock, CurvedBlockSmall, and CurvedBlockLarge;
- all standard shapes remain stationary as expected for static geometry;
- one-hit targets accept one valid hit and immediately enter destruction flow;
- three-hit targets progress through 1/3, 2/3, and 3/3 correctly;
- three-hit targets enter `DAMAGED` after non-final valid hits;
- final valid hit enters `DESTROYED_DELAY` immediately;
- destroyed-delay targets remain physical until the configured removal delay ends;
- removed targets disappear after the configured delay;
- `removal_delay_seconds` is configurable in Inspector and can be tuned per placed instance;
- one continuous physical contact cannot register multiple target hits;
- after the cannonball fully leaves and later re-enters contact, a new valid hit may register;
- Solid elements do not register target hits, do not change target state, and never disappear;
- existing Phase 1–3 firing, shot lifecycle, ammunition, catcher, and level-loading behavior continued to operate during Phase 4 testing.

## Connected block verification

Straight and curved blocks are intended to form playable structures and paths.

The final geometry test used connected rows of:

- 10 × CurvedBlockSmall;
- 10 × StraightBlock;
- 10 × CurvedBlockLarge.

Each row uses a 50 px snap-to-snap module, giving the same nominal 500 px construction length for ten pieces.

During testing, the original curved geometry exposed visible and physical discontinuities. The geometry was deliberately revised before Phase 4 approval.

The verified solution uses:

- 30 px shared thickness across all block families;
- snap points centered on the actual short-side connection face;
- tangent-aware connection orientation for curved segments;
- end geometry designed so adjacent modules form smooth continuous surfaces.

The final test showed smooth connected surfaces suitable for the ball to travel across without harmful collision steps or gaps.

This geometry is the baseline for future paths, curves, wheels, channels, and mixed constructions.

## Shared TargetBody behavior

All standard target shapes use the shared:

```text
res://components/targets/target_body.gd
```

The script owns:

- Physical Role;
- hit-count configuration;
- valid-hit count;
- target state;
- destruction transition;
- removal delay;
- target-hit and state signals.

Shape scenes own geometry and collision only where possible. Target behavior is not duplicated per shape.

## Physical roles

### Target

A Target currently:

- accepts configured valid hits;
- emits target-hit behavior for later scoring integration;
- supports one-hit or three-hit configuration;
- enters damage/destruction states;
- stops accepting valid hits after destruction begins;
- remains physical during removal delay;
- removes itself after the configured delay.

Actual score values are intentionally not implemented in Phase 4. Score ownership remains with the later ScoreController phase.

### Solid

A Solid:

- remains physically collidable;
- rejects target-hit registration;
- does not enter damaged or destroyed states;
- never removes itself;
- emits no target-hit behavior that can later become score.

This establishes the Phase 4 side of the rule that Solid elements never score or disappear.

## Continuous-contact protection

Cannonball contact tracking prevents one persistent contact from farming multiple hits.

The same target may only register another hit after the cannonball has genuinely exited contact and later entered again.

This protection is required before three-hit targets and later scoring can be considered reliable.

## Phase boundary

Not implemented in Phase 4:

- logical Zone component or inherited zone identity;
- ConstructionGroup;
- slide, rotation, or circular/orbit movement;
- wheel construction;
- actual scoring values or ScoreController;
- Objective target role;
- Extra Ball or Double Score bonus behavior;
- level objectives;
- production graphics or effects.

These remain owned by later phases according to `06_BUILD_PLAN.md`.

## Verification result

Phase 4 is verified complete on desktop.

All standard static v1 geometry is reusable, physically stable, configurable through Inspector for the implemented roles, and suitable for real level construction. Straight and curved block modules now form smooth connected playable surfaces, and Target/Solid behavior is stable enough for Phase 5 zones, constructions, and movement.
