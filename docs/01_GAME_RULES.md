# Ricochet Rush – Game Rules

**Document status:** Working design document  
**Purpose:** Define the complete rules of an ordinary Ricochet Rush level, from level introduction through win, loss, restart, or exit.

This document describes gameplay behavior. Detailed score values, technical implementation, monetization, and presentation belong in separate documents.

## 1. Core terminology

### Cannonball

A cannonball is a physical ball currently moving in the playfield.

### Shot

A shot begins when the player fires one cannonball from the cannon.

A shot may later contain several active cannonballs if bonus elements create additional balls. The shot does not end until every active cannonball belonging to it has left the playfield.

### Ammunition

Ammunition is the number of ordinary cannonballs the player can still fire from the cannon during the current level attempt.

### Life

A life represents one failed level attempt. A life is removed only when the level is lost, not when the level begins.

### Level attempt

A level attempt begins when the player confirms the level introduction and ends when the level is won, lost, restarted, or abandoned.

## 2. Level introduction

Before ordinary play begins, the loaded level is covered by a level-introduction overlay or modal.

The introduction shows:

- level number;
- current lives;
- starting ammunition;
- the complete level objective and all mandatory sub-objectives;
- power-ups and assistance allowed on the level;
- the player’s available quantities;
- free temporary assistance supplied by the level;
- a clear Start action.

The level may load behind this introduction. The Start action becomes available when the level is ready.

A countdown is not required by default. It may be added later if testing shows that it improves the experience.

## 3. Power-up preparation

The player may select available power-ups before starting the level.

Power-ups are divided into two sources.

### Level-supplied assistance

Level-supplied assistance:

- belongs only to the current level attempt;
- is configured by the level designer;
- can teach or support a particular mechanic;
- regenerates when the level is restarted;
- cannot be carried to another level;
- disappears unused when the attempt ends.

### Player-owned power-ups

Player-owned power-ups:

- have been earned, rewarded, or purchased;
- remain in the player’s inventory until used;
- are consumed when activated or used;
- are not returned after restart or voluntary exit;
- remain consumed even when the attempt produces no completed result.

The level designer may decide which power-up types are allowed on a level. If a type is allowed, the game does not impose an artificial per-level usage limit on the player’s owned supply.

Some power-ups are selected before the level. Shot-specific assistance, such as an aiming aid, is activated for the shot on which it will be used.

## 4. Cannon and aiming

The cannon is anchored at the top of the portrait playfield and rotates around its fixed point.

The cannon:

- does not move sideways;
- points downward;
- may rotate approximately 80–85 degrees to either side of vertical;
- may aim almost horizontally but never upward;
- retains its current angle after a shot;
- can be rotated while cannonballs are active.

The exact maximum angle is selected through playtesting within the planned range.

The player controls the cannon by:

1. dragging left or right to rotate it;
2. releasing without firing;
3. fine-tuning the angle if needed;
4. tapping once to fire.

The player cannot influence the path of a cannonball after it has been fired.

The player may rotate the cannon during an active shot to prepare the next angle, but cannot fire another ordinary cannonball until the active shot has ended.

## 5. Aiming assistance

Aiming guides are consumable power-ups.

The system supports at least:

- a basic aiming aid that shows the initial direction;
- an improved aiming aid that shows a longer path and at least the first predicted ricochet.

One aiming aid applies to one shot and is consumed when that shot is fired.

Introductory levels may supply one aiming aid per available cannonball. Later levels may provide fewer or no free aiming aids.

An aiming preview is guidance, not a guarantee. Moving elements and physics variation may affect the actual trajectory.

## 6. Starting ammunition

The level designer configures the starting ammunition independently for each level.

The ammunition count may rise above the starting amount through:

- the moving ball catcher;
- bonus pegs or blocks;
- objective rewards;
- other configured gameplay bonuses.

There is no automatic cap at the starting amount.

## 7. Ordinary shot lifecycle

An ordinary shot follows this sequence:

1. The player fires one cannonball.
2. One ammunition unit has now been committed to the shot.
3. The cannonball moves independently through the playfield.
4. Collisions may award points, damage targets, advance objectives, create bonus cannonballs, or activate other effects.
5. Any created bonus cannonballs become part of the same active shot.
6. The player may rotate the cannon, but cannot fire again.
7. Each active cannonball eventually leaves through the bottom of the playfield.
8. Catcher results, extra ammunition, objectives, and the remaining active-ball count are resolved.
9. The shot ends only when no cannonballs belonging to it remain active.
10. If ordinary play continues and ammunition remains, the next cannonball is loaded at the cannon’s current angle.

## 8. Bonus cannonballs during ordinary play

Ordinary play normally begins each shot with one cannonball fired from the cannon.

A bonus peg, block, or other gameplay event may spawn additional cannonballs from the point where the bonus was activated.

These bonus cannonballs:

- belong to the current shot;
- move independently;
- can score and interact with level elements;
- can enter the ball catcher;
- must all leave the playfield before the shot ends.

This is not the same as a future multi-shot mechanic that fires several ordinary cannonballs directly from the cannon. Multi-shot levels are outside the initial rules and may be designed later.

## 9. Ball catcher

A moving ball catcher is a standard level feature. The level designer may disable it on selected levels.

When a cannonball enters the catcher:

- that cannonball leaves the active playfield;
- one cannonball is added to the remaining ammunition;
- the player receives another firing opportunity.

The practical result for an ordinary one-ball shot is that the player retains the same ammunition count held before firing.

Every active cannonball caught during a multi-ball shot returns one ammunition unit. A successful bonus-ball sequence can therefore leave the player with more ammunition than the level originally supplied.

The system must permit alternative catcher rewards on selected levels, although returning one cannonball is the standard behavior.

## 10. Peg and block roles

Both pegs and blocks can be configured as targets or solid elements.

### Target state

A target:

- may require one or three valid hits in the initial version;
- awards ordinary points for each valid hit;
- loses one required hit for each valid hit;
- is destroyed only by the final required hit;
- enters a completed hit state after destruction;
- immediately stops awarding points and accepting damage;
- remains physically solid during a configurable removal delay;
- disappears when the delay expires.

The removal delay begins only after the final required hit.

A persistent collision contact must not register as many repeated hits. The cannonball must leave the contact and collide again before another hit can be recorded.

### Solid state

A solid peg or block:

- affects the cannonball physically;
- awards no ordinary target points;
- takes no ordinary target damage;
- does not count toward target objectives;
- does not disappear from ordinary hits.

Solid elements exist to create paths, obstacles, and difficulty.

## 11. Objective objects

Objective objects are separate from ordinary pegs and blocks.

An objective object may require the player to:

- free it by removing supporting targets;
- push it out of the playfield;
- move it into a target area;
- strike or break it a configured number of times;
- combine several physical steps.

Incidental hits on an objective object award no ordinary hit points.

The configured objective reward is awarded only when the actual objective action is completed.

Objective completion is registered immediately at the decisive event, even if related destroyed elements remain physically present during a removal delay.

## 12. Mandatory level objectives

A level may contain one or more mandatory requirements, including:

- achieve a configured score;
- destroy all targets of a defined type;
- destroy a configured number of targets;
- clear all ordinary targets;
- complete objective objects;
- combine several requirements.

All mandatory requirements in the initial version use AND logic. Every required part must be satisfied for the final level result to be a win.

Solid elements never count as target objectives.

Remaining ammunition may improve score and rewards but is not a mandatory objective requirement.

## 13. Bonus trigger versus final objective

The game distinguishes between:

- the condition that ends ordinary play and triggers the bonus phase;
- the final objective evaluation performed after all bonus scoring.

### Levels with gameplay objectives

On a level containing non-score gameplay objectives, the bonus phase begins when every mandatory non-score objective has been completed.

The bonus phase begins even if a separate mandatory score requirement has not yet been reached.

### Score-only levels

On a level whose only mandatory objective is score, the bonus phase begins when the score requirement is reached.

### Combined objectives

Example:

- break all three eggs;
- score at least 20,000 points.

The bonus phase begins when the final egg is broken, even if the current score is below 20,000.

The bonus phase may then raise the score above the required value.

### Final evaluation

After the bonus phase:

- every mandatory requirement is evaluated;
- if all requirements are complete, the level is won;
- if any requirement remains incomplete, the level is lost.

