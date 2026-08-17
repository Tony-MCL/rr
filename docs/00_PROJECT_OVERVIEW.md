# Ricochet Rush – Project Overview

**Document status:** Working design document  
**Project name:** Ricochet Rush  
**Short name:** RR  
**Genre:** Physics-based arcade and level game  
**Primary platform:** Mobile  
**Engine:** Godot

## 1. Purpose of this document

This document defines what Ricochet Rush is, what it is not, and the main principles the project must preserve during development.

Detailed scoring rules, technical architecture, level design, monetization, and production order belong in separate documents. This overview is the common foundation those documents must follow.

## 2. Game concept

Ricochet Rush is a portrait-format, physics-based arcade game in which the player fires cannonballs down into a playfield filled with targets, structures, obstacles, and objective objects.

The cannon is anchored at the top of the screen. The player rotates it left or right, chooses an angle, and taps to fire. After the cannonball has been fired, the player cannot influence its path. The result is determined by aim, physics, level construction, and a controlled degree of unpredictability.

The cannonball ricochets between targets, blocks, walls, and other level elements. Collisions should feel lively and satisfying, with a responsive quality inspired by pinball-like bounce rather than passive contact.

The intended reaction after completing or narrowly failing a level is:

> “One more level.”

## 3. Design inspiration and originality

Ricochet Rush is inspired by the broad appeal of games such as Peggle Blast: simple aiming, satisfying physics, short levels, and a mixture of skill and unpredictability.

Ricochet Rush must not be a copy of Peggle, Peggle Blast, or any other existing game. It must develop its own:

- visual identity;
- characters and environments;
- terminology;
- target and objective types;
- level designs;
- progression model;
- power-ups;
- scoring and bonus systems;
- sounds, effects, and presentation;
- monetization balance.

Inspiration may guide the type of experience we want to create. It must not dictate the final expression or implementation.

## 4. Intended player experience

Ricochet Rush should be:

- easy to understand;
- quick to start;
- playable with one hand;
- suitable for short sessions;
- satisfying enough to encourage several levels in one sitting;
- based on a balance of aiming skill, planning, physics, and chance;
- family-friendly in content and presentation;
- rewarding without depending on aggressive advertising or purchases.

The player should gradually become better at reading angles, anticipating ricochets, recognizing useful structures, and deciding when to use limited assistance.

Complexity should come from level design and player decisions, not confusing controls or opaque rules.

## 5. Core gameplay loop

The ordinary level loop is:

1. The player selects an available level.
2. The level loads with a configured number of cannonballs.
3. The player rotates the cannon to choose an angle.
4. The player may activate an available aiming aid.
5. The player taps to fire.
6. The cannonball moves independently through the playfield.
7. Targets, objectives, bonuses, and scoring react to the shot.
8. The shot ends when the cannonball leaves through the bottom of the playfield.
9. If the level objective is not complete and ammunition remains, the next cannonball is loaded at the cannon’s current angle.
10. If the final cannonball leaves without completing the objective or earning another cannonball, the level is lost.
11. When the level objective is completed, ordinary play stops and the level enters a configurable bonus phase.
12. The final result, score, ranking, and rewards are calculated after the bonus phase.

## 6. Cannon and controls

Ricochet Rush uses a portrait-format playfield.

The cannon:

- is anchored at the top of the screen;
- rotates around its fixed anchor;
- does not move sideways;
- points downward into the playfield;
- can rotate approximately 80–85 degrees to either side of vertical;
- can aim almost horizontally, but never upward;
- retains its current direction after a shot.

The exact rotation limit will be selected through playtesting within the planned range.

The player:

1. drags left or right to rotate the cannon;
2. releases without firing;
3. may continue to fine-tune the angle;
4. taps once to fire;
5. cannot affect the cannonball after firing.

The complete ordinary control scheme must work comfortably with one hand.

## 7. Aiming aids

Aiming guides are limited power-ups rather than permanently enabled assistance.

The system must support at least:

- a basic aiming aid that shows the initial direction;
- an improved aiming aid that shows a longer trajectory and at least the first predicted ricochet.

One aiming aid applies to one shot and is consumed when that shot is fired.

Introductory levels may provide as many free aiming aids as the level provides cannonballs. Later levels can reduce this assistance so the player must choose when to use an aiming aid, earn more, obtain them through rewards, or spend tokens.

Long trajectory previews are guidance, not a guarantee. Moving elements and small physics variations may change the actual result.

