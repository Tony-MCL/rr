# Ricochet Rush – Level Design

**Document status:** Approved v1 level-design direction  
**Purpose:** Provide a practical workflow and shared design principles for building, testing, organizing, and publishing Ricochet Rush levels.

This is a working handbook, not a bureaucracy. It should help level creation remain consistent without turning design sessions into paperwork.

## 1. Level-design goal

A Ricochet Rush level should create a satisfying mixture of:

- readable aiming choices;
- lively and surprising physics;
- skill;
- planning;
- controlled luck;
- useful ricochet paths;
- visible progress;
- the temptation to try one more time.

A level does not need one perfect solution. It should provide enough structure that good aiming matters while leaving room for unexpected outcomes.

## 2. Level-building environment

Godot itself is the v1 level editor.

The designer works by:

1. duplicating `LevelTemplate.tscn`;
2. saving the new level in `levels/drafts/`;
3. selecting level settings in the Inspector;
4. dragging reusable components into the scene;
5. assigning zones, constructions, roles, movement, and bonuses;
6. testing the current scene;
7. adjusting layout, ammunition, objectives, and thresholds;
8. publishing the level into its permanent pack when ready.

Normal level creation must not require editing code.

## 3. Standard pack structure

A standard level pack contains 25 levels.

The first release contains at least 25 levels. Fifty levels, or two complete packs, is the preferred launch target.

Later updates may naturally add another group of approximately 25 levels.

Twenty-five is an organizational and release standard, not a technical restriction.

## 4. First-pack progression

The first 25 levels are planned as five informal groups.

| Levels | Main purpose |
|---|---|
| 1–5 | Aiming, shooting, ricochets, normal targets, blocks, and ball catcher |
| 6–10 | Logical zones, three-hit targets, and simple construction series |
| 11–15 | Curved blocks, small and large wheels, and more advanced angles |
| 16–20 | Objective targets, Extra Ball, and Double Score |
| 21–25 | Combined objectives, selected moving constructions, and mastery |

The player sees one continuous progression path. The five groups are an internal planning tool, not separate menu chapters.

## 5. Teaching rhythm

A useful introduction rhythm is:

```text
Learn → Practice → Vary → Challenge → Combine
```

A new primary mechanic should normally be introduced by itself or with already familiar mechanics.

The player should have several opportunities to use a mechanic before another major rule is added.

Later levels combine known elements rather than constantly introducing new ones.

## 6. Level 1

Level 1 should be very easy without looking childish or empty.

It must remain technically possible to lose.

It can feel forgiving through:

- generous starting ammunition;
- several reasonable firing angles;
- natural target groups;
- no moving targets;
- no three-hit targets;
- a simple objective;
- the standard ball catcher;
- no required player-owned power-ups.

The player learns by playing.

Before the first shot, a short instruction may say:

> Drag to aim. Tap to fire.

The first cannonball receives a free improved aiming aid showing a long line and first ricochet.

The ball catcher is present from level 1. Its behavior can be explained briefly when it first returns a cannonball rather than through a long introduction.

## 7. Tutorial messages

Tutorial messages should:

- appear only when a mechanic first matters;
- be short;
- avoid long blocking explanations;
- let the player try the mechanic in actual play;
- disappear permanently after being understood where appropriate;
- remain available through help or settings if later needed.

A tutorial should explain the player’s immediate action, not the internal scoring architecture.

## 8. Level 25

Level 25 is harder than the surrounding levels and tests the player’s use of familiar systems.

It:

- combines known mechanics;
- requires better ammunition use;
- may use more demanding angles or movement;
- introduces no completely new core mechanic;
- does not require boss presentation;
- connects naturally to level 26 when the next pack is available.

The next 25 levels should ideally be ready before most players reach level 25, but the level itself must still feel complete.

## 9. Intended attempt duration

A correctly played ordinary level should generally be completable in approximately two to three minutes.

A demanding level may take approximately five minutes for one successful attempt.

