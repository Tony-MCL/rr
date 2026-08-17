# Ricochet Rush – Scoring and Objectives

**Document status:** Working design document  
**Purpose:** Preserve the agreed scoring, zone, series, objective, ranking, and bonus principles before implementation.

Values marked as working values are intended for playtesting and balancing. The separation between scoring layers and objective evaluation is a structural decision.

## 1. Scoring goals

The scoring system should:

- make ordinary hits feel useful;
- make target destruction more satisfying than incidental damage;
- reward deliberate use of level constructions;
- recognize rare and impressive cannonball paths;
- give objective completion substantial value;
- allow the bonus phase to rescue a near-successful score objective;
- produce occasional large and exciting score events;
- remain tunable without editing every level.

The player does not need to understand every formula. The player should understand the result:

> A difficult, long, or unusually successful shot produces a lot of points.

## 2. Separate scoring layers

The implementation must keep these concepts separate:

1. **Ordinary hit score** – points awarded for valid hits on active targets.
2. **Destruction score** – the enhanced final hit on a multi-hit target.
3. **Zone value** – the global base value associated with a target’s logical scoring zone.
4. **Construction-series score** – escalating points for uninterrupted hits through a defined construction.
5. **General target-series score** – bonuses for long pure or mixed target runs.
6. **Objective-object reward** – points awarded when an objective object’s task is completed.
7. **Objective-group completion bonus** – an additional reward when the final required object in a group is completed.
8. **Skill-shot bonuses** – rewards for measurable achievements such as a long shot.
9. **Multi-target achievements** – rewards for exceptional total performance by one cannonball.
10. **Shot score multiplier** – Double Score applied to all eligible score events in the current shot.
11. **Bonus-phase scoring** – points produced after the ordinary objective trigger.
12. **Performance ranking** – the stored evaluation of the completed level.
13. **Objective evaluation** – the rules that determine whether the level is won.

These layers may contribute to the same displayed score, but they must not be implemented as one opaque formula.

## 3. Core target types

### Pegs

Pegs are round targets or solid elements.

Pegs are naturally suited to:

- standalone placement;
- patterns and groups;
- individual objective targets;
- pure peg series;
- moving target arrangements.

### Blocks

Blocks are targets or solid elements used primarily to build:

- rows;
- paths;
- curves;
- wheels;
- channels;
- platforms;
- other playable constructions.

This distinction is fundamental:

> Pegs are naturally suited to standalone targets and patterns. Blocks form playable structures and paths.

Both shapes may still be used creatively outside their most common role.

## 4. Target and solid behavior

A peg or block may be configured as either a target or a solid element.

### Targets

Targets:

- award ordinary hit points;
- may participate in objectives;
- may require one or three valid hits in the initial version;
- stop awarding points immediately after destruction;
- remain physical during a configurable removal delay;
- disappear after the delay.

### Solid elements

Solid elements:

- award no ordinary points;
- take no target damage;
- do not count toward target objectives;
- do not disappear from ordinary hits;
- exist to create paths, obstacles, and difficulty.

The visual design must make the distinction between target and solid states clear.

## 5. Logical scoring zones

A level may contain up to four logical scoring zones.

Zones are not fixed horizontal screen bands. They are logical groups assigned by the level designer.

A zone may contain:

- a block construction;
- pegs associated with that construction;
- moving targets;
- targets arranged along curves or rotating structures;
- other scoring elements that belong to the same design group.

A moving target retains its zone identity and score value wherever it moves on the screen.

The level designer assigns targets or groups to a zone. Individual targets inherit the zone value automatically.

### Global standard values

| Zone | Ordinary valid hit |
|---|---:|
| Zone 1 | 10 points |
| Zone 2 | 20 points |
| Zone 3 | 30 points |
| Zone 4 | 40 points |

These are global standard values, not independent per-level values.

If balancing changes the zone scale later, the values should be changed together in one global configuration.

## 6. One-hit target scoring

A target configured for one hit awards the ordinary zone value when hit and destroyed.

Examples:

| Zone | One-hit target total |
|---|---:|
| Zone 1 | 10 |
| Zone 2 | 20 |
| Zone 3 | 30 |
| Zone 4 | 40 |

The ten-times destruction rule does not apply to a one-hit target.

## 7. Three-hit target scoring

A target configured for three hits awards:

- ordinary zone value for the first hit;
- ordinary zone value for the second hit;
- ten times the ordinary zone value for the third and destroying hit.

Examples:

| Zone | First hit | Second hit | Destroying hit | Total |
|---|---:|---:|---:|---:|
| Zone 1 | 10 | 10 | 100 | 120 |
| Zone 2 | 20 | 20 | 200 | 240 |
| Zone 3 | 30 | 30 | 300 | 360 |
| Zone 4 | 40 | 40 | 400 | 480 |

