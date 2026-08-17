# Ricochet Rush – Project Structure

**Document status:** Approved structural plan  
**Purpose:** Define the Godot project organization, system responsibilities, level workflow, saving, and online boundaries before production development.

## 1. Structural goals

The structure must make it possible to:

- understand where each responsibility belongs;
- build and test one system at a time;
- prevent level scenes from duplicating game logic;
- create levels without writing code;
- add new components without rebuilding existing levels;
- keep drafts out of production;
- publish levels in packs of approximately 25;
- update published levels without changing their identity;
- play ordinary levels offline;
- resume the project after months away.

The project favors clear ownership and practical solutions over unnecessary abstraction.

## 2. Three project layers

### Application layer

Owns startup, navigation, progression map, settings, saving, audio, leaderboard, and online communication.

### Gameplay layer

Owns the active level attempt, cannon, cannonballs, ammunition, scoring, objectives, power-ups, bonus phase, win, loss, and HUD.

### Level-content layer

Describes target placement, solid elements, zones, constructions, movement, objective objects, catcher configuration, starting ammunition, objectives, allowed assistance, ranking thresholds, and bonus model.

A level describes content. It must not own permanent inventory, global progression, file saving, navigation, or online communication.

## 3. Top-level folders

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

- `assets/`: graphics, audio, fonts, effects, shaders.
- `autoload/`: the small set of truly application-wide services.
- `components/`: reusable gameplay building blocks.
- `core/`: shared data types, base classes, constants, and utilities.
- `data/`: global configuration and catalogs.
- `levels/`: template, component gallery, drafts, and published packs.
- `scenes/`: application screens and gameplay shell.
- `ui/`: reusable HUD, dialogs, overlays, and controls.
- `tests/`: repeatable verification scenes and scripts.
- `docs/`: design, structure, workflow, and build documents.

Reusable scenes and their scripts should normally live together:

```text
components/targets/peg/
├── Peg.tscn
├── peg.gd
└── peg_config.gd
```

## 4. Application scenes

```text
scenes/
├── boot/
├── level_map/
├── gameplay/
├── result/
├── leaderboard/
└── settings/
```

### Boot

Loads configuration and save data, applies settings, initializes required services, prepares pending online work, and opens the progression map. Boot contains no gameplay rules.

### LevelMap

The vertically scrollable progression map is the normal home screen.

It:

- displays locked, available, completed, and updated levels;
- opens the selected level introduction when a level number is tapped;
- links to leaderboard and settings;
- displays relevant resources such as lives and tokens;
- scrolls toward the player’s current progression area.

A separate main menu is not required.

### Gameplay

Gameplay is a fixed shell that loads one selected level scene.

### Result

After completion:

- Next Level;
- Play Again;
- Return to Map.

After failure:

- Try Again;
- relevant life or power-up options;
- Return to Map.

### Leaderboard and Settings

Leaderboard presents the global RR ranking and future categories.

Settings can be opened from the progression map or pause menu. Opening it from pause must not resume gameplay.

## 5. Application-wide services

The initial autoload set should remain small:

```text
autoload/
├── scene_router.gd
├── save_manager.gd
├── audio_manager.gd
├── game_config.gd
└── online_service.gd
```

### SceneRouter

Changes application screens and carries only required transition context.

### SaveManager

Reads, validates, migrates, and safely writes local save data. Gameplay components must not write files directly.

### AudioManager

Owns music, sound effects, volume, mute state, and audio transitions.

### GameConfig

Provides centralized global values such as:

- zone scores;
- maximum lives;
- life regeneration interval;
- construction-series values;
- global power-up definitions;
- shared gameplay limits.

Values balanced globally must not be copied into individual levels.

### OnlineService

Owns leaderboard retrieval and submission, display-name updates, offline submission queue, and connection failure handling.

Ordinary gameplay must never wait for OnlineService.

A global event bus is not introduced by default. Explicit ownership and local Godot signals are easier to trace.

## 6. Gameplay shell

```text
Gameplay
├── GameSessionController
├── LevelLoader
├── CannonSystem
├── BallManager
├── AmmoController
├── ScoreController
├── ObjectiveController
├── PowerUpController
├── BonusPhaseController
├── GameplayHUD
├── OverlayLayer
└── ActiveLevel
```

Exact Godot node types will be selected during implementation. These responsibility boundaries are the locked part.

### GameSessionController

Coordinates one attempt: preparation, ordinary play, pause, restart, bonus transition, win, loss, and final result.

### LevelLoader

Resolves the selected catalog entry, loads and validates the level, instances it under `ActiveLevel`, and unloads it cleanly.

### CannonSystem

