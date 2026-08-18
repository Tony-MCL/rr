# Ricochet Rush – Phase 3 Verification

**Phase:** 3 – Level framework  
**Status:** Verified complete  
**Date:** 2026-08-18

## Scope verified

Phase 3 established the reusable level-loading framework on top of the verified Phase 2 gameplay shell.

Implemented and verified:

- `LevelConfiguration` resource for level identity and starting ammunition;
- `LevelTemplate.tscn` with the approved zone/content hierarchy;
- `LevelLoader` under the fixed Gameplay shell;
- central `LevelCatalog` and `LevelCatalogEntry` resource types;
- tracked `levels/templates/`, `levels/drafts/`, and `levels/published/pack_01/` structure;
- two temporary draft test levels with different IDs and starting ammunition values;
- loading selected levels by catalog ID;
- validation of required level metadata and catalog consistency;
- safe unload/switch behavior without overlapping level instances;
- level-controlled starting ammunition applied to `AmmoController`;
- grouped Inspector configuration for identity and gameplay settings;
- production export exclusion for `levels/drafts/*`;
- Godot script UID files tracked for all Phase 3 scripts.

## Desktop verification

Verified in Godot on Windows.

Observed behavior:

- Gameplay loads catalog level ID 1 automatically;
- level 1 configuration is read successfully;
- level 1 starting ammunition overrides the temporary Gameplay default and becomes 4;
- Phase 2 firing, wall bounce, bottom exit, catcher, ammunition return, and shot lifecycle continue to work after level loading;
- no controller duplication was observed when levels changed;
- both temporary levels use the same fixed Gameplay shell;
- `tests/phase_3/level_switch_test.tscn` successfully switched `1 → 2 → 1`;
- the level-switch verification confirmed exactly one child under `ActiveLevel` after each load;
- the repeatable switch test ended with `PHASE 3 LEVEL SWITCH TEST: PASS`;
- invalid or missing level metadata is rejected with explicit `LEVEL LOAD FAILED` errors;
- the final desktop checkpoint completed without functional errors or warnings.

## Test level configuration

Temporary development levels:

- level ID 1: `res://levels/drafts/test_level_001.tscn`, starting ammunition 4;
- level ID 2: `res://levels/drafts/test_level_002.tscn`, starting ammunition 7.

Both remain drafts and are not production content.

## Catalog and loading behavior

The central catalog is the authoritative source for level lookup.

`LevelLoader` resolves a level through:

```text
level_id → LevelCatalog → scene_path → PackedScene → ActiveLevel
```

The loader does not scan folders or infer filenames.

Before a catalog-selected level becomes active, the framework verifies that its configuration agrees with the catalog entry for:

- level ID;
- level pack;
- content version;
- published state.

The previous active level is removed before the next instance is added, preventing overlapping level instances while preserving Gameplay-owned controllers.

## Inspector workflow

The level configuration currently exposes the Phase 3 settings needed for ordinary level setup:

### Identity

- Level Id;
- Level Pack;
- Content Version;
- Is Published.

### Gameplay

- Starting Ammunition.

Later-phase objective, scoring, power-up, catcher, and bonus settings remain intentionally outside the current implementation.

## Draft export boundary

The Android export preset excludes:

```text
levels/drafts/*
```

Draft scenes remain available for direct development and editor testing, but are not intended to ship as production content.

No Android runtime checkpoint was required for Phase 3 itself. The build plan reserves the next required mobile checkpoint for the first complete playable level loop; Phase 3 provides the loading framework but does not yet include the target/objective systems required for that loop.

## Phase boundary

Not implemented in Phase 3:

- production target geometry;
- target hit or destruction behavior;
- scoring;
- objectives;
- progression map;
- production level content;
- result flow;
- permanent progression or save behavior.

These remain owned by later phases according to `06_BUILD_PLAN.md`.

## Verification result

Phase 3 is verified complete on desktop. A new level can now be duplicated from `LevelTemplate.tscn`, configured without gameplay code, registered in the central catalog, loaded into the fixed Gameplay shell, validated, unloaded, and switched safely. The framework is ready to support Phase 4 standard target geometry.
