# Ricochet Rush – Component Catalog

**Document status:** Approved v1 component scope  
**Purpose:** Define the reusable Godot building blocks required for the first production version and separate them from later expansion ideas.

## 1. Component principles

Ricochet Rush should produce many levels from a small, consistent construction kit.

Components should:

- use standard dimensions;
- expose normal design choices in the Godot Inspector;
- combine behavior instead of duplicating scenes;
- work with the LevelTemplate;
- remain visually distinguishable by role;
- be usable without code changes;
- support future additions without rewriting published levels.

A new combination should normally be created through configuration.

Example:

```text
Curved block
+ Target
+ Three hits
+ Zone 3
+ Extra Ball
+ Rotation
```

This should not require a unique hard-coded component.

## 2. V1 scope summary

The v1 component set includes:

- Cannon;
- Cannonball;
- side walls and bottom exit;
- standard ball catcher;
- Peg;
- StraightBlock;
- CurvedBlockSmall;
- CurvedBlockLarge;
- Target and Solid roles;
- Normal and Objective target roles;
- one-hit and three-hit targets;
- Extra Ball bonus;
- Double Score bonus;
- logical Zone 1–4;
- ConstructionGroup;
- snap and connection points;
- static, slide, rotation, and circular/orbit movement;
- basic aiming aid;
- improved aiming aid;
- pre-level extra-ammunition power-up;
- lives system;
- generic bonus-phase framework.

Physical objective objects and special cannonballs are postponed until after v1.

## 3. Standard working dimensions

The current production baseline is:

| Component | Working size |
|---|---:|
| Cannonball | approximately 40 px diameter |
| Peg | approximately 45 px diameter |
| Straight block | approximately 50 × 30 px |
| Curved blocks | same family thickness and modular scale as straight blocks |

These values are working dimensions. They are locked only after the production physics foundation is tested.

Normal level design should use standard sizes rather than freely scaling individual targets.

## 4. Cannon

### Purpose

The Cannon component provides the fixed top-mounted firing point.

### V1 behavior

- fixed anchor at the top of the portrait playfield;
- rotates approximately 80–85 degrees to each side of vertical;
- never aims upward;
- never moves sideways;
- remains rotatable while a shot is active;
- retains its current angle after a shot;
- fires only when BallManager permits a new ordinary shot.

### Inspector configuration

Only values genuinely useful during global testing should be exposed, including:

- angle limit;
- rotation sensitivity;
- muzzle position;
- firing speed reference where ownership is appropriate.

Normal levels should not override core cannon behavior unless a future mechanic explicitly requires it.

## 5. Cannonball

### Purpose

The Cannonball is the physical projectile used by ordinary shots and bonus-ball spawning.

### V1 behavior

- standard diameter;
- physics-driven movement;
- controlled bounce behavior;
- belongs to one active shot;
- reports target collisions;
- reports bottom exit;
- reports catcher entry;
- cannot be controlled after firing.

Bonus cannonballs use the same base component and spawn at the bonus trigger point.

### Required runtime state

- shot ID;
- active or exiting state;
- contribution to shot-wide bonuses;
- protection against duplicate persistent-contact hits.

## 6. Walls and bottom exit

### Side and top boundaries

Boundaries keep cannonballs inside the intended playfield and use consistent collision behavior.

### Bottom exit

The bottom exit detects when a cannonball has left ordinary play.

It:

- reports the exiting ball to BallManager;
- does not decide win or loss directly;
- does not load the next ball directly;
- remains separate from the ball catcher.

## 7. Ball catcher

### V1 role

The ball catcher is a moving bottom component that returns one cannonball to ammunition for each ball caught.

### Rules

- standard reward is exactly +1 cannonball;
- each caught active ball awards separately;
- ammunition may exceed starting ammunition;
- it is normally available;
- the level designer may disable it;
- alternative rewards are structurally possible but not implemented in v1.

### Inspector configuration

- enabled;
- movement range;
- movement speed;
- starting direction or phase;
- standard catcher reward.

## 8. Peg

### Geometry

- standard round shape;
- standard diameter;
- no ordinary free scaling;
- own-axis rotation is unnecessary because the shape is circular.

### Available physical roles

- Target;
- Solid.

### Available target roles

- Normal;
- Objective.

### Hit configuration

- one hit;
- three hits.

### Bonus configuration

- none;
- Extra Ball;
- Double Score.

### Movement compatibility

- Static;
- Slide;
- Circular/orbit;
- movement as part of a rotating parent group.

A peg does not need an individual own-axis rotation option.

## 9. StraightBlock

### Geometry

- standard width and height;
- rotatable in the level editor;
- standard connection points;
- designed to combine with other blocks.

### Roles and behavior

StraightBlock supports the same physical, target, hit, zone, objective, bonus, and movement configuration as Peg where geometrically meaningful.

### Movement compatibility

- Static;
- Slide;
- Rotate;
- Circular/orbit;
- combined group movement.