## 8. Basic level elements

Ricochet Rush uses two primary geometric building blocks.

### Pegs

Pegs are round elements that can be placed individually or used in patterns, groups, and series.

### Blocks

Blocks are shaped elements used to create rows, paths, curves, wheels, surfaces, channels, and other constructions that influence the cannonball.

Both pegs and blocks can be configured as either targets or solid level elements.

### Targets

Targets:

- can award points;
- can contribute to objectives;
- can require one or three hits in the initial version;
- enter a completed hit state after the final required hit;
- immediately stop awarding points once destroyed;
- remain physical obstacles during a configurable delay;
- disappear after the delay.

Both pegs and blocks may use one-hit or three-hit behavior. One-hit pegs will be the natural default, but the system must allow deliberate surprises.

### Solid elements

Solid pegs and blocks:

- influence the cannonball’s path;
- do not award ordinary target points;
- do not count as targets;
- do not disappear when hit;
- exist to shape the level and increase difficulty.

Target and solid states must be communicated clearly through the game’s visual language.

## 9. Objective objects

Levels may contain objective objects that are separate from ordinary pegs and blocks.

Examples include objects that must be:

- freed by destroying supporting targets;
- pushed out of the playfield;
- moved into a defined area;
- struck or broken a configured number of times;
- freed and then guided to an exit.

An egg may need to be broken. A marble may need to be nudged out through the bottom. A trapped object may require the player to remove the structure holding it in place.

Objective objects do not award ordinary points for incidental hits. They award a configured completion value when their actual task is completed.

The objective system must be extendable so new objective types can be introduced later without rebuilding the level system.

## 10. Level objectives

A level may have one or more mandatory objective requirements.

Possible requirements include:

- achieve a configured score;
- destroy all targets of a defined type;
- destroy a configured number of targets;
- clear all ordinary targets;
- complete one or more objective objects;
- combine several requirements.

All mandatory requirements in the initial design are connected with **AND**. Every required part must be completed before the level is won.

Solid pegs and blocks never count as targets for completion.

Remaining cannonballs may award bonuses, but preserving a specific number of cannonballs must not be a mandatory level objective.

## 11. Ammunition and the ball catcher

The level designer configures the starting number of cannonballs for each level.

A moving ball catcher is a standard level feature but can be disabled on selected levels.

When the active cannonball exits through the catcher:

- the shot ends;
- the cannonball is returned to the available ammunition;
- the player receives another attempt without reducing the previous ammunition count.

The system must also support alternative catcher rewards on selected levels.

Targets, bonus elements, and objective rewards may grant extra cannonballs. The ammunition count may therefore exceed the level’s original starting amount.

## 12. Bonus phase

When the complete level objective is achieved:

- ordinary progression stops immediately;
- the currently active cannonball becomes part of the bonus phase;
- remaining and additionally earned cannonballs can be used by the selected bonus model;
- remaining targets may still contribute to bonus scoring;
- the final result is calculated only after the bonus phase ends.

The architecture must support multiple bonus-phase models. The first release may implement only one, but the ordinary level system must not be permanently coupled to it.

Possible bonus-phase elements include multiple active cannonballs, bonus exits, remaining-target destruction, and completion bonuses. The final visual and mechanical model is still open.

## 13. Progression map

The main progression is presented as a vertically scrollable path.

- Level 1 begins near the bottom.
- Completing a level unlocks the next level above it.
- The path grows upward as more levels are added.
- Completed levels remain available for replay.
- Players can replay favorite levels and improve their score or ranking.

The path can be divided visually into themed regions or level packs without changing the underlying progression system. Separate islands or worlds may remain a presentation option, but they are not an architectural requirement.

## 14. Performance ranking

Each completed level stores a performance ranking.

The current working presentation is one to three coffee cups:

- One coffee cup: level objective completed.
- Two coffee cups: good score.
- Three coffee cups: high score.

The second and third thresholds are configurable per level. The coffee-cup theme is provisional but compatible with the Morning Coffee Labs identity.

The next level unlocks when the mandatory level objective is complete. A higher performance ranking can provide prestige or additional rewards but does not block ordinary progression unless a required score is explicitly part of the level objective.

## 15. Lives

The standard maximum is five lives.

