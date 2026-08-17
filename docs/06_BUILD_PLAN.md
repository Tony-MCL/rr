# Ricochet Rush – Build Plan

**Document status:** Approved production roadmap  
**Purpose:** Define the exact production sequence, phase boundaries, verification gates, documentation rhythm, commit strategy, and testing cadence for the new Ricochet Rush project.

This plan exists to prevent prototype-style development from mixing learning, architecture, physics, UI, scoring, content, and presentation in one uncontrolled workflow.

## 1. Production project

The production project is created in:

```text
https://github.com/Tony-MCL/rr
```

The old local Godot prototype is not migrated into the production project.

It may be deleted locally by Tony when desired. Its useful design knowledge has been transferred into the project documentation.

No production code should be copied from the prototype without deliberately reviewing whether it fits the new structure.

## 2. Working principles

Development follows these rules:

- one active phase at a time;
- one component or bounded system at a time;
- no spontaneous architecture change inside an unrelated task;
- existing verified functionality is preserved;
- new ideas go to `BACKLOG.md`;
- every component has one clear owner;
- normal level creation must not require code;
- a phase is not complete because files exist;
- a phase is complete when its defined behavior is verified;
- documentation is updated with the implementation;
- every completed work unit receives a clear commit.

## 3. Thread strategy

This conversation remains the documentation and decision thread.

Production work happens in separate build threads.

Normal guidance:

- one main phase per build thread;
- two short related phases may share one thread;
- a large phase may be split into several threads;
- a new thread begins with the relevant documentation, current commit, completed work, active goal, and out-of-scope items.

The thread boundary is a collaboration tool, not a rigid project rule.

## 4. Work-unit rhythm

Every implementation unit follows this sequence:

1. State the component goal.
2. Identify the exact files and Godot nodes involved.
3. Explain the component’s responsibility in plain language.
4. Build only the agreed scope.
5. Run the defined test.
6. Let Tony verify the visible behavior where relevant.
7. Record configuration, location, signals, and limitations.
8. Commit the completed unit with a clear message.
9. Move to the next unit only after the current one is understood and stable.

Typical commits:

```text
Create Godot project structure
Add cannon rotation
Add cannonball physics
Add shot lifecycle
Add ball catcher
Add level loader
Add reusable peg target
Add zone scoring
```

Avoid commits such as:

```text
Various fixes
More work
Update files
Stuff
```

## 5. Godot version policy

At Phase 0:

- select a current stable Godot release;
- verify it against official Godot release information;
- record the exact version in `README.md`;
- use the same version on active development machines;
- do not upgrade automatically mid-project.

An upgrade requires:

1. a concrete reason;
2. review of relevant breaking changes;
3. a clean committed state;
4. a temporary upgrade test;
5. verification of physics, input, export, and editor behavior;
6. an explicit decision to adopt or reject the upgrade.

Stability is more valuable than using a newer version without need.

## 6. Testing cadence

### Early phases

Use Godot desktop playtesting continuously.

Android builds are not required after every small component.

Run Android checkpoints when:

- core touch input and cannon control are ready;
- core physics and shot lifecycle are stable;
- the first complete playable level loop exists.

### Presentation and platform phases

Increase mobile testing frequency when work includes:

- touch behavior;
- screen scaling;
- HUD and overlays;
- graphics;
- particles and effects;
- audio;
- performance;
- advertisements;
- purchases;
- platform services.

During these phases, several mobile tests may occur inside one phase.

### iOS

iOS testing begins when the core mobile loop is stable enough to justify the build overhead and becomes frequent during release preparation.

## 7. Phase gates

Every phase has:

- scope;
- explicit deliverables;
- verification;
- exit condition;
- out-of-scope boundaries.

A phase is not closed until its exit condition is satisfied.

If a later phase exposes a real foundation fault, return to the owning phase deliberately, fix it, document the reason, and commit the correction.

---

# Phase 0 – Production foundation

## Goal

Create a clean Godot project and repository structure without importing prototype code.

## Work units

