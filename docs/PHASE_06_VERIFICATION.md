# Phase 6 Verification — Scoring, Bonuses & Objectives

## Status

Phase 6 implementation is complete and has been manually verified in Godot 4.7.1.

Branch: `phase-6-scoring-bonuses-objectives`

Final focused regression result: **21 / 21 PASS**.

## Implemented

- `ScoreController` as the owner of ordinary-play scoring state.
- Global Zone values:
  - Zone 1 = 10
  - Zone 2 = 20
  - Zone 3 = 30
  - Zone 4 = 40
- One-hit target scoring.
- Three-hit target scoring with normal value on hits 1–2 and ×10 target value on the final hit.
- Construction series progression: 10, 20, 40, 60, 80, then 100 per further hit.
- Construction milestones:
  - hit 10 = +500
  - hit 15 = +1,000
  - hit 20 = +3,000
- Chained qualifying construction multipliers:
  - first qualifying construction series = ×1
  - second = ×5
  - third and later = ×25
- Pure Peg, pure Block and Mixed general-series tracking foundation without inventing unresolved bonus thresholds or values.
- Skill-shot foundation with Long Shot working detector and current test value of +1,000.
- Extra Ball bonus role awarding +1 ammunition once per bonus target.
- Shot-wide Double Score using shot identity.
- Double Score stacking ×2 → ×4 → ×8.
- Double Score termination at shot end and bonus trigger.
- `ObjectiveController` as the owner of objective state and evaluation.
- Score objective.
- Target-count objective.
- Designated Objective targets.
- Clear-all objective excluding solids.
- Combined mandatory objectives using AND logic.
- Separate bonus trigger and final evaluation.
- Temporary verification HUD showing score, ammunition, active shot multiplier, objective progress, bonus-trigger state and final-evaluation state.

## Verification results

All 21 focused Phase 6 test scenes were run again through the final Phase 6 regression runner after implementation was complete.

| Area | Result |
| --- | --- |
| ScoreController foundation | PASS |
| Global Zone values | PASS |
| One-hit scoring | PASS |
| Three-hit scoring / ×10 final hit | PASS |
| Construction series | PASS |
| Construction milestones | PASS |
| Chained construction multipliers | PASS |
| General-series foundation | PASS |
| Long Shot foundation | PASS |
| Extra Ball | PASS |
| Shot-wide Double Score | PASS |
| Double Score stacking | PASS |
| Double Score lifetime | PASS |
| ObjectiveController foundation | PASS |
| Score objective | PASS |
| Target-count objective | PASS |
| Designated Objective targets | PASS |
| Clear-all objective | PASS |
| Combined AND objectives | PASS |
| Bonus trigger vs. final evaluation | PASS |
| Temporary verification HUD | PASS |

Final runner result:

```text
PHASE 6 REGRESSION: PASS
21 / 21 focused tests passed
```

## Phase-gate verification

The Phase 6 build-plan verification requirements were covered by the focused tests and final regression:

- ordinary target points remain separate from construction-series, skill-shot and bonus layers;
- construction series reset behavior is verified;
- repeated hits on three-hit targets follow the documented normal/normal/×10 rule;
- Double Score is shot-wide and shared by active balls with the same shot identity;
- Double Score is ended before bonus-phase scoring can begin;
- objective target destruction is counted once;
- solids do not count toward target objectives or clear-all;
- combined mandatory objectives use AND for final evaluation;
- mandatory non-score completion can trigger bonus while a mandatory score requirement remains pending;
- final evaluation remains separate and can therefore still fail until the score requirement is satisfied.

## Implementation notes

### Chained construction multipliers

A regression during implementation exposed that applying the new chain multiplier only from the sixth hit onward would under-score the first five hits of a qualifying construction. The implementation was corrected so that when the construction qualifies on hit 6, the earlier base series points in that construction are retroactively adjusted. The complete qualifying construction therefore receives the intended multiplier.

### General series

Phase 6 deliberately implements only the locked classification/tracking foundation for pure Peg, pure Block and Mixed series. Thresholds and bonus values that remain open in the design documentation were not invented during implementation.

### Long Shot

The current detector uses a 600 px distance between qualifying target hits and awards the documented working value of +1,000. The exact geometry remains a balance/tuning concern and can be refined later without changing the skill-shot ownership structure.

### Temporary HUD

The Phase 6 HUD is explicitly a verification aid, not final presentation. Final score effects and full bonus presentation remain outside Phase 6 scope.

## Godot UID files

Godot may have generated `.gd.uid` files for new Phase 6 scripts during local verification. These must be reviewed and tracked before the phase branch is finalized and merged.

## Phase 6 acceptance

All 21 planned Phase 6 work units are implemented. Tony manually verified the final regression runner in Godot with **21 / 21 focused tests PASS**.

The functional Phase 6 gate is therefore satisfied. Remaining phase-close work is repository cleanup, Godot UID tracking, clean-working-tree confirmation, and merge to `main`.