- A life is not spent when a level begins.
- One life is removed when a level is lost.
- Completing a level does not remove a life.
- Voluntarily leaving a level does not remove a life.
- Closing the app during a level is treated as leaving: no life is removed, but the unfinished attempt is discarded.
- An abandoned attempt gives no score, rewards, or progression.

One life regenerates every 20 minutes, including while the app is closed. Regeneration stops at five lives.

A rewarded advertisement may grant one life. Tokens may provide a full refill to five lives. Exact costs and advertisement limits belong in the monetization design.

## 16. Tokens, power-ups, and monetization

Ricochet Rush is intended to earn revenue, but monetization must not destroy the player experience.

The game may include:

- moderate advertising;
- rewarded advertising chosen by the player;
- earnable and purchasable tokens;
- aiming aids;
- power-ups;
- additional cannonballs;
- life refills;
- other clearly defined assistance.

Ordinary levels must be possible without forced purchases. Early levels should teach the core mechanics without dependence on power-ups.

The preferred business principle is long-term player satisfaction and return visits rather than maximum revenue from one session.

## 17. Saving, accounts, and online features

Ordinary progression is stored locally on the device.

Local data includes:

- unlocked and completed levels;
- best score per level;
- performance ranking;
- tokens and assistance;
- lives and regeneration;
- settings;
- other player progression.

No account or registration is required to play.

The player may optionally choose a display name for a global leaderboard, following the same basic principle used in Fury O. A display name is not a full player account and must not make ordinary play dependent on login.

## 18. Offline operation

The goal is for all ordinary levels to be playable without an internet connection.

The game, level data, physics, scoring, progression, and local saving should operate locally.

Internet access is required only where the feature inherently depends on it, including:

- retrieving and submitting leaderboard data;
- loading advertisements;
- purchases and purchase verification;
- future online services.

If an online service is unavailable, the ordinary game must continue to work.

## 19. Platforms and screen support

Ricochet Rush is planned for Android and iOS.

The goal is a broadly shared release window, although Android may launch first for practical reasons.

Phones and tablets are supported in portrait orientation. The playfield must adapt to different screen sizes without changing the intended level geometry, relative positions, or physics difficulty.

## 20. Level editor as a core requirement

Ricochet Rush must be built from reusable and configurable building blocks.

The goal is for Tony to open the project’s level-building environment, place elements, configure them, test the result, and create a complete playable level without writing or changing code.

The level-building workflow must eventually support:

- placing pegs, blocks, obstacles, and objective objects;
- selecting target or solid behavior;
- selecting one-hit or three-hit behavior;
- assigning logical scoring zones;
- grouping elements into constructions and series;
- configuring movement;
- configuring level objectives;
- setting starting ammunition;
- enabling or disabling the ball catcher;
- selecting a bonus-phase model;
- providing free level-specific assistance;
- defining score and ranking thresholds;
- testing and saving the level;
- adding the level to the progression path.

This is not merely a later convenience tool. The requirement to build levels without programming must shape the architecture from the beginning.

## 21. Initial product scope

The first product version should contain:

- at least 25 completed levels;
- preferably 50 completed levels;
- a stable and reusable gameplay foundation;
- a progression path that accepts new levels;
- a level-building workflow that does not require programming;
- complete ordinary win, loss, retry, scoring, saving, and progression loops;
- the initial lives, token, assistance, advertising, and leaderboard systems;
- a coherent visual and audio presentation.

The architecture must support additional levels and mechanics without reconstructing the fundamental game systems.

This does not mean every future idea must be implemented in the first release. It means physics, targets, objectives, scoring, level data, progression, presentation, and monetization must have clear responsibilities and extension points.

## 22. What Ricochet Rush is not

Ricochet Rush is not:

- a copy of an existing game;
- a game in which the player controls the cannonball after firing;
- a landscape-format game;
- dependent on two-handed controls;
- dependent on registration or login;
- dependent on an internet connection for ordinary play;
- pay-to-win;
- an advertising product with a game placed between interruptions;
- a system where every new level requires new programming;
- a project where gameplay rules, presentation, progression, and level data are mixed together;
- permanently tied to one target type, objective type, visual theme, or bonus phase;
- intended to punish ordinary players in order to prevent a small amount of harmless exploitation.

## 23. Guiding production principle

The foundation must be understandable, documented, stable, and extendable before large-scale level production begins.

Development should proceed one component and one documented phase at a time. New ideas that do not belong to the active phase should be recorded for later rather than interrupting the current work.

The project should remain easy to understand and resume even after several months away.