1. Select and record Godot version.
2. Create the Godot project in the repository.
3. Configure portrait viewport and stretch behavior.
4. Create the approved folder structure.
5. Add a Godot-appropriate `.gitignore`.
6. Add initial `README.md`.
7. Create empty application and gameplay scene placeholders only where useful.
8. Confirm the project opens without warnings or missing resources.
9. Confirm Git tracks only intended project files.

## Deliverables

- working `project.godot`;
- approved folders;
- version record;
- clean startup scene;
- repository ready for component commits.

## Verification

- project opens in the locked Godot version;
- empty startup runs on desktop;
- portrait dimensions are correct;
- no prototype dependencies exist;
- repository is clean after commit.

## Exit condition

A new contributor can clone the repository, open the project with the recorded Godot version, and run the empty foundation.

## Out of scope

No cannon, ball, targets, scoring, menus, or presentation.

---

# Phase 1 – Physics and firing foundation

## Goal

Build the minimum physical environment required to fire one reliable cannonball.

## Work units

1. Create Gameplay shell.
2. Create playfield boundaries.
3. Create Cannon scene.
4. Implement fixed anchor and rotation.
5. Implement 80–85 degree configurable limits.
6. Implement drag-to-aim and tap-to-fire.
7. Create Cannonball scene.
8. Configure working ball size and physics material.
9. Implement muzzle spawning and launch speed.
10. Create bottom exit detection.
11. Prevent upward aiming.
12. Allow cannon rotation while a ball is active.

## Deliverables

- one cannon;
- one physical cannonball;
- reliable wall bounce;
- bottom exit event;
- working desktop mouse and touch-compatible input abstraction.

## Verification

- cannon remains anchored;
- angle is clamped correctly;
- drag does not fire;
- tap fires once;
- ball bounces consistently;
- ball exits through the bottom;
- player cannot alter ball path;
- cannon can rotate during the active shot.

## Exit condition

The physical firing loop behaves predictably through repeated desktop tests.

## Mobile checkpoint

Run an Android test for touch feel, portrait layout, and basic performance before permanently locking input behavior.

## Out of scope

No ammunition, targets, catcher, levels, or score.

---

# Phase 2 – Shot lifecycle, ammunition, and catcher

## Goal

Turn physical firing into a complete repeatable shot system.

## Work units

1. Create BallManager.
2. Assign shot IDs.
3. Track all active balls.
4. Block ordinary firing during an active shot.
5. Create AmmoController.
6. Configure starting ammunition for a temporary test scene.
7. Load the next ball at the cannon’s current angle.
8. Create the standard ball catcher.
9. Return +1 ammunition for every caught ball.
10. Support bonus-ball spawning from a world position.
11. End the shot only when all related balls have exited.
12. Test ammunition above starting amount.
13. Add technical protection for impossible stuck-ball conditions without changing normal rules.

## Verification

- one ordinary ball fires at a time;
- cannon remains rotatable;
- bonus balls belong to the same shot;
- no next shot loads while any related ball remains;
- each caught ball returns one ammunition;
- several caught balls can create net ammunition gain;
- uncaught balls leave normally;
- shot completion fires exactly once.

## Exit condition

The complete shot lifecycle works with one and several active balls and never double-loads or loses ammunition.

## Out of scope

No score, objectives, permanent inventory, or bonus phase.

---

# Phase 3 – Level framework

## Goal

Load numbered levels into one fixed gameplay shell.

## Work units

1. Create level configuration resource.
2. Create `LevelTemplate.tscn`.
3. Create LevelLoader.
4. Create central level catalog.
5. Create `levels/templates/`, `drafts/`, and published pack folders.
6. Create two simple temporary test levels.
7. Load selected level by catalog ID.
8. Validate required metadata.
9. Unload and switch level safely.
10. Expose starting ammunition and core Inspector groups.
11. Exclude drafts from production export.

## Verification

- both temporary levels use the same Gameplay shell;
- changing level does not duplicate controllers;
- level ID and ammunition are read from configuration;
- missing required data produces a clear error;
- drafts do not appear as published content.

## Exit condition

A new level can be duplicated from the template, registered in the catalog, and loaded without writing gameplay code.

## Out of scope

No production target library or progression map.

---

# Phase 4 – Standard target geometry

## Goal