This rule applies to both pegs and blocks.

One-hit and three-hit targets are sufficient for the initial version. If targets requiring five or more hits are introduced later, they must receive a deliberately balanced destruction rule rather than automatically reusing the three-hit formula.

## 8. Valid-hit protection

A destroyed target:

- immediately stops awarding points;
- cannot take further target damage;
- cannot complete the same objective more than once;
- may still collide physically with cannonballs during its removal delay.

Persistent contact must not generate repeated scoring events. A cannonball must leave the contact and collide again before another hit can be valid.

A valid repeat collision with the same still-active multi-hit target may award another hit and may continue a series if no series-breaking collision occurred between the contacts.

## 9. Objective objects

Objective objects are separate from ordinary targets.

Examples include:

- an egg that must be broken;
- a marble that must be pushed out of the playfield;
- an object held in place by pegs or blocks;
- an object that must reach a target area;
- a trapped figure that must be freed.

Incidental hits or pushes on an objective object award zero ordinary points.

The configured reward is awarded only when the object’s actual completion rule is satisfied.

Example working values may include:

- break one egg: configurable reward;
- guide one marble out of the level: configurable reward;
- free one trapped object: configurable reward.

Previously discussed values such as 1,000 or 5,000 are examples, not locked global values.

## 10. Objective-group completion bonus

When a level requires several objective objects of the same or related group, each completed object awards its configured reward.

Completing the final required object also triggers a separate objective-group completion bonus.

Example:

- first egg completed: egg reward;
- second egg completed: egg reward;
- third and final egg completed: egg reward plus group-completion bonus.

The group-completion bonus may scale according to:

- number of required objects;
- level difficulty;
- the level’s expected score range;
- other balancing values defined later.

The exact formula remains open for playtesting.

## 11. Construction groups

The level designer can explicitly group blocks into a named construction.

Examples include:

- a curved block path;
- a wheel;
- a connected row;
- a channel;
- a spiral;
- another deliberate block structure.

Explicit grouping prevents nearby unrelated blocks from being treated as one construction.

## 12. Construction-series scoring

A construction series is an uninterrupted sequence of valid hits on blocks belonging to the same defined construction.

The current working progression is:

| Hit in uninterrupted construction series | Series points |
|---:|---:|
| 1 | 10 |
| 2 | 20 |
| 3 | 40 |
| 4 | 60 |
| 5 | 80 |
| 6 and onward | 100 per valid hit |

Series points are added on top of ordinary zone, hit, and destruction points.

The construction series is considered achieved when the sixth valid hit awards the first 100-point series value.

### Long-series milestones

The current working milestone bonuses are:

| Series length reached | Normal series points for that hit | Additional milestone bonus |
|---:|---:|---:|
| 10 | 100 | +500 |
| 15 | 100 | +1,000 |
| 20 | 100 | +3,000 |

These are global working values and must be configurable for balancing.

## 13. Construction-series continuity

A construction series continues only while consecutive collision events are valid hits on the same defined construction.

The series breaks when the cannonball collides with:

- a wall;
- a solid obstacle;
- a peg;
- a block from another construction;
- any other physical gameplay element.

After a break, the next valid construction hit starts again at the first series value.

Several distinct hits on the same active three-hit block may advance the construction series. This is valid only when:

- the cannonball genuinely separates and collides again;
- no other series-breaking collision occurs between the hits;
- the target remains active.

Continuous physical contact cannot create repeated series events.

## 14. Multiple construction series with one cannonball

One cannonball may achieve several different construction series in direct succession.

A qualifying series must reach the sixth uninterrupted construction hit.

The bonus multiplier is:

| Qualifying construction series in the same unbroken super-chain | Series-bonus multiplier |
|---:|---:|
| First | ×1 |
| Second | ×5 |
| Third | ×25 |
| Fourth and later | ×25 |

The multiplier applies only to construction-series scoring and construction milestone bonuses.

It does not multiply:

- ordinary zone points;
- ordinary hit points;
- destruction points;
- objective rewards;
- unrelated skill-shot bonuses.

To receive the next multiplier, the cannonball must move directly from one defined construction into the next and build another qualifying uninterrupted series.

If the cannonball:

- hits another gameplay element;
- returns to a previously left construction;
- otherwise breaks construction continuity;

the super-chain ends. The next construction series begins again at ×1.

The system is deliberately capped at ×25. More than three qualifying construction series in direct succession is expected to be extremely rare.

## 15. General target series

A cannonball may also receive a general target-series bonus for a long run of valid target hits.