## 10. CurvedBlockSmall

### Purpose

Provides the smaller-radius curved module used for:

- tight curves;
- small wheels;
- compact channels;
- curved target paths.

### Requirements

- same family thickness as StraightBlock;
- standard modular size;
- connection points compatible with the construction system;
- target and solid roles;
- one-hit and three-hit behavior;
- normal and objective roles;
- Extra Ball and Double Score bonuses;
- movement through own or parent configuration.

Exact radius and arc angle are selected during geometry testing.

## 11. CurvedBlockLarge

### Purpose

Provides the larger-radius curved module used for:

- wide curves;
- large wheels;
- broad channels;
- large rotating or static constructions.

It follows the same behavior rules as CurvedBlockSmall but uses a different standardized curvature.

Two standardized curvatures create many possible wheel and path combinations without freeform geometry.

## 12. Snap and connection points

Straight and curved blocks use explicit editor connection points.

Connection points should provide:

- start and end anchors;
- correct orientation;
- optional center reference;
- consistent modular placement;
- minimal physical gaps.

Snapping must be helpful but not trap the designer. Manual placement remains possible when intentional.

The production physics test must verify that connected pieces do not create unintended collision gaps or edges.

## 13. Physical role configuration

Instead of many unique scenes, standard shapes expose a Physical Role field.

### Target

A Target:

- awards ordinary score;
- may take one or three hits;
- may count toward objectives;
- enters destroyed state after the final hit;
- stops scoring immediately;
- remains physical during removal delay;
- disappears after the delay.

### Solid

A Solid:

- awards no ordinary score;
- takes no target damage;
- does not count toward target objectives;
- does not disappear;
- exists to shape ball movement and difficulty.

## 14. Target role configuration

Target role is separate from physical shape.

### Normal

Participates in ordinary target scoring and applicable general objectives.

### Objective

Carries the designated objective identity used by levels such as:

- destroy all objective targets;
- destroy a configured number of objective targets.

Both pegs and all block shapes can be Objective targets.

Visual identity is applied through color, symbol, effects, or a combination decided during presentation design.

## 15. Hit-count configuration

V1 supports:

- one-hit target;
- three-hit target.

### One hit

Awards ordinary zone value and is destroyed by the first valid hit.

### Three hits

Awards ordinary zone value for hits one and two, then ten times the zone value for the destroying third hit.

Both pegs and blocks may use either count.

Targets requiring five or more hits are not part of v1.

## 16. Bonus role configuration

Bonus behavior is layered onto a standard target shape.

V1 bonus types are:

- None;
- Extra Ball;
- Double Score.

A bonus target uses the same standard geometry and receives a distinct color, symbol, effect, or combination so the function is readable.

## 17. Extra Ball bonus

When a valid target event activates Extra Ball:

- AmmoController adds one cannonball;
- ammunition may exceed starting amount;
- the reward is preserved into bonus phase;
- the target still follows its configured target and destruction rules.

Extra Ball is available on Peg, StraightBlock, CurvedBlockSmall, and CurvedBlockLarge.

The exact activation condition is defined by the bonus configuration, with destruction as the normal readable default unless later testing justifies hit activation.

## 18. Double Score bonus

Double Score is a shot-wide multiplier.

### Activation

When any active cannonball validly hits a Double Score target:

- the activation hit is included in the doubled score;
- the current shot multiplier doubles;
- all active balls in the shot use the multiplier;
- later bonus balls spawned into the same shot inherit it.

### Stacking

| Double Score targets activated in one shot | Multiplier |
|---:|---:|
| 0 | ×1 |
| 1 | ×2 |
| 2 | ×4 |
| 3 | ×8 |
| 4 | ×16 |

Each activation doubles the existing shot multiplier.

### Included scoring

During ordinary play it applies to:

- ordinary target hits;
- multi-hit destruction score;
- construction-series points;
- construction milestones;
- pure and mixed target-series points;
- Long Shot;
- other shot-based skill bonuses.

### Excluded scoring

It does not multiply:

- bonus-phase score;
- level-completion bonus;
- coffee cups;
- lives;
- tokens;
- ammunition.

### Lifetime

The multiplier:

- belongs to the current shot;
- resets when every ball from the shot has exited;
- does not follow a caught ball into a new shot;
- ends when the level’s bonus trigger is reached;
- does not carry into bonus phase.

If the activation hit also triggers bonus phase, that hit is doubled before ordinary scoring ends.

## 19. Logical Zone

Each level supports Zone 1–4.

A Zone:

- is a logical group, not a fixed screen band;
- carries the global scoring identity;
- allows child targets to inherit value;
- keeps its identity when children move;
- prevents repeated point configuration on individual targets.

Global working values remain 10, 20, 30, and 40.

## 20. ConstructionGroup

ConstructionGroup explicitly identifies blocks belonging to one playable construction.

It supports:

- series tracking;
- shared movement;
- shared pivot;
- wheel construction;
- nested movement;
- clear editor organization.

Nearby unrelated blocks do not become one series accidentally.

## 21. Wheels and grouped movement

A wheel is assembled from standardized curved blocks under a common group.

```text
MovementParent
└── WheelConstruction
    ├── CurvedBlock
    ├── CurvedBlock
    ├── CurvedBlock
    └── CurvedBlock
```

A wheel can be:

- static;
- rotating;
- sliding without rotation;
- rotating while the whole wheel slides.

Rotation and translation must therefore be composable rather than mutually exclusive.

## 22. Movement components

### Static

Default. No automatic movement.

### Slide

Moves a component or group between configured endpoints.

Inspector values may include:

- direction or endpoint positions;
- distance;
- speed;
- start phase;
- easing or turnaround behavior where needed.

### Rotation

Rotates a non-round component or group around a configured pivot.

Inspector values may include:

- speed;
- direction;
- pivot;
- initial angle.

### Circular/orbit

Moves a component or group around a center point.

One reusable orbit model is sufficient for v1.

Inspector values may include:

- center or radius;
- angular speed;
- direction;
- start phase.

Circular/orbit movement must be verified in the production foundation; the prototype did not complete that verification.

## 23. Movement usage in level design

Movement is variation, not a requirement for every level.

Initial guidance:

- approximately one in three to one in five levels in pack 1 may use movement;
- static design remains the foundation;
- movement may become more frequent from level 25 onward;
- the initial movement set should support well into the first hundred levels.

This is level-design guidance, not a hard engine rule.

## 24. Basic aiming aid

The basic aiming aid:

- shows the initial firing direction;
- applies to one shot;
- is consumed when the shot is fired;
- can be supplied temporarily by a level;
- can exist in player inventory.

## 25. Improved aiming aid

The improved aiming aid:

- shows a longer path;
- shows at least the first predicted ricochet;
- applies to one shot;
- is consumed when fired;
- may be supplied by a level or owned by the player.

The preview is guidance and not a guarantee.

## 26. Extra-ammunition power-up

This is selected before the player starts the level.

It:

- increases starting ammunition;
- is consumed when the attempt begins;
- remains consumed after restart or abandonment if player-owned;
- regenerates on restart if supplied by the level;
- uses a globally configurable `ammo_amount`.

The final v1 amount remains open between +1 and +3 and is decided through balancing.

Because allowed player-owned power-ups have no artificial per-level usage cap, the amount per item must be tested carefully.

## 27. Lives system

Lives are an application resource, not a physical level component.

V1 rules:

- maximum five;
- one removed on level loss;
- one regenerated every 20 minutes;
- regeneration continues while closed;
- rewarded ad may grant one;
- tokens provide full refill to five;
- voluntary restart or exit costs no life.

Lives are presented from LevelMap, Result, and relevant overlays.

## 28. V1 level-objective definitions

V1 supports these objective definitions:

- score threshold;
- destroy a configured number of targets;
- destroy designated Objective targets;
- clear all ordinary targets;
- combinations using AND.

Solid elements never count.

Physical objective objects such as eggs and marbles are not included in v1.

## 29. Generic bonus-phase framework

V1 requires a BonusPhaseController and a configurable model interface.

It must accept:

- currently active cannonballs;
- remaining ammunition;
- catcher results;
- remaining targets;
- score events.

The first release may use one bonus model. Additional models must be addable later without changing ordinary gameplay components.

The exact first bonus model remains a separate design decision.

## 30. ComponentGallery requirements

The non-production gallery should display labeled examples of:

- every standard shape;
- Target and Solid roles;
- Normal and Objective roles;
- one-hit and three-hit states;
- Extra Ball and Double Score visuals;
- every movement type;
- small and large wheel examples;
- snap connections;
- both aiming aids;
- ball catcher.

This is Tony’s visual reference while building levels.

## 31. Deferred component backlog

Deferred until after v1:

- breakable physical objective objects;
- pushable marbles or similar objects;
- trapped-object mechanics;
- Super Ball;
- larger cannonball;
- penetrating cannonball;
- explosive cannonball;
- cannon multishot;
- additional catcher rewards;
- targets requiring five or more hits;
- additional curve radii;
- advanced movement types;
- specialized future bonus targets.

The architecture must allow these later. They are not allowed to delay the initial game.

## 32. V1 completion condition

The component library is ready for level production when:

- all standard geometry is physically verified;
- straight and curved pieces connect cleanly;
- static and moving versions behave consistently;
- wheels can remain static, rotate, slide, and combine rotation with slide;
- all Inspector roles can be configured without code;
- one-hit and three-hit states work on pegs and blocks;
- Extra Ball and Double Score follow their documented rules;
- zones and constructions report correct identity;
- aiming aids consume correctly;
- ComponentGallery documents the available kit;
- the LevelTemplate accepts the components without special setup.