Create the reusable physical building pieces for v1.

## Work units

1. Verify final cannonball, peg, and block working dimensions.
2. Create Peg.
3. Create StraightBlock.
4. Create CurvedBlockSmall.
5. Create CurvedBlockLarge.
6. Add Target and Solid physical roles.
7. Add one-hit and three-hit configuration.
8. Add active, damaged, destroyed-delay, and removed states.
9. Prevent duplicate continuous-contact hits.
10. Add configurable removal delay.
11. Create standardized snap points.
12. Test connected straight and curved pieces.
13. Confirm solid elements never score or disappear.

## Verification

- every standard shape has correct collision;
- one-hit and three-hit behavior works;
- destroyed targets stop accepting score immediately;
- delayed targets remain physical until removal;
- continuous contact cannot farm hits;
- connected blocks have no harmful physics gaps;
- roles are configured through Inspector.

## Exit condition

All standard static v1 geometry is reusable and stable enough for real level construction.

---

# Phase 5 – Zones, constructions, and movement

## Goal

Build reusable organization and movement without tying it to individual levels.

## Work units

1. Create logical Zone component.
2. Implement inherited Zone 1–4 identity.
3. Create ConstructionGroup.
4. Add shared pivot behavior.
5. Create Static movement.
6. Create Slide movement.
7. Create Rotation.
8. Create Circular/orbit movement.
9. Verify deterministic initial phase.
10. Build small and large static wheels.
11. Build rotating wheels.
12. Build sliding wheels.
13. Combine sliding and rotation through nested groups.
14. Verify moving elements retain zone and construction identity.

## Verification

- zone identity survives movement;
- constructions are explicit;
- unrelated nearby blocks do not join a series;
- every movement resets identically;
- circular/orbit movement is physically verified;
- wheels work static, rotating, sliding, and combined;
- movement is configurable without code.

## Exit condition

The component kit can build the planned static and moving structures for the first hundred levels.

## Mobile checkpoint

Optional unless movement exposes performance or screen-bound issues.

---

# Phase 6 – Scoring, bonuses, and objectives

## Goal

Implement the complete ordinary-play scoring and v1 objective system.

## Work units

1. Create ScoreController.
2. Implement global zone values.
3. Implement one-hit scoring.
4. Implement three-hit scoring and ×10 final hit.
5. Implement construction series.
6. Implement milestones at 10, 15, and 20.
7. Implement chained construction multipliers ×1, ×5, and ×25.
8. Implement pure and mixed general-series foundation.
9. Implement skill-shot foundation and Long Shot detector.
10. Add Extra Ball bonus role.
11. Add shot-wide Double Score.
12. Verify ×2, ×4, ×8 stacking.
13. End Double Score at shot end or bonus trigger.
14. Create ObjectiveController.
15. Implement score objective.
16. Implement target-count objective.
17. Implement designated Objective targets.
18. Implement clear-all.
19. Implement combined AND objectives.
20. Separate bonus trigger from final evaluation.
21. Connect temporary HUD values for verification.

## Verification

Use focused test scenes for every scoring layer.

Confirm:

- ordinary points are unchanged by unrelated systems;
- series values reset correctly;
- same-block repeat hits follow documented rules;
- Double Score affects all active balls in the shot;
- bonus-phase and completion values are not doubled;
- objective progress occurs once;
- solids never count;
- combined objectives trigger bonus at the correct time;
- final score requirement can remain pending.

## Exit condition

Every locked v1 score and objective rule produces repeatable expected results.

## Out of scope

Final visual score effects and full bonus presentation.

---

# Phase 7 – Bonus phase and complete level result

## Goal

Complete the playable level lifecycle from introduction to final result.

## Work units

1. Select and document the first bonus-phase model.
2. Implement BonusPhaseController.
3. Transfer all active balls into bonus phase.
4. Preserve remaining and earned ammunition.
5. End ordinary Double Score.
6. Run selected remaining-ball behavior.
7. Award bonus-phase values.
8. Perform final objective evaluation.
9. Implement win.
10. Implement loss.
11. Create temporary Result screen.
12. Add Play Again, Next Level, and Map actions.
13. Add pause, full freeze, restart, settings entry, and exit.
14. Confirm player-owned power-up warning behavior structurally.