Owns rotation, angle limits, current direction, firing permission, aiming aids, and ordinary firing. It does not own score or active-ball lifetime.

### BallManager

Spawns ordinary and bonus cannonballs, tracks every ball belonging to the current shot, registers exits and catcher results, and determines when the full shot has ended.

### AmmoController

Owns starting ammunition, committed shots, returned balls, extra-ball rewards, and totals above the starting amount.

### ScoreController

Owns all scoring layers defined in `02_SCORING_AND_OBJECTIVES.md` and emits score events for presentation.

### ObjectiveController

Registers objectives, tracks progress, distinguishes bonus trigger from final evaluation, and reports objective state to the session and HUD.

### PowerUpController

Owns allowed types, level-supplied assistance, selected player-owned items, activation, consumption, and restart behavior.

### BonusPhaseController

Receives active cannonballs and remaining ammunition, runs the selected bonus model, and reports completion and score results.

### GameplayHUD

Displays state and sends player intentions to the owning controllers. It contains no scoring, ammunition, objective, life, or save rules.

## 7. Reusable components

```text
components/
├── balls/
├── cannon/
├── catchers/
├── targets/
│   ├── peg/
│   ├── block/
│   └── target_state/
├── obstacles/
├── objective_objects/
├── bonuses/
├── movement/
├── zones/
├── constructions/
└── effects/
```

Movement is reusable and separate from target identity. Initial movement types may include static, rotation, sliding, and circular movement.

A rotating three-hit block should combine block shape, target behavior, three-hit configuration, movement, zone membership, and optional construction membership. It should not require a unique hard-coded scene for every combination.

## 8. Level scene structure

Each level is a separate numbered Godot scene.

```text
Level
├── LevelConfiguration
├── Zone1
│   ├── Targets
│   ├── Solids
│   ├── Constructions
│   └── ObjectiveObjects
├── Zone2
├── Zone3
├── Zone4
├── BallCatcher
└── LevelPresentation
```

Zones are logical groups, not fixed horizontal screen bands. Moving elements retain the zone identity they were assigned in the editor.

## 9. Inspector configuration

The level root exposes grouped settings in the Godot Inspector.

### Level Identity

- level number;
- level pack;
- content version;
- draft or published state.

### Level Objectives

- mandatory requirements;
- bonus trigger;
- objective groups.

### Starting Ammunition

- ordinary starting cannonballs.

### Scoring and Ranking

- two-cup threshold;
- three-cup threshold;
- level-specific objective rewards.

Global zone values are not entered per level.

### Power-ups

- allowed or disabled types;
- free temporary assistance supplied per attempt.

There is no artificial quantity limit on allowed player-owned items.

### Ball Catcher

- enabled;
- configuration;
- standard or alternative reward.

### Bonus Phase

- selected model;
- model-specific values.

Normal level configuration must not require opening code.

## 10. LevelTemplate and ComponentGallery

`LevelTemplate.tscn` contains the required structure and sensible defaults. It does not contain one physical copy of every possible component.

A new level is created by duplicating the template.

`ComponentGallery.tscn` is a non-production visual catalog showing available pegs, blocks, target states, movements, objective objects, bonuses, catchers, and other building blocks.

The gallery helps the designer remember what exists without reading code.

## 11. Drafts and published packs

```text
levels/
├── templates/
│   ├── LevelTemplate.tscn
│   └── ComponentGallery.tscn
├── drafts/
└── published/
    ├── pack_01/
    ├── pack_02/
    └── ...
```

Drafts:

- are created in `levels/drafts/`;
- do not appear on the production map;
- are excluded from production exports;
- can be tested directly in Godot.

Published levels:

- move once into their final pack;
- use permanent numbered filenames;
- retain their identity and path;
- may be corrected or balanced;
- are never replaced by a different level using the same number.

## 12. Level packs and identity

The standard pack contains 25 levels:

```text
pack_01: level_001–level_025
pack_02: level_026–level_050
pack_03: level_051–level_075
```

Twenty-five is an organizational and release standard, not an engine limitation.

The first release contains at least 25 levels. Fifty is the preferred launch target. Later updates may add another pack of 25.

A published level has permanent `level_id` and integer `content_version`.

```text
level_id: 25
content_version: 1
```

A later correction becomes version 2 of level 25. The number is never reused for another level.

## 13. Level catalog

A central catalog defines:

- level ID;
- scene path;
- pack;
- content version;
- published state;
- progression order;
- optional release metadata.

LevelMap and LevelLoader read this catalog. They do not scan folders and guess level order.

Only published catalog entries appear in production.

## 14. Updated-level discovery

Local progress stores the last played content version for each level.

If the catalog version is newer:

- the map shows an Updated marker;
- historical best score and cup ranking remain;
- replaying clears the marker;
- a worse new result does not replace the historical best;
- a better result updates the record.

## 15. Local save model

Conceptually:

```text
SaveData
├── schema_version
├── profile
│   ├── install_id
│   └── display_name
├── progression
│   ├── highest_unlocked_level
│   └── level_results
├── resources
│   ├── lives
│   ├── next_life_timestamp
│   ├── tokens
│   └── inventory
├── settings
├── leaderboard
│   └── pending_submission
└── metadata
```

Each level result can store completion, best score, best cups, and last played content version.

SaveManager uses schema versions, validation, migrations, safe defaults, atomic writes where practical, and a recoverable previous valid save where practical.

## 16. Offline-first behavior

Level loading, physics, scoring, objectives, progression, lives, inventory, settings, and result storage work locally.

Online failure never blocks ordinary play.

When offline, only the newest valid leaderboard state needs to remain queued. An eight-hour offline session can therefore synchronize after reconnection without replaying every historical submission.

## 17. Leaderboard identity

Leaderboard participation is optional.

Without a display name:

- no leaderboard row is created;
- all ordinary gameplay remains available;
- scores remain local.

With a display name, the game creates a random local install ID.

The ID:

- is not a hardware ID;
- identifies the leaderboard row;
- allows the installation to update its entry;
- remains private.

The player can change display name without losing ranking.

Without account or cloud restore, full deletion or reinstall may create a new ID and lose the previous leaderboard identity. This is an accepted v1 limitation.

Display names use length and character rules plus local and server-side blocked-word validation.

## 18. Global RR ranking

The main list is fully global and has no minimum level requirement.

```text
RR rank points =
completed levels × (average cups per completed level)²
```

Equivalent:

```text
RR rank points =
total cups² ÷ completed levels
```

Examples:

| Levels | Cups | Average | RR points |
|---:|---:|---:|---:|
| 1 | 3 | 3.00 | 9 |
| 3 | 9 | 3.00 | 27 |
| 50 | 50 | 1.00 | 50 |
| 20 | 40 | 2.00 | 80 |
| 50 | 100 | 2.00 | 200 |
| 50 | 150 | 3.00 | 450 |

Full precision is used for sorting; display may use two decimals.

Tie-break order:

1. more completed levels;
2. higher exact cup average;
3. higher normalized score performance;
4. stable online-service tie-break.

Raw level scores are not directly comparable. Score tie-breaking is normalized against each level’s three-cup threshold.

Future categories, such as a First 10 Levels list, can be added without changing the global formula.

## 19. Dependency direction

```text
Application services
        ↓
Gameplay controllers
        ↓
Reusable components
        ↓
Level instances and configuration
```

Components emit explicit local signals such as:

- `target_hit`;
- `target_destroyed`;
- `ball_exited`;
- `ball_caught`;
- `objective_completed`;
- `shot_ended`.

A target must not directly save data, navigate, submit leaderboard results, deduct lives, or unlock levels.

## 20. Naming standards

- Files and folders: lowercase `snake_case`.
- Godot classes and named nodes: `PascalCase`.
- Variables and functions: `snake_case`.
- Signals: clear past-tense events where practical.

Examples:

```text
level_001.tscn
score_controller.gd
ScoreController
starting_ammo
register_target_hit()
target_destroyed
```

## 21. Intentionally avoided

The project does not begin with:

- a separate standalone level-editor application;
- a large global event bus;
- duplicated controllers inside each level;
- scattered hard-coded level lists;
- manual ordinary point values on every target;
- one script containing the whole game;
- an enterprise-style framework;
- online dependencies inside ordinary gameplay;
- direct save writes from components;
- unique code for every target, hit-count, and movement combination.

## 22. Structural implementation order

1. folders and naming;
2. Boot and LevelMap shell;
3. SaveManager and save schema;
4. Gameplay shell and session states;
5. LevelTemplate and LevelLoader;
6. CannonSystem and BallManager;
7. ammunition, catcher, and shot completion;
8. reusable targets and solids;
9. zones and scoring;
10. objectives;
11. bonus phase;
12. power-ups;
13. results and progression;
14. leaderboard and offline queue;
15. presentation and level production.

The detailed gates belong in `06_BUILD_PLAN.md`.

## 23. Success condition

The structure succeeds when:

- Tony can locate the relevant area after time away;
- a level can be created from the template without code;
- a new component can be added centrally;
- published levels do not require manual rewrites after global improvements;
- drafts cannot appear accidentally in production;
- long offline play is safe;
- leaderboard failure cannot break gameplay;
- every major system has one understandable owner.