If a score requirement is reached before the gameplay objectives, ordinary play continues until the gameplay objectives are completed or the attempt fails.

## 14. Transition to bonus phase

When the bonus trigger is reached:

- ordinary progression stops immediately;
- no additional ordinary shot may be fired;
- every currently active cannonball transfers into the bonus phase;
- cannonballs that subsequently enter the catcher add to the ammunition available to the bonus system;
- remaining and additionally earned ammunition is preserved;
- the selected bonus-phase model controls the rest of the sequence.

The game must be generous with legitimate bonus opportunities. Active cannonballs, earned ammunition, and available scoring opportunities must not be discarded during the transition.

The first release may contain one bonus-phase model, but the game rules and level data must allow other models later.

## 15. End of a successful level

A successful level ends after:

1. the bonus trigger is reached;
2. the bonus phase completes;
3. all final bonuses are awarded;
4. every mandatory objective is evaluated and satisfied;
5. the final score and performance ranking are calculated;
6. progression and rewards are saved;
7. the next level is unlocked.

Completed levels remain available for replay.

## 16. Level failure

A level is lost when:

- the complete mandatory objective has not been achieved;
- the current shot has fully ended;
- no ammunition remains;
- no catcher result, bonus, or other event has granted another cannonball.

A life is removed at the moment the level is confirmed lost.

A level can also be lost after the bonus phase if the bonus trigger was reached but a mandatory result requirement, such as final score, remains incomplete.

## 17. Lives

The normal maximum is five lives.

- Starting a level does not remove a life.
- Winning does not remove a life.
- Losing removes one life.
- Voluntary restart does not remove a life.
- Voluntary exit does not remove a life.
- Closing the app during a level is treated as voluntary exit.

One life regenerates every 20 minutes, including while the app is closed. Regeneration stops at five lives.

A rewarded advertisement may grant one life. A token-based refill restores the normal life supply to five.

Exact costs, advertisement limits, and exceptional bonuses belong in the monetization design.

## 18. Pause

Opening the pause menu completely freezes:

- cannonballs and physics;
- level movement;
- gameplay animations;
- gameplay timers;
- target removal delays;
- objective progression;
- bonus-phase progression.

The pause menu contains:

- Continue;
- Restart Level;
- Settings;
- Exit to Map.

Opening Settings from pause must not resume the level.

## 19. Restart

Restart discards:

- current score;
- current objective progress;
- current shot state;
- temporary rewards from the unfinished attempt;
- temporary ammunition gained during the unfinished attempt.

Level-supplied assistance is regenerated for the new attempt.

Player-owned power-ups already used remain consumed.

If player-owned power-ups have been used, the game shows a confirmation before restart and clearly states that those items will not be returned.

Restart does not remove a life.

## 20. Voluntary exit and app closure

Voluntary exit returns the player to the progression map without removing a life.

Closing the app during a level has the same gameplay result as voluntary exit.

The unfinished attempt:

- is not resumed;
- gives no score;
- gives no rewards;
- saves no objective progress;
- does not affect the level’s recorded result.

Player-owned power-ups already used remain consumed.

## 21. Performance ranking and progression

Completing the mandatory level objective unlocks the next level.

A completed level stores:

- best score;
- current best performance ranking;
- completed state;
- any additional permanent result data defined later.

The working performance presentation is one to three coffee cups.

Higher ranking may provide rewards or prestige but does not block ordinary progression unless a required score is explicitly part of the level objective.

## 22. Rule priority

When several events occur during the same physics sequence, the game resolves them in this order:

1. register valid physical hits;
2. apply damage and target-state changes;
3. register objective completion;
4. create earned bonus cannonballs and ammunition;
5. preserve all active cannonballs and catcher results;
6. determine whether the bonus trigger has been reached;
7. enter the bonus phase when required;
8. perform final objective evaluation only after the bonus phase;
9. determine win or loss;
10. save the completed result.

This priority exists to prevent valid points, cannonballs, objectives, or bonuses from being lost because several events happened close together.

## 23. Design principle

Ricochet Rush should be generous with legitimate player achievements.

The rules should not remove earned cannonballs, discard active bonus opportunities, or punish ordinary players merely to prevent minor exploitation.

Failure, success, rewards, and power-up consumption must be predictable and clearly communicated.
