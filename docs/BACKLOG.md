# Ricochet Rush – Backlog

**Document status:** Active backlog  
**Purpose:** Preserve ideas and unresolved future choices without interrupting the active build phase.

An item in this file is not automatically approved scope.

## 1. Backlog rules

For every new idea:

- record the idea briefly;
- state why it may be useful;
- identify the earliest relevant phase;
- distinguish required open decisions from future expansion;
- do not implement it during an unrelated work unit.

## 2. Required decisions before relevant phases

### First bonus-phase model

**Needed before:** Phase 7  
Choose the original RR model for converting active and remaining cannonballs into the closing bonus sequence. Architecture supports several models, but v1 needs one concrete model.

### Coffee-cup balancing

**Needed before:** Phase 11  
Decide practical one-, two-, and three-cup thresholds after real score ranges exist. The coffee-cup visual name may remain or be replaced.

### Extra-ammunition item value

**Needed before:** Phase 8  
Balance whether one inventory item grants +1 or +3 starting cannonballs.

### Pure and mixed target-series values

**Needed before:** Phase 6  
Define thresholds and rewards. Pure peg-only or block-only series should reward more than mixed peg-and-block series.

### Long Shot detector

**Needed before:** Phase 6  
Define reliable geometry and final reward for Long Shot.

### Multi-target achievement names and values

**Needed before:** Phase 6 or presentation phase  
Define thresholds, names, and rewards for exceptional one-shot target performance.

### Monetization values

**Needed before:** Phase 9  
Set token earning, token pricing, power-up costs, rewarded-ad limits, purchase products, and ad placement.

## 3. Post-v1 objective objects

### Breakable objects

Examples: eggs requiring several hits.

### Pushable objects

Examples: marbles that must leave through the bottom or reach an area.

### Trapped objects

Remove supporting targets, then guide or release the object.

### Combined physical objectives

Free an object and then move it to an exit.

These require new objective components but should fit the existing ObjectiveController.

## 4. Future cannonballs and power-ups

- Super Ball;
- larger cannonball;
- penetrating cannonball;
- explosive cannonball;
- cannon multishot;
- other special-ball behaviors discovered through real playtesting.

Do not define these fully before the ordinary level system reveals what help is genuinely fun.

## 5. Future target mechanics

- targets requiring five or more hits;
- additional bonus rewards;
- additional curve radii;
- specialized objective-target appearances;
- magnetic pegs or blocks that guide a ball around their outer edge before release;
- reversible magnetic direction on later contact;
- other deliberately introduced target types.

## 6. Future catcher mechanics

- alternative catcher rewards;
- different catcher shapes;
- visible special catcher behavior;
- temporary catcher upgrades.

Pack 1 uses the consistent standard +1 catcher.

## 7. Future movement

- path-following movement;
- linked mechanical movement;
- pendulum behavior;
- more advanced easing;
- randomized movement as an explicit visible mechanic;
- additional orbit variants.

Do not add movement merely to make the component list larger.

## 8. Future bonus phases

- additional closing bonus models;
- different bonus exits;
- level-specific bonus layouts;
- special pack-ending bonus sequences;
- future bonus models based on remaining ammunition or targets.

## 9. Future progression presentation

- separate islands;
- water or sky environments;
- themed visual regions;
- pack-specific progression art;
- special transitions between packs.

The v1 architecture uses one scrollable path and can theme sections later.

## 10. Future leaderboards

- First 10 Levels category;
- per-pack leaderboard;
- limited-time event leaderboard;
- seasonal categories;
- selected per-level challenges.

Global RR Rank remains primary.

## 11. Future account and restore options

- optional account;
- cloud progress backup;
- cross-device restore;
- leaderboard identity recovery after reinstall;
- migration of anonymous install identity into an account.

V1 remains local-first without registration.

## 12. Future level-editor improvements

- custom Godot editor plugin;
- specialized component palette;
- stronger visual snapping tools;
- automated level validation;
- richer automatic playtest logs;
- separate standalone level editor only if Godot proves insufficient.

## 13. Future content

- pack 2: levels 26–50;
- further packs in groups of approximately 25;
- new thematic regions;
- new objective families;
- later mechanic-introduction plans;
- additional BOP presentation and animations.

## 14. Analytics and balancing

Possible later aggregated measurements:

- attempts per level;
- completion rate;
- average remaining ammunition;
- average score;
- common progression blockers;
- power-up usage.

Any analytics must be proportionate, privacy-conscious, and unable to block offline play.

## 15. Parked design alternatives

### OR objectives

V1 mandatory requirements use AND. OR-based alternatives may be considered later if they create worthwhile level choices.

### Custom per-level zone values

Rejected for v1 in favor of global linked values. Reconsider only if real level design exposes a strong need.

### Variable pack size

Standard is 25, but the engine must not enforce it as a hard limit.

### Separate main menu

Not needed in v1 because LevelMap is the home screen. Reconsider only if later product structure requires it.