## Verification

- bonus starts at the documented trigger;
- active balls and catcher results are not lost;
- score objective can be rescued by bonus;
- insufficient final score can still cause loss;
- pause freezes all gameplay time;
- restart clears attempt state;
- result actions never duplicate sessions.

## Exit condition

One temporary level can be started, won, lost, paused, restarted, replayed, and advanced through a complete stable loop.

## Mobile checkpoint

Required Android test of the complete gameplay loop.

---

# Phase 8 – Saving, lives, power-ups, and progression

## Goal

Turn the complete level loop into persistent game progression.

## Work units

1. Implement versioned SaveManager.
2. Create local save schema.
3. Add safe write and recovery behavior.
4. Store level completion, best score, cups, and content version.
5. Add five-life maximum.
6. Add 20-minute offline regeneration.
7. Deduct life only on loss.
8. Preserve life on restart and exit.
9. Create player inventory.
10. Implement basic aiming aid.
11. Implement improved aiming aid.
12. Implement configurable extra-ammunition power-up.
13. Separate level-supplied and player-owned assistance.
14. Preserve player-owned consumption on restart.
15. Create LevelMap.
16. Unlock the next level.
17. Display completed, locked, available, and updated states.
18. Add updated-level version detection.
19. Add level introduction overlay and power-up selection.
20. Add temporary one-to-three coffee-cup thresholds.

## Verification

- progress survives app restart;
- life timer advances while closed;
- no life is lost on voluntary exit;
- used owned items remain consumed;
- level-supplied items regenerate on restart;
- old best result survives a worse replay;
- new better result replaces it;
- updated marker works across content versions;
- progression map opens the correct level.

## Exit condition

The game can be played as a persistent offline progression game without online services.

## Mobile testing

Run Android tests throughout touch, scaling, overlays, background timer, and save-lifecycle work.

---

# Phase 9 – Online and monetization systems

## Goal

Add optional connected features without making ordinary play dependent on them.

## Work units

1. Create random local install ID.
2. Add optional display name.
3. Add local and server-side name validation.
4. Add blocked-name rules.
5. Implement OnlineService.
6. Implement offline submission queue.
7. Submit only the newest relevant player state.
8. Implement global RR ranking formula.
9. Implement tie-break fields.
10. Normalize score performance.
11. Build Leaderboard screen.
12. Verify display-name changes preserve entry.
13. Add rewarded advertisement for one life.
14. Add token-based full life refill.
15. Add token earning and purchase foundation.
16. Add selected v1 inventory acquisition.
17. Handle unavailable network, ads, and store safely.
18. Document reinstall limitation without account.

## Verification

- unnamed players never create empty leaderboard entries;
- gameplay works offline;
- long offline progression queues safely;
- reconnection updates the row;
- duplicate rows are not created for the same install ID;
- RR rank points match documented examples;
- failed ads or purchases do not remove resources;
- purchased or awarded results are recorded safely.

## Exit condition

Online features add value but cannot block, corrupt, or interrupt the offline game.

## Mobile testing

Frequent Android testing is required. iOS platform testing begins here if not already started.

---

# Phase 10 – Presentation

## Goal

Replace temporary presentation with the recognizable Ricochet Rush game.

## Work units

1. Lock visual language for targets, solids, objectives, Extra Ball, and Double Score.
2. Add final HUD layout.
3. Add level introduction and result presentation.
4. Add score-event feedback.
5. Add target hit and destruction effects.
6. Add series, Long Shot, and large-bonus presentation.
7. Add cannon graphics.
8. Add BOP and required animations.
9. Add progression-map art.
10. Add menus, icons, and settings presentation.
11. Add music.
12. Add sound effects.
13. Add haptics where appropriate.
14. Verify readability on phones and tablets.
15. Optimize particles, graphics, and audio.

## Verification

- every gameplay role is visually readable;
- effects do not hide important ball movement;
- BOP does not interfere with aiming or HUD;
- audio settings work;
- portrait scaling works across target devices;
- performance remains stable with heavy bonus activity.

## Exit condition