Unlike a construction series, a general target series may contain pegs, blocks, or both.

### Pure series

A pure series contains only one target shape:

- pegs only; or
- blocks only.

A pure series receives the higher general-series reward.

### Mixed series

A mixed series contains both pegs and blocks.

A mixed series still receives a reward, but the reward is lower than for a pure series of equivalent length.

The exact thresholds and values for pure and mixed general series remain open for playtesting.

This system is separate from explicit construction-series scoring. A shot may potentially qualify for more than one scoring layer when it legitimately satisfies both rule sets.

## 16. Multi-target achievements

The game should recognize exceptional total performance by one cannonball.

Possible triggers include:

- a high number of valid hits;
- a high number of destroyed targets;
- clearing a difficult group with one shot;
- an unusually long ricochet sequence;
- other rare, measurable shot achievements.

These bonuses may reasonably award thousands or tens of thousands of points.

Names, thresholds, and values remain open. Their implementation must allow new achievement types to be added later.

## 17. Skill-shot bonuses

Skill-shot bonuses recognize specific measurable shot patterns.

### Long Shot

A Long Shot is awarded when one cannonball travels a sufficiently large meaningful distance between qualifying target hits.

A conceptual example is hitting a target near the upper-left area and later reaching a target on the opposite side through a long curved path.

Working presentation:

> LONG SHOT! +1,000

The 1,000-point value is a working value.

The final Long Shot detector must use an understandable and reliable geometric rule. Exact distance, height, and collision requirements remain open for implementation testing.

### Global availability

Skill-shot bonuses are global possibilities. They do not need to be manually enabled on every level.

Some levels will naturally make particular bonuses easier or more likely through their design.

The architecture must allow additional global skill-shot types later.

## 18. Double Score bonus

Double Score is a shot-wide multiplier activated by a bonus peg or block.

### Activation and stacking

When any active cannonball validly hits a Double Score target:

- the activation hit is included in the doubled score;
- the current shot multiplier doubles;
- every active cannonball in the shot uses the same multiplier;
- bonus cannonballs spawned later into the same shot inherit it;
- each additional Double Score activation doubles the current multiplier again.

| Double Score activations in one shot | Active multiplier |
|---:|---:|
| 0 | ×1 |
| 1 | ×2 |
| 2 | ×4 |
| 3 | ×8 |
| 4 | ×16 |

### Included score events

During ordinary play the multiplier applies to:

- ordinary target hits;
- multi-hit destruction score;
- construction-series points;
- construction milestone bonuses;
- pure and mixed target-series points;
- Long Shot;
- other shot-based skill bonuses.

### Excluded score and reward events

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
- resets when every ball belonging to the shot has exited;
- does not follow a caught ball into a new shot;
- ends immediately when the bonus trigger is reached;
- never carries into the bonus phase.

If the activating hit also triggers the bonus phase, that hit receives the current doubled value before ordinary scoring ends.

## 19. Extra-cannonball rewards

Targets and bonus elements may award extra cannonballs.

An extra-cannonball reward:

- increases remaining ammunition immediately;
- may raise ammunition above the level’s starting amount;
- is preserved if the level enters the bonus phase;
- is separate from points unless the bonus explicitly awards both.

Multiple active cannonballs may each enter the ball catcher and return one ammunition unit. A successful shot may therefore create a positive net ammunition gain.

## 20. Level objective types

The objective system must support at least:

### Score objective

Example:

> Score at least 20,000 points.

### Target-count objective

Example:

> Destroy 20 qualifying targets.

### Designated-target objective

Example:

> Destroy all orange targets.

Target function is separate from target shape. Both pegs and blocks may be designated objective targets.

### Clear-all objective

Example:

> Clear all ordinary targets.

Solid pegs and blocks are excluded.

### Objective-object requirement

Example:

> Break all three eggs.

### Combined objective

Example:

> Break all three eggs AND score at least 20,000 points.

All mandatory objective parts in the initial version use AND logic.

### Future objectives

New objective types must be addable without rebuilding the basic level system or editor.

## 21. Bonus trigger and final objective evaluation

The game distinguishes the bonus trigger from the final win evaluation.

### Gameplay-objective levels

When all mandatory non-score gameplay objectives are complete, ordinary play stops and the bonus phase begins.

This happens even when a mandatory score requirement has not yet been reached.

### Score-only levels

When the score requirement is the only mandatory objective, reaching it triggers the bonus phase.

### Combined example

A level requires:

- break all three eggs;
- score 20,000 points.

The third egg triggers the bonus phase even if the current score is only 17,000.

Bonus-phase scoring may raise the total beyond 20,000.

### Final result

After the bonus phase and every completion bonus:

- all mandatory requirements are evaluated;
- the level is won only if all are complete;
- the level is lost if any mandatory requirement remains incomplete.

If the score requirement is reached before the gameplay objective, ordinary play continues until the remaining gameplay objective is completed or the attempt fails.

## 22. Bonus-phase scoring

When the bonus phase begins:

- every currently active cannonball joins the bonus phase;
- catcher results and earned ammunition are preserved;
- remaining ammunition is available to the selected bonus model;
- remaining targets may produce additional score;
- bonus exits or other finish mechanics may award additional bonuses;
- the final score is not locked until the bonus phase ends.

The architecture must support multiple bonus-phase models.

The exact initial bonus-phase presentation and formula remain open.

## 23. Remaining-ammunition bonus

Remaining ammunition should improve the final reward.

Preserving a specific number of cannonballs is not a mandatory level objective.

The exact relationship between remaining ammunition, bonus-phase behavior, and final score remains part of the bonus-phase design.

## 24. Performance ranking

Completed levels store a one-to-three-tier performance ranking.

The current working presentation is coffee cups:

| Ranking | Meaning |
|---|---|
| One coffee cup | Mandatory level objective completed |
| Two coffee cups | Configured good-score threshold reached |
| Three coffee cups | Configured high-score threshold reached |

The two- and three-cup thresholds are configured per level because expected scores differ by level design.

Higher ranking may award additional rewards or prestige. It does not block the next level unless a score requirement is explicitly part of the mandatory objective.

The coffee-cup presentation is provisional but compatible with Morning Coffee Labs.

## 25. Score display and feedback

The score presentation should make important events feel proportionally important.

Ordinary hits need quick, readable feedback.

Major events may use larger presentation, including:

- destroying a multi-hit target;
- completing an objective object;
- completing an objective group;
- reaching a construction milestone;
- achieving a second or third qualifying construction series;
- earning a Long Shot;
- triggering a rare multi-target achievement;
- completing the bonus phase.

The most exceptional events should be allowed to show a large score message rather than hiding the result in a small counter.

## 26. Configuration principles

The following values should be centrally configurable:

- global zone values;
- multi-hit destruction multiplier;
- construction-series progression;
- construction milestone thresholds and rewards;
- multiple-construction multipliers;
- pure and mixed general-series thresholds and rewards;
- skill-shot thresholds and rewards;
- objective-group completion scaling;
- ranking thresholds where global defaults exist;
- bonus-phase scoring defaults.

Level-specific configuration should be used only where level design genuinely differs, including:

- target zone assignment;
- objective-object reward;
- mandatory objective requirements;
- expected score and ranking thresholds;
- starting ammunition;
- selected bonus-phase model.

The level designer should not manually enter ordinary point values on every target.

## 27. Current locked values

The current locked or accepted working baseline is:

- Zone 1 ordinary hit: 10
- Zone 2 ordinary hit: 20
- Zone 3 ordinary hit: 30
- Zone 4 ordinary hit: 40
- One-hit target: ordinary zone value
- Three-hit target: zone value, zone value, then zone value ×10
- Construction series: 10, 20, 40, 60, 80, then 100 per hit
- Construction series achieved: sixth uninterrupted construction hit
- Construction milestone at 10: +500
- Construction milestone at 15: +1,000
- Construction milestone at 20: +3,000
- First qualifying construction series: ×1
- Second directly chained qualifying construction series: ×5
- Third and later directly chained qualifying construction series: ×25
- Double Score: shot-wide ×2, stacking to ×4, ×8, ×16, and onward for each activation
- Double Score ends at shot completion or bonus trigger and never applies to bonus-phase score
- Example Long Shot reward: +1,000, subject to testing

## 28. Open balancing decisions

The following remain intentionally open:

- pure general-series thresholds and values;
- mixed general-series thresholds and values;
- exact objective-object rewards;
- objective-group completion scaling;
- multi-target achievement names, thresholds, and values;
- Long Shot detection rule and final value;
- bonus-phase model and scoring;
- remaining-ammunition bonus formula;
- final visual name for performance ranking;
- final per-level two- and three-rank thresholds.

These are balancing and presentation decisions, not missing structural decisions.

## 29. Design principle

Scoring should reward ordinary progress, deliberate construction use, objective completion, and exceptional play at different scales.

The formula may contain several layers, but the result should feel intuitive:

- deeper logical zones are more valuable;
- destroying a multi-hit target is satisfying;
- uninterrupted construction runs are valuable;
- pure and mixed target runs can both be rewarded;
- objective completion matters;
- rare shots can produce an enormous amount of points;
- the bonus phase can turn a near-success into a win.

The player’s main takeaway should sometimes be:

> “That was a whole lot of points.”