This is not a limit on how long the player may spend trying. A player may reasonably spend much longer through repeated failures, experimentation, and replay.

Avoid levels that become mechanically slow after the interesting challenge has already been solved.

## 10. Difficulty curve

Difficulty is not strictly linear.

Levels 1–10 provide a more controlled introduction.

From approximately levels 10–15, difficulty may vary more deliberately.

Example:

```text
Medium → Hard → Easier → Medium → Hard
```

Easier levels provide:

- relief after difficult levels;
- renewed progress;
- confidence;
- opportunities to chase three cups;
- variety.

Unexpectedly hard levels may appear among moderate levels. Some frustration is acceptable in this genre.

The goal is not to prevent every player from becoming stuck. The goal is to avoid an unreasonable permanent wall.

## 11. Internal difficulty label

Each level may use a simple internal label:

- Easy;
- Medium;
- Hard.

The label:

- is assigned initially by the designer;
- may be discussed and adjusted during testing;
- helps plan the sequence;
- does not need to be visible to players;
- is not a mathematical guarantee.

The label can change later if player behavior shows that the initial judgment was wrong.

## 12. Skill and luck

Ricochet Rush deliberately includes luck.

A good level may contain:

- uncertain secondary ricochets;
- unexpected target chains;
- lucky catcher entries;
- fortunate bonus activations;
- near misses;
- occasional spectacular outcomes.

The designer does not need to eliminate luck.

The player should still influence the outcome through:

- cannon angle;
- target selection;
- understanding of structures;
- timing against movement;
- power-up choices;
- risk and reward decisions.

A level can be frustrating and still be valid. It should be adjusted if a clearly excessive share of players cannot progress.

## 13. Deterministic moving elements

Moving elements begin every attempt with the same:

- position;
- direction;
- phase;
- speed.

This makes a moving level learnable.

Movement is not randomly re-seeded on every restart unless a future mechanic explicitly introduces visible randomness.

## 14. Movement frequency

Movement is variation, not the foundation of every level.

For pack 1:

- approximately one in three to one in five levels may use moving elements;
- static level design remains the majority;
- movement should become more frequent only after the player understands the basic physics.

From level 25 onward, moving parts may appear more often.

Static, slide, rotation, and circular/orbit movement should provide sufficient variety well into the first hundred levels.

## 15. Ball catcher consistency

The standard ball catcher is present from level 1 and keeps the same basic:

- width;
- speed;
- movement pattern;
- +1 cannonball reward.

The designer may disable it on selected levels.

The first pack should not use tiny hidden changes in catcher speed or width as a difficulty tool. Future visible catcher variants may be introduced as new mechanics.

## 16. Standard geometry

Normal level production uses the standard component sizes defined in `04_COMPONENTS.md`.

Working baseline:

| Component | Size |
|---|---:|
| Cannonball | approximately 40 px diameter |
| Peg | approximately 45 px diameter |
| Straight block | approximately 50 × 30 px |
| Curved blocks | standardized to the same block family |

Free scaling is not the normal design method.

Variation comes from arrangement, rotation, roles, hit count, movement, zones, bonuses, and objectives.

## 17. Building with blocks

Blocks are used to create playable structures such as:

- rows;
- channels;
- ramps;
- curves;
- wheels;
- spirals;
- paths;
- barriers;
- mixed constructions.

Straight and curved modules should connect through standard snap points.

The designer may turn snapping off for deliberate free placement.

Connected geometry must be checked for collision gaps or edges that produce unintended ball behavior.

## 18. Wheels

Wheels are built from standardized curved blocks under a ConstructionGroup.

A wheel may be:

- static;
- rotating;
- sliding;
- rotating while the complete wheel slides.

Small and large curve radii provide different wheel sizes and path options.

A wheel does not need movement to be a useful level element.

## 19. Peg use

Pegs are naturally suited to:

- standalone targets;
- patterns;
- rows;
- target clouds;
- pure peg series;
- moving groups;
- objective targets;
- bonus targets.