The game looks, sounds, and feels like Ricochet Rush rather than a technical test.

## Mobile testing

Test frequently—often after each meaningful UI, graphics, effect, audio, or performance change.

---

# Phase 11 – Component gallery and level production

## Goal

Make Tony’s no-code level workflow real and produce pack 1.

## Work units

1. Complete ComponentGallery.
2. Label every v1 building block.
3. Verify LevelTemplate Inspector groups.
4. Add lightweight automatic test-result summary.
5. Produce levels 1–5.
6. Verify teaching flow.
7. Produce levels 6–10.
8. Produce levels 11–15.
9. Produce levels 16–20.
10. Produce levels 21–25.
11. Assign internal difficulty labels.
12. Test every level at least once successfully.
13. Verify completion without player-owned power-ups.
14. Set preliminary cup thresholds.
15. Publish pack 1 into catalog.
16. Begin pack 2 where schedule permits.

## Verification

- Tony can create and test a level without code;
- drafts remain excluded;
- published levels load from the catalog;
- first-pack mechanic progression matches `05_LEVEL_DESIGN.md`;
- no level contains a known blocker;
- level 25 completes the pack without requiring an unimplemented mechanic.

## Exit condition

At least 25 production levels are ready. Fifty is the preferred release target.

---

# Phase 12 – Release preparation

## Goal

Prepare stable Android and iOS releases.

## Work units

1. Full progression test from fresh save.
2. Save migration and recovery tests.
3. Offline and reconnection tests.
4. Android device matrix tests.
5. iOS device tests.
6. Tablet layout tests.
7. Advertisement and purchase sandbox tests.
8. Leaderboard validation.
9. Performance and memory testing.
10. Audio-interruption and background tests.
11. App icons, splash, metadata, privacy, and store assets.
12. Language and system-message review.
13. Final content-version review.
14. Release candidate build.
15. Internal or closed testing.
16. Fix release blockers only.
17. Production submission.

## Exit condition

A clean install can progress, save, play offline, reconnect, use optional online services, and survive ordinary platform lifecycle events without losing player data.

---

## 8. Documentation produced during building

The minimum ongoing documents are:

```text
docs/
├── 00_PROJECT_OVERVIEW.md
├── 01_GAME_RULES.md
├── 02_SCORING_AND_OBJECTIVES.md
├── 03_PROJECT_STRUCTURE.md
├── 04_COMPONENTS.md
├── 05_LEVEL_DESIGN.md
├── 06_BUILD_PLAN.md
├── 07_WORKFLOW.md
├── 08_DECISION_LOG.md
└── BACKLOG.md
```

During implementation:

- major decisions go to `08_DECISION_LOG.md`;
- deferred ideas go to `BACKLOG.md`;
- changed game rules update their owning design document;
- completed phases update status in this build plan;
- component-specific implementation notes remain concise and searchable.

## 9. Phase status convention

Each phase may use:

- `NOT STARTED`
- `IN PROGRESS`
- `BLOCKED`
- `VERIFIED`
- `COMPLETE`

A phase becomes `COMPLETE` only after verification and documentation.

## 10. Build-thread handoff template

A new build thread should begin with:

```text
Project: Ricochet Rush
Repository: https://github.com/Tony-MCL/rr
Active phase:
Starting commit:
Completed phases:
Current goal:
Required documents:
Explicitly out of scope:
Expected visible test:
```

The build agent reads the relevant repository documents before changing code.

## 11. Backlog rule

When a new idea appears during building:

1. decide whether it is required for the active phase;
2. if not, add it to `BACKLOG.md`;
3. continue the active work;
4. revisit it only at a planned decision point.

A good idea is not lost merely because it is not implemented immediately.

## 12. Definition of production readiness

Ricochet Rush is ready for release when:

- the documented game loop is complete;
- 25 levels minimum are ready;
- the no-code level workflow functions;
- saving and progression are stable;
- ordinary play works offline;
- optional online systems fail safely;
- monetization is moderate and functional;
- roles and objectives are visually understandable;
- Android and iOS release candidates have been tested;
- no known issue can reasonably destroy progression, purchases, or ordinary gameplay.
