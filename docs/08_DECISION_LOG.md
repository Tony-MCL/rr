# Ricochet Rush – Decision Log

**Document status:** Active log  
**Purpose:** Record important project decisions, their reasons, and later reversals.

New entries are appended. If a decision changes, do not erase the original entry; add a new entry that supersedes it.

## Decision format

```text
ID:
Date:
Decision:
Reason:
Impact:
Status:
```

## D-001 – Clean production restart

**Date:** 2026-08-17  
**Decision:** Build Ricochet Rush as a clean production project in `Tony-MCL/rr`. Do not migrate the old local prototype as the foundation.  
**Reason:** The prototype successfully exposed required components but mixed learning, architecture, physics, UI, and level work.  
**Impact:** Production begins from documented structure. The old prototype may be deleted locally.  
**Status:** Active

## D-002 – Documentation-first planning

**Date:** 2026-08-17  
**Decision:** Complete the core project documents before production coding.  
**Reason:** Preserve decisions outside chat and make the project resumable after long breaks.  
**Impact:** Build threads follow the repository documents.  
**Status:** Active

## D-003 – Portrait, one-handed play

**Date:** 2026-08-17  
**Decision:** RR uses portrait orientation and can be played entirely with one hand.  
**Reason:** Short, accessible mobile sessions are a core product goal.  
**Impact:** Cannon, HUD, map, menus, and touch input are designed for portrait use.  
**Status:** Active

## D-004 – Cannon control

**Date:** 2026-08-17  
**Decision:** The cannon is anchored at the top, rotates approximately 80–85 degrees to either side of vertical, and never affects the ball after firing. Drag aims; tap fires.  
**Reason:** Simple control with meaningful pre-shot skill.  
**Impact:** Cannon may rotate during an active shot but cannot fire another ordinary ball.  
**Status:** Active

## D-005 – Shot definition

**Date:** 2026-08-17  
**Decision:** A shot may contain several active bonus balls and ends only after all balls belonging to it leave the playfield.  
**Reason:** Bonus targets can create additional balls from the hit location.  
**Impact:** BallManager tracks shot membership and blocks ordinary firing until completion.  
**Status:** Active

## D-006 – Ball catcher

**Date:** 2026-08-17  
**Decision:** A standard moving catcher is present from level 1 and returns +1 ammunition for each ball caught. It can be disabled on selected levels.  
**Reason:** It provides skill, luck, and theoretical ammunition preservation.  
**Impact:** Several caught balls can create net ammunition gain. Catcher size and speed stay consistent through pack 1.  
**Status:** Active

## D-007 – Loss and lives

**Date:** 2026-08-17  
**Decision:** A level is lost only after the final shot fully ends without completing the objective or earning ammunition. One life is removed on loss, not on level start.  
**Reason:** Match player expectation and avoid punitive behavior.  
**Impact:** Restart and voluntary exit cost no life.  
**Status:** Active

## D-008 – Five-life model

**Date:** 2026-08-17  
**Decision:** Maximum five lives, regenerating one every 20 minutes while open or closed. Rewarded ad gives one life; tokens give full refill.  
**Reason:** Generous but meaningful session pacing.  
**Impact:** Save data stores life count and regeneration timestamp.  
**Status:** Active

## D-009 – Local-first progress

**Date:** 2026-08-17  
**Decision:** Ordinary progress is local and requires no account.  
**Reason:** Offline play and low-friction access are priorities.  
**Impact:** Reinstall may lose progression and leaderboard identity in v1 unless future restore is added.  
**Status:** Active

## D-010 – Optional leaderboard identity

**Date:** 2026-08-17  
**Decision:** Only players who choose a display name receive a leaderboard row. A random local install ID updates that row.  
**Reason:** Avoid unnamed scores and registration requirements.  
**Impact:** Results queue offline and submit later; display name can change without losing the row.  
**Status:** Active

## D-011 – Global RR rank formula

**Date:** 2026-08-17  
**Decision:** `RR rank points = completed levels × average cups²`, with no minimum-level requirement.  
**Reason:** Balance quality and progression while allowing new players immediate participation.  
**Impact:** Ties use completed levels, exact cup average, and normalized score. Future First 10 Levels category may be added.  
**Status:** Active

## D-012 – Scrollable progression map

**Date:** 2026-08-17  
**Decision:** The progression map is a vertically scrollable path and the normal home screen.  
**Reason:** Simpler than separate islands while still supporting themed areas.  
**Impact:** Tapping a level opens its introduction; leaderboard and settings link from the map.  
**Status:** Active

## D-013 – Packs of 25

**Date:** 2026-08-17  
**Decision:** Standard level packs contain 25 levels. First release minimum is 25; preferred target is 50.  
**Reason:** Useful content size for launch and updates.  
**Impact:** Published folders use `pack_01`, `pack_02`, and so on.  
**Status:** Active

## D-014 – Permanent level identity

**Date:** 2026-08-17  
**Decision:** A published level number is never reused. Corrections increase `content_version`.  
**Reason:** Preserve progression and historical identity.  
**Impact:** Updated levels receive a map marker while old best results remain.  
**Status:** Active

## D-015 – Godot as v1 level editor