Individual pegs do not need own-axis rotation.

They may slide, orbit, or move as children of a rotating group.

## 20. Logical zones

Zones are logical groups and do not need to match fixed horizontal screen bands.

The designer assigns a target or construction to Zone 1–4.

A moving target retains its zone identity wherever it travels.

Use zones to organize meaningful structures rather than scattering different values without a clear reason.

Global zone values remain centralized and are not manually entered on each target.

## 21. Construction groups

A ConstructionGroup identifies blocks that form one deliberate playable structure.

Use groups when:

- blocks should participate in one construction series;
- several blocks share movement;
- a common pivot is required;
- the editor hierarchy benefits from clear ownership.

Do not place unrelated nearby blocks in the same ConstructionGroup merely for convenience.

## 22. Target and solid roles

Every peg and block has a clear role.

### Target

- awards points;
- can require one or three hits;
- may count toward objectives;
- enters destroyed state after its final hit;
- disappears after the configured delay.

### Solid

- shapes the ball path;
- awards no ordinary points;
- takes no ordinary target damage;
- never counts toward target objectives.

Solid elements can make a level more difficult but should remain visually distinct from targets.

## 23. V1 objective types

V1 level objectives are limited to:

- score threshold;
- destroy a configured number of targets;
- destroy designated Objective targets;
- clear all ordinary targets;
- combinations using AND.

Solid elements never count.

Physical objective objects such as eggs and marbles are postponed until after v1.

The architecture remains open to them later.

## 24. Combined objectives

Combined objectives should create interesting tension, not duplicate the same requirement.

Example:

- destroy all objective targets;
- reach a score threshold.

The gameplay objective triggers bonus phase even when the score requirement has not yet been reached. Bonus scoring may complete the score requirement.

Use combined objectives only after the player understands each part separately.

## 25. Bonus targets

V1 supports two bonus functions on standard pegs and blocks.

### Extra Ball

Awards one additional cannonball.

Use it to:

- reward an intentional risky path;
- give the player recovery potential;
- create ammunition growth through a strong shot;
- add a secondary target choice.

### Double Score

Doubles the shot-wide score multiplier, including the activating hit.

Repeated activations stack ×2, ×4, ×8, and onward until the shot ends or bonus phase begins.

Use Double Score to:

- invite risky routing;
- create score-objective opportunities;
- reward long active shots;
- support memorable high-score moments.

Bonus targets need clear color, symbol, and feedback.

## 26. Starting ammunition

Starting ammunition is set per level.

There is no fixed universal count.

Balance ammunition against:

- objective size;
- number of targets;
- multi-hit requirements;
- expected catcher opportunities;
- Extra Ball targets;
- movement;
- expected duration;
- intended difficulty.

An ordinary level should be designed to be completable without player-owned power-ups.

This is a design requirement, not a paperwork requirement.

## 27. Level-supplied assistance

A level may provide temporary free assistance.

Examples:

- one improved aiming aid for the first shot;
- several basic aiming aids during introductory levels;
- temporary extra ammunition for a teaching setup.

Free level assistance:

- belongs only to the attempt;
- regenerates on restart;
- cannot be carried to another level.

Use free assistance to teach or support a design idea, not to hide a poorly balanced level.

## 28. Player-owned power-ups

V1 player-owned options include:

- basic aiming aid;
- improved aiming aid;
- pre-level extra ammunition.

A level may allow or disable a type.

If a type is allowed, there is no artificial per-level usage limit on the player’s owned supply.

Power-ups should make a level easier or more controllable. They must not be the only realistic path through an ordinary level.

## 29. Coffee-cup ranking

Each completed level stores one to three coffee cups.

The current broad model is:

- one cup for completing the mandatory level objective;
- two cups for reaching a higher score threshold;
- three cups for reaching the top score threshold.

Exact balancing philosophy and thresholds remain open for playtesting.

Thresholds are configured per level because levels have different scoring potential.

