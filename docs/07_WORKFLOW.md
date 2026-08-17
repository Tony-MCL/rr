# Ricochet Rush – Workflow

**Document status:** Approved working method  
**Purpose:** Define how Tony and the AI development partner work through the build plan without losing structure, understanding, or momentum.

## 1. Core rule

Work on one bounded goal at a time.

A task is complete only when:

- the intended behavior exists;
- the relevant test passes;
- Tony can see what changed;
- the file locations and editable values are known;
- documentation is updated where needed;
- the change has a clear commit.

## 2. Start of a build thread

Every build thread begins with:

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

The relevant repository documents are read before code changes begin.

Do not depend on remembered chat details when the repository documents contain the current decision.

## 3. Before changing code

For each work unit:

1. state the user-visible goal;
2. identify the files that will be created or changed;
3. explain any meaningful structural choice;
4. identify the exact test that will prove completion;
5. confirm unrelated functionality that must remain unchanged.

Large architecture changes are explained before implementation.

## 4. During implementation

- Change only the active component and its direct dependencies.
- Preserve verified functionality.
- Prefer complete, readable files.
- Use clear Godot node, scene, resource, and signal names.
- Avoid temporary hacks that silently become permanent.
- Do not add unrelated features because they are convenient at the moment.
- Put new ideas in `BACKLOG.md`.
- Stop and diagnose unexpected behavior before layering more code on top.

## 5. One-component learning rhythm

When introducing a Godot concept:

1. explain what the component is;
2. show where it lives;
3. explain its parent and children;
4. explain the values Tony may change;
5. build it;
6. test it visibly;
7. let the concept settle before introducing another major system.

Do not mix a new scene pattern, new signal architecture, new UI layer, and new physics mechanic in one unexplained step.

## 6. Verification

A test should be concrete and observable.

Good examples:

- the cannon stops at the documented angle;
- drag aims without firing;
- one tap creates one cannonball;
- the shot ends only after every bonus ball exits;
- each caught ball returns one ammunition;
- a destroyed target awards no more points;
- a restarted level restores level-supplied assistance;
- offline progress submits after reconnection.

“Runs without crashing” is useful but is not enough when a rule has specific expected behavior.

## 7. Tony verification

Where behavior is visual or experiential, Tony performs the final practical check.

The AI partner should provide:

- what to open;
- what to press;
- what should happen;
- what would indicate a fault.

Instructions should be short, complete, and directly executable.

## 8. Debugging rule

When a test fails:

1. preserve the exact symptom;
2. inspect the owning component first;
3. identify the cause before redesigning;
4. make the smallest stable correction;
5. rerun the failed test;
6. rerun nearby tests that could be affected;
7. document a structural lesson if one exists.

Do not solve a local fault by moving responsibility into an unrelated component.

## 9. Commit rule

Create one commit per verified work unit where practical.

A commit should:

- contain only intended related files;
- have a descriptive message;
- leave the project runnable;
- correspond to an understandable project step.

Before committing:

- inspect changed files;
- exclude unrelated local work;
- confirm the relevant test;
- update documentation when the behavior changed.

## 10. Documentation ownership

Update the document that owns the decision:

- game identity: `00_PROJECT_OVERVIEW.md`;
- game rules: `01_GAME_RULES.md`;
- scoring and objectives: `02_SCORING_AND_OBJECTIVES.md`;
- architecture and folders: `03_PROJECT_STRUCTURE.md`;
- components: `04_COMPONENTS.md`;
- level design: `05_LEVEL_DESIGN.md`;
- production order: `06_BUILD_PLAN.md`;
- working method: `07_WORKFLOW.md`;
- important decisions and reversals: `08_DECISION_LOG.md`;
- deferred ideas: `BACKLOG.md`.

Do not leave an important project rule only in chat.

## 11. Decision changes

A prior decision may be changed when testing gives a good reason.

When changing it:

1. state the old decision;
2. state the observed problem;
3. state the new decision;
4. update the owning document;
5. add the change to `08_DECISION_LOG.md`;
6. identify whether existing code or levels need migration.

Changing a decision is not failure. Changing it without recording the reason creates future confusion.

## 12. Backlog handling

When a new idea appears:

- decide whether the active phase requires it;
- if not, add it to the backlog;
- include a short reason or possible benefit;
- note the earliest relevant phase;
- continue the active task.

Backlog entries are not promises or automatic scope.

## 13. Phase completion

Before marking a phase complete:

- every phase deliverable exists;
- the defined verification has been performed;
- known blockers are resolved;
- deferred non-blockers are recorded;
- documentation matches implementation;
- commits are pushed;
- the build plan status is updated.

A phase can be verified before it is polished. Presentation belongs in its own phase unless readability blocks testing.

## 14. Mobile testing

Early:

- desktop Godot testing is continuous;
- Android is tested at input, physics, and complete-loop milestones.

Later:

- test mobile frequently for UI, touch, graphics, effects, audio, performance, ads, purchases, and platform lifecycle.

A desktop result does not prove mobile touch or presentation quality.

## 15. Ending a work session

End with a short checkpoint:

```text
Completed:
Verified:
Last commit:
Next work unit:
Known issue:
Relevant document:
```

This checkpoint makes it possible to resume after a break without reconstructing the conversation.

## 16. Scope protection

Do not:

- begin another phase because the current one feels slow;
- add final art while foundation behavior is still unstable;
- tune many levels before global scoring works;
- build online services before offline progression is stable;
- introduce future power-ups during v1 component work;
- restructure verified systems without a concrete problem.

## 17. Success condition

The workflow succeeds when progress remains understandable, testable, documented, and enjoyable—even when development pauses for weeks or months.