**Date:** 2026-08-17  
**Decision:** Use Godot editor, LevelTemplate, ComponentGallery, and Inspector configuration instead of building a separate editor application.  
**Reason:** Fastest stable path to no-code level production.  
**Impact:** A custom standalone editor is optional future work.  
**Status:** Active

## D-016 – Standard geometry

**Date:** 2026-08-17  
**Decision:** Use standardized pegs and blocks rather than free scaling. Working sizes are ball 40 px, peg 45 px, and straight block 50 × 30 px.  
**Reason:** Consistent physics, graphics, and modular construction.  
**Impact:** Final dimensions are verified during production physics testing.  
**Status:** Active

## D-017 – Curved block family

**Date:** 2026-08-17  
**Decision:** V1 includes straight block plus small- and large-radius curved blocks with snap points.  
**Reason:** Two wheel diameters and modular curves create extensive variety.  
**Impact:** Curved pieces share block roles and behaviors.  
**Status:** Active

## D-018 – Composable movement

**Date:** 2026-08-17  
**Decision:** V1 supports static, slide, rotation, and circular/orbit movement. Groups may combine slide and rotation.  
**Reason:** A wheel must be static, rotating, sliding, or both rotating and sliding.  
**Impact:** Movement is composed through parent groups rather than one exclusive mode.  
**Status:** Active

## D-019 – V1 objective scope

**Date:** 2026-08-17  
**Decision:** V1 level objectives are score, target count, designated objective targets, clear-all, and AND combinations.  
**Reason:** Complete the game sooner with a strong reusable core.  
**Impact:** Physical objective objects such as eggs and marbles are postponed.  
**Status:** Active

## D-020 – Target roles

**Date:** 2026-08-17  
**Decision:** Standard pegs and blocks combine Physical Role, Target Role, Hits Required, and Bonus Reward in Inspector.  
**Reason:** Avoid separate hard-coded scenes for every combination.  
**Impact:** Target/Solid, Normal/Objective, one/three hits, Extra Ball, and Double Score are composable.  
**Status:** Active

## D-021 – Zone scoring

**Date:** 2026-08-17  
**Decision:** Zones are logical groups with global standard values 10, 20, 30, and 40. Moving targets retain zone identity.  
**Reason:** Simplify level design and support curved or moving structures.  
**Impact:** Designers do not enter ordinary point values on every target.  
**Status:** Active

## D-022 – Multi-hit scoring

**Date:** 2026-08-17  
**Decision:** One-hit targets award normal zone value. Three-hit targets award normal, normal, then zone value ×10.  
**Reason:** Make the destroying hit satisfying without overpaying one-hit targets.  
**Impact:** Applies to both pegs and blocks.  
**Status:** Active

## D-023 – Construction series

**Date:** 2026-08-17  
**Decision:** Uninterrupted construction hits score 10, 20, 40, 60, 80, then 100 per hit, with milestones at 10, 15, and 20.  
**Reason:** Reward deliberate use of connected block structures.  
**Impact:** Series breaks on collision outside the active construction.  
**Status:** Active

## D-024 – Chained construction multiplier

**Date:** 2026-08-17  
**Decision:** Qualifying directly chained construction series use ×1, ×5, and ×25, capped at ×25.  
**Reason:** Rare multi-construction shots deserve exceptional bonuses.  
**Impact:** Multiplier affects series bonuses, not ordinary target score.  
**Status:** Active

## D-025 – Double Score

**Date:** 2026-08-17  
**Decision:** Double Score is shot-wide, includes the activation hit, affects all active balls, and stacks ×2, ×4, ×8, and onward.  
**Reason:** Create risky, exciting high-score routes.  
**Impact:** It ends at shot completion or bonus trigger and never applies to bonus-phase score.  
**Status:** Active

## D-026 – Bonus trigger versus final win

**Date:** 2026-08-17  
**Decision:** Completing all non-score gameplay objectives triggers bonus phase even if a score requirement remains. Final win is evaluated after bonus scoring.  
**Reason:** Allow the closing bonus to rescue a near-successful score objective.  
**Impact:** Score-only levels trigger bonus when their score requirement is reached.  
**Status:** Active

## D-027 – Power-up scope for v1

**Date:** 2026-08-17  
**Decision:** V1 player assistance is basic aim, improved aim, extra ammunition, and the life system.  
**Reason:** Avoid designing speculative special balls before real level experience exists.  
**Impact:** Super Ball and other special cannonballs move to backlog.  
**Status:** Active

## D-028 – Non-linear difficulty

**Date:** 2026-08-17  
**Decision:** Difficulty varies rather than increasing linearly, especially after levels 10–15.  
**Reason:** Provide relief, variety, replay opportunity, and avoid one permanent wall.  
**Impact:** Internal Easy/Medium/Hard labels help plan the sequence.  
**Status:** Active

## D-029 – Lightweight level testing

**Date:** 2026-08-17  
**Decision:** Require at least one successful pre-publication completion without player-owned power-ups, not repeated formal certification.  
**Reason:** Keep level production practical and enjoyable.  
**Impact:** Test notes remain short and preferably partly automatic.  
**Status:** Active

## D-030 – Locked Godot version

**Date:** 2026-08-17  
**Decision:** Select one stable Godot version at Phase 0 and do not upgrade mid-project without deliberate testing.  
**Reason:** Protect physics, editor, input, and export stability.  
**Impact:** Exact version is recorded in README at project creation.  
**Status:** Active