Do not finalize cup thresholds before the level’s ordinary score range has been tested.

## 30. Level layout checks

During design, visually check that:

- the cannon has useful aiming space;
- important targets are not hidden behind UI;
- targets are not placed outside the intended playfield;
- the bottom exit remains functional;
- the ball catcher has a clear path;
- moving elements remain within safe bounds;
- connected blocks do not create unintended gaps;
- a destroyed target cannot trap the ball permanently;
- objective targets are visually recognizable;
- the level can be understood without reading code or node names.

## 31. Draft workflow

A practical level workflow is:

1. duplicate LevelTemplate;
2. save in `levels/drafts/`;
3. choose a provisional level number;
4. set objective and starting ammunition;
5. build the main layout;
6. assign target, solid, zone, and construction roles;
7. add movement only if it improves the idea;
8. add bonuses;
9. play the level;
10. adjust the obvious problems;
11. set preliminary cup thresholds;
12. mark ready when it feels complete.

There is no requirement to perfect every numerical value before the level becomes useful for broader testing.

## 32. Lightweight test note

Testing should create useful memory, not administrative work.

A short entry may contain:

```text
Level 017
Status: Playable
Difficulty: Medium
Completed without owned power-ups: Yes
Starting balls: 12
Balls remaining: 2
Score: 18,450
Note: Large wheel may rotate slightly too fast
```

Where practical, the game should fill numerical values automatically after a test run.

The designer adds a comment only when something is worth remembering.

## 33. Minimum pre-publication test

Before publication, a level should have:

- at least one successful completion;
- one successful completion without player-owned power-ups;
- correct objective behavior;
- correct win and loss behavior;
- no known blocking physics fault;
- sensible starting ammunition;
- a provisional difficulty label;
- working cup thresholds;
- a final permanent level number.

One successful run may satisfy several of these points.

The designer is not required to complete every level repeatedly unless a concrete issue needs further testing.

## 34. Publishing workflow

When a draft is ready:

1. assign permanent `level_id`;
2. set `content_version: 1`;
3. move it to the correct `published/pack_xx/` folder;
4. add it to the level catalog;
5. verify it appears correctly on the progression map;
6. verify it is included in production export;
7. retain any useful test note.

After publication, the level number and identity are permanent.

## 35. Updating a published level

A published level may be adjusted when:

- a physics fault is found;
- objective behavior is wrong;
- a clearly excessive number of players appears stuck;
- scoring thresholds are unreasonable;
- the level has another concrete balance problem.

An update:

- keeps the same level ID and filename;
- increases `content_version`;
- preserves historical best results;
- marks the level Updated on the player’s map;
- invites replay without forcing it.

Possible small adjustments include:

- adding one starting cannonball;
- moving targets;
- changing objective count;
- changing movement speed;
- correcting cup thresholds.

Do not redesign a published level into an unrelated new level under the same number.

## 36. Post-release adjustment philosophy

Some frustration is acceptable.

Do not weaken a level because a few players fail or complain.

Consider adjustment when evidence suggests a disproportionate progression barrier.

Evidence may come from:

- repeated player feedback;
- observed testing;
- support messages;
- later aggregated completion statistics if implemented.

The first response should be a small targeted change, not a complete redesign.

## 37. Level-design anti-patterns

Avoid:

- requiring a paid or earned power-up to progress;
- introducing several unknown mechanics at once;
- using movement on every level;
- hiding objectives visually;
- creating accidental collision gaps;
- changing ball-catcher behavior invisibly;
- making every level harder than the previous one;
- filling the screen merely to make it look difficult;
- creating a long cleanup phase after the challenge is already over;
- balancing around one extremely lucky test run;
- turning test notes into a large reporting system.

## 38. Practical success condition

The level-design system succeeds when Tony can:

- make coffee;
- duplicate the template;
- choose components from the gallery;
- construct a level visually;
- configure it through Inspector;
- test it immediately;
- make useful adjustments;
- publish it without writing code;
- understand the same level again months later.
