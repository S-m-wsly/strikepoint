# STRIKEPOINT — 3v3 Objective Combat Game
## Complete Game Design & Technical Specification for Claude Code / GitHub / Android APK

**Document status:** Master implementation specification  
**Target platform:** Android (APK), with architecture suitable for future PC/Web builds  
**Recommended engine:** Godot 4.x  
**Primary deliverable:** A playable 3v3 arena game prototype that can be built into an Android APK through GitHub Actions  
**Game type:** Team-based third-person/top-down hybrid action arena, objective destruction, hero abilities, power-up control  
**Match length:** 3 minutes  
**Teams:** Red vs Blue  
**Players per team:** 3  
**Core objective:** Destroy the enemy's two outer targets to unlock the enemy Main Tower, then destroy the Main Tower/Final Flag for an immediate win. Enemy eliminations and objective damage also generate points.

---

# 1. EXECUTIVE VISION

STRIKEPOINT is a fast, three-minute 3v3 competitive action game.

Two teams—**Team Red** and **Team Blue**—fight on a symmetrical arena. Each team's base contains three objectives:

1. **Target A**
2. **Target B**
3. **Main Tower / Final Flag**

The first two targets are accessible from the beginning. The Main Tower is protected and cannot be destroyed until both outer targets belonging to that team have been destroyed.

The intended match flow is:

**Spawn → contest the center → attack either outer target → destroy both outer targets → Main Tower unlocks → assault final tower → instant victory**

Players also receive points for eliminating opponents. Therefore, a team can still compete for a point victory even if it is unable to reach the final tower.

The game should feel:

- Fast
- Tactical
- Easy to understand
- Difficult to master
- Character-driven
- Visually striking
- Suitable for short mobile sessions
- Built around meaningful decisions rather than constant fighting

---

# 2. IMPORTANT DESIGN PRINCIPLE

The game must NOT feel like a simple deathmatch with towers added.

The primary objective is always:

> **Destroy the enemy objectives.**

Kills are secondary.

A team should be rewarded for attacking objectives, controlling routes, protecting its own targets, and using character abilities intelligently.

A player who gets many kills but ignores objectives should not automatically dominate the match.

---

# 3. MATCH RULES

## 3.1 Teams

There are two teams:

### Team Blue
- Blue-colored UI
- Blue spawn
- Blue Target A
- Blue Target B
- Blue Main Tower
- Blue Final Flag/Core

### Team Red
- Red-colored UI
- Red spawn
- Red Target A
- Red Target B
- Red Main Tower
- Red Final Flag/Core

Each team selects exactly **3 characters**.

For the initial prototype, duplicate characters should be allowed unless a future hero-lock system is added.

---

# 4. MATCH TIMER

Each match lasts a maximum of:

**3 minutes / 180 seconds**

The timer begins when the match starts.

Recommended presentation:

`03:00`

and counts down:

`02:59 → 02:58 → ... → 00:00`

## 4.1 Main Tower Victory

If a team destroys the enemy Main Tower before the timer expires:

**IMMEDIATE VICTORY**

The remaining timer does not matter.

Example:

Blue destroys Red Target A.  
Blue destroys Red Target B.  
Red Main Tower unlocks.  
Blue destroys Red Main Tower at 01:17.

Blue immediately wins.

---

# 5. END CONDITIONS

A match can end in three ways.

## Condition A — Main Tower Destroyed

If Team Blue destroys Team Red's Main Tower:

**Blue wins immediately.**

If Team Red destroys Team Blue's Main Tower:

**Red wins immediately.**

## Condition B — Timer Expires

At 00:00, calculate the match score.

The team with the higher score wins.

## Condition C — Tie

If the score is tied at 00:00:

Use the following tiebreaker:

1. Greater combined objective damage dealt
2. If still tied, greater number of enemy eliminations
3. If still tied, declare a draw for the prototype

A future version may introduce sudden death.

---

# 6. SCORING SYSTEM

The scoring system should be configurable through a single game-balance file.

Recommended starting values:

| Action | Suggested Points |
|---|---:|
| Enemy elimination | +1 |
| Destroy Target A | +10 |
| Destroy Target B | +10 |
| Damage to enemy objective | Small score contribution |
| Destroy Main Tower | Instant victory |

The exact numbers should be constants and NOT hardcoded throughout the project.

Use a configuration object such as:

```text
GameBalance:
    match_duration = 180
    kill_points = 1
    target_destroy_points = 10
    main_tower_victory = true
```

The developer should be able to change these values without rewriting gameplay code.

---

# 7. ARENA MAP

## 7.1 Overall Layout

The arena should be symmetrical.

The map is approximately divided into:

```text
                 TEAM RED BASE

          [RED TARGET A] [RED TARGET B]
                  \       /
                   \     /
                RED MAIN TOWER
                       |
                 UPPER AREA
                       |
              🟣 POWER ZONES
                       |
                 CENTRAL AREA
              /                  \
        SIDE ROUTE             SIDE ROUTE
              \                  /
               🟣 POWER ZONES
                       |
                 LOWER AREA
                       |
          [BLUE TARGET A] [BLUE TARGET B]
                  \       /
                       |
                 TEAM BLUE BASE
```

The actual visual map should be more complex and attractive than this ASCII representation.

---

# 8. THREE PRIMARY ROUTES

The arena should have three major combat routes.

## 8.1 Left Route

Purpose:

- Flanking
- Target A access
- Ambushes
- Cover-heavy engagements

Characteristics:

- Moderate travel time
- More environmental cover
- Less direct than center
- Suitable for mobile characters

## 8.2 Middle Route

Purpose:

- Fastest route
- High-risk/high-reward combat
- Central contesting
- Main team fights

Characteristics:

- Shortest distance
- More exposed
- Strong visibility
- Central power-up access
- Should naturally attract both teams

## 8.3 Right Route

Purpose:

- Flanking
- Target B access
- Alternate attack route
- Defensive rotations

Characteristics similar to the Left Route.

---

# 9. CENTRAL AREA

The central arena is the primary contested zone.

It should contain:

- Open combat space
- Cover objects
- Elevated positions
- A central visual landmark
- At least one contested purple power-up area
- Multiple approaches
- Enough space for 3v3 combat

The central area should NOT contain the final objective.

Its purpose is to create conflict between teams before they reach the outer objectives.

---

# 10. HIGH-GROUND AREAS

Purple-marked high-ground areas may be used for:

- Tactical positioning
- Sniping
- Long-range attacks
- Vision
- Ambushes

High ground should provide an advantage but never make a position impossible to attack.

Every high-ground position should have at least two ways to reach it.

---

# 11. OBJECTIVES

Each team has exactly three structures.

## 11.1 Target A

Target A is one of the first objectives.

It:

- Can be attacked immediately
- Has its own health pool
- Gives points when destroyed
- Has defensive surroundings
- Has cover nearby
- Is visually color-coded to the owning team

Recommended visual:

A futuristic energy reactor/core mounted on a reinforced pedestal.

Blue team:

- Blue energy
- Blue holographic markings
- Blue shield ring

Red team:

- Red energy
- Red holographic markings
- Red shield ring

---

# 12. TARGET B

Target B functions identically to Target A but is positioned on the opposite side of the base.

Target A and Target B should NOT be identical in gameplay geography.

For example:

### Target A
- More cover
- Narrower approach
- Better for defensive characters

### Target B
- More open area
- Multiple entrances
- Better for aggressive/mobile characters

This creates strategic choice.

---

# 13. MAIN TOWER

The Main Tower is the final objective.

It should be dramatically larger than the first two targets.

Suggested appearance:

- Large fortress-like tower
- Giant energy core
- Team-colored banners
- Defensive structures
- Central vertical beam
- Large final flag/core
- Strong visual silhouette visible from most of the map

The Main Tower should visually communicate:

> "This is the thing you are trying to destroy."

---

# 14. MAIN TOWER LOCK STATE

At the beginning of the match:

**Main Tower = LOCKED**

Display:

`MAIN TOWER LOCKED`

Requirements:

- Target A destroyed
- Target B destroyed

Once both are destroyed:

**Main Tower = UNLOCKED**

Trigger:

- Large map announcement
- UI announcement
- Sound effect
- Visual beam activation
- Objective marker
- Main Tower shield disappears

Example:

> **RED MAIN TOWER UNLOCKED!**

or

> **BLUE MAIN TOWER UNLOCKED!**

depending on the team being attacked.

---

# 15. OBJECTIVE STATE MACHINE

Each outer objective should have states:

```text
ACTIVE
↓
UNDER_ATTACK
↓
DESTROYED
```

The Main Tower:

```text
LOCKED
↓
TARGET A DESTROYED
+
TARGET B DESTROYED
↓
UNLOCKED
↓
UNDER_ATTACK
↓
DESTROYED
↓
MATCH WON
```

---

# 16. OBJECTIVE HEALTH

Objective health must be configurable.

Suggested starting prototype values:

```text
Target A: 1000 HP
Target B: 1000 HP
Main Tower: 2000 HP
```

These values are placeholders for balancing.

Do not build gameplay logic around these exact numbers.

Store them in:

```text
GameBalance.gd
```

or equivalent configuration.

---

# 17. OBJECTIVE DEFENSE

Targets should not simply stand in the open.

Each target should have:

- Walls
- Crates
- Cover
- Small defensive platforms
- Multiple entrances
- Some elevated terrain

However, do not create a maze.

Players should immediately understand how to reach the objective.

---

# 18. PURPLE POWER-UP SYSTEM

Purple zones are a major secondary gameplay system.

The purple visual language represents:

**Power / Enhancement / Special Resources**

These zones are neutral.

Both teams can use them.

---

# 19. TYPES OF PURPLE POWER-UPS

Initial prototype:

## Health Boost

Restores a percentage of maximum health.

Example:

```text
+30% max-health equivalent
```

## Speed Boost

Temporarily increases movement speed.

Example:

```text
+20% movement speed
Duration: 8 seconds
```

## Damage Boost

Temporarily increases outgoing damage.

Example:

```text
+20% damage
Duration: 8 seconds
```

## Armor Boost

Reduces incoming damage.

Example:

```text
20% damage reduction
Duration: 8 seconds
```

## Ability Charge

Instantly restores a percentage of ability charge.

Example:

```text
+25% ability energy
```

## Ultimate Charge

Instantly increases ultimate/ultimate-equivalent charge.

---

# 20. POWER-UP SPAWNING

Power-ups should NOT respawn continuously.

Recommended:

- Spawn at match start
- Enter cooldown after pickup
- Respawn after a configurable delay

Example:

```text
Power-up respawn: 20 seconds
```

The exact value should be configurable.

---

# 21. POWER-UP UI

When a player is near a power-up:

Show:

```text
PICK UP
Health Boost
```

When active:

```text
HEALTH BOOST
06.2s
```

The player should be able to understand exactly what the effect does.

---

# 22. CHARACTER SYSTEM

The game contains six initial playable characters.

The six characters are:

1. Kael
2. Nyx
3. Jax Ryder
4. Orion
5. Zuri
6. Kage

Each character has:

- Role
- Base health
- Damage
- Movement speed
- Defense
- Abilities
- Growth/progression
- Strengths
- Weaknesses

The characters must feel different.

---

# 23. KAEL — THE VERDANT MARK

## Role

Archer / Scout / Survivalist

## Personality

Calm, calculated and connected with nature.

## Combat Identity

Long-range precision and battlefield control.

## Abilities

### Nature's Mark

Arrows track enemies.

### Vine Step

Short-range teleport to surfaces covered in flora.

### Thorn Barrage

Creates a denial area with explosive vines.

## Gameplay

Kael should excel at:

- Long-range attacks
- Tracking
- Ambushes
- Objective defense
- Area denial

Weakness:

- Lower close-range survivability
- Vulnerable when cornered

---

# 24. NYX — THE CHAOS KID

## Role

Shooter / Speedster / Saboteur

## Personality

Energetic, chaotic and unpredictable.

## Combat Identity

Fast movement and disruptive attacks.

## Abilities

### Trigger Rush

Increases fire rate and movement speed.

### Painted Bullets

Bullets mark enemies, causing them to take additional damage.

### Chaos Grenade

Explosive grenade with random effects such as:

- Stun
- Slow
- Confusion

## Gameplay

Nyx should excel at:

- Chasing
- Escaping
- Harassment
- Finishing weakened enemies
- Disrupting objectives

Weakness:

- Lower durability
- Requires aggressive positioning

---

# 25. JAX RYDER — THE LAST GUNSLINGER

## Role

Gunslinger / Tactician / Bounty Hunter

## Personality

Quiet, sharp-tongued and justice-driven.

## Combat Identity

Precision firearms and tactical target selection.

## Abilities

### Deadeye

Marks multiple targets for a high-damage shot.

### Bullet Time

Temporarily slows the player's perception/gameplay around them, improving precision.

### Ricochet

Bullets bounce between enemies.

## Gameplay

Jax should excel at:

- Target elimination
- Mid-range combat
- Finishing key opponents
- Punishing exposed players

Weakness:

- Requires accuracy
- Less effective when surrounded

---

# 26. ORION — THE PROTOCOL

## Role

Cyborg / Tank / Support

## Personality

Logical, protective and evolving.

## Combat Identity

Durability, protection and support.

## Abilities

### Adaptive Armor

Automatically resists a selected/current damage type.

### Drone Link

Deploys a support drone capable of:

- Healing
- Shielding
- Scanning

### Overclock

Temporarily boosts:

- Strength
- Speed
- Ability effectiveness

## Gameplay

Orion should excel at:

- Holding objectives
- Protecting teammates
- Front-line combat
- Surviving focus fire

Weakness:

- Lower mobility
- Larger target profile

---

# 27. ZURI — THE WILD SPARK

## Role

Engineer / Trickster / Area Control

## Personality

Joyful, witty and brilliant.

## Combat Identity

Gadgets and battlefield manipulation.

## Abilities

### Bounce Bombs

Grenades bounce and split.

### Gadget Swarm

Deploys a swarm of mini-drones.

### Power Up!

Temporarily buffs allies with random enhancements.

## Gameplay

Zuri should excel at:

- Area control
- Team support
- Traps
- Objective defense
- Creating chaos

Weakness:

- Relies on setup
- Less effective if constantly pressured

---

# 28. KAGE — THE SHADOW BLADE

## Role

Assassin / Illusionist / Disruptor

## Personality

Mysterious, ruthless and philosophical.

## Combat Identity

Stealth, deception and burst damage.

## Abilities

### Shadow Step

Instant teleport behind blinded enemies.

### Mirror Image

Creates clones to confuse enemies.

### Soul Cut

High-damage strike that reduces enemy abilities.

## Gameplay

Kage should excel at:

- Assassination
- Flanking
- Backline disruption
- Eliminating vulnerable targets

Weakness:

- Fragile
- Punished heavily if detected

---

# 29. CHARACTER STATS

Each character should have configurable stats.

Recommended base stat fields:

```text
max_health
attack_damage
attack_speed
movement_speed
armor
ability_power
attack_range
critical_chance
critical_damage
cooldown_reduction
```

Not every character needs every stat to be unique.

---

# 30. CHARACTER GROWTH

The user's original concept includes character growth.

Growth should NOT make the first player to get one kill permanently unstoppable.

Use controlled progression.

Recommended system:

### In-match growth

Players gain XP from:

- Enemy kills
- Objective damage
- Objective destruction
- Assists
- Power-up interaction
- Supporting teammates

XP produces temporary levels.

Example:

```text
Level 1 → Level 2 → Level 3
```

Maximum level during a 3-minute match should initially be low.

Recommended:

**Maximum Level: 3**

This prevents excessive snowballing.

---

# 31. GROWTH EXAMPLES

Level 1:

Base statistics.

Level 2:

Small increase such as:

```text
+5% health
+5% damage
```

Level 3:

Another modest improvement:

```text
+5% health
+5% damage
+ability improvement
```

These numbers are initial balancing suggestions, not fixed requirements.

---

# 32. IMPORTANT ANTI-SNOWBALL RULE

A player who gets ahead should become stronger.

However:

> They should NOT become impossible to kill.

Growth should remain modest.

The match is only three minutes, so the game should emphasize decisions and team play over grinding.

---

# 33. RESPAWN SYSTEM

Because the game is 3v3, deaths should matter but should not remove a player from the match for too long.

Recommended initial respawn:

**8 seconds**

Potential scaling:

```text
Early match: 6–8 sec
Late match: 8–10 sec
```

When a player dies:

- Show death screen briefly
- Display respawn countdown
- Camera may follow teammates
- Player respawns at team spawn or a safe team checkpoint

---

# 34. SPAWN PROTECTION

Players should have brief spawn protection.

Recommended:

**2 seconds**

During protection:

- Player cannot attack
- Player cannot damage objectives
- Incoming damage is blocked

Protection ends immediately if the player performs an attack.

---

# 35. TEAM SPAWNS

Each team has a secure spawn area.

Team Blue:

At the southern end of the map.

Team Red:

At the northern end.

Spawn areas should be:

- Clearly identifiable
- Difficult for enemies to enter
- Visually team-colored
- Large enough for three characters

---

# 36. MAP SYMMETRY

The map should be as symmetrical as possible.

Do NOT mirror every object perfectly.

Instead mirror:

- Travel distances
- Objective placement
- Number of entrances
- Power-up availability
- High-ground opportunities

Visual details can differ so the environment does not feel repetitive.

---

# 37. CAMERA

Recommended camera:

**Third-person angled/isometric hybrid.**

For the mobile prototype:

- Camera follows player
- Slightly elevated
- Player remains near center
- Camera can rotate if practical
- Avoid excessive camera movement

The prototype should prioritize gameplay readability over cinematic camera behavior.

---

# 38. MOBILE CONTROLS

Primary control layout:

### Left side

Virtual joystick.

### Right side

Action buttons:

- Basic attack
- Ability 1
- Ability 2
- Ability 3 / Ultimate
- Interact

Recommended:

```text
       [Ability 1]

[Joystick]       [Attack]

       [Ability 2]
       [Ability 3]
```

The exact UI can be adjusted after testing.

---

# 39. AUTO-AIM / TARGET ASSIST

Because the game is designed for mobile, some aim assistance is recommended.

Do NOT make it fully automatic.

Use:

- Soft target acquisition
- Directional aim
- Short target magnetism
- Ability-specific targeting

Players should still feel responsible for their attacks.

---

# 40. OBJECTIVE UI

At the top of the screen:

```text
BLUE  12     02:14     RED  9

BLUE OBJECTIVES          RED OBJECTIVES
[✓] [✓] [LOCK]           [✓] [✗] [LOCK]
```

A cleaner final implementation can use icons rather than text.

---

# 41. MINIMAP

Include a small minimap.

It should show:

- Blue teammates
- Red teammates when visible
- Objective locations
- Main Tower
- Power-up locations
- Player position
- Major map routes

Do not permanently reveal enemies through walls.

---

# 42. VISIBILITY

Enemy players should only appear on the minimap when:

- Within detection range
- Revealed by an ability
- Attacking
- Otherwise detected by a specific game mechanic

Kage should especially benefit from this system.

---

# 43. DAMAGE TYPES

The prototype may begin with one universal damage type.

Future-ready architecture should support:

```text
physical
energy
explosive
poison
true
```

Orion's Adaptive Armor can later interact with this system.

---

# 44. ABILITY SYSTEM

Abilities should use a common interface.

Each ability should have:

```text
name
description
cooldown
cast_time
range
damage
duration
target_type
effect_type
```

The system should support:

- Damage
- Healing
- Buff
- Debuff
- Teleport
- Projectile
- Area of effect
- Summon
- Shield
- Mark
- Stealth
- Knockback

---

# 45. GAME STATE ARCHITECTURE

Recommended high-level states:

```text
MAIN_MENU
CHARACTER_SELECT
MATCH_LOADING
MATCH_START
MATCH_ACTIVE
MATCH_PAUSED
MATCH_END
RESULTS
```

During MATCH_ACTIVE:

```text
PLAYING
RESPAWNING
OBJECTIVE_UNLOCK
VICTORY_SEQUENCE
DEFEAT_SEQUENCE
```

---

# 46. RECOMMENDED GODOT PROJECT STRUCTURE

Use a clean architecture.

```text
/
├── project.godot
├── README.md
├── LICENSE
├── game/
│   ├── scenes/
│   │   ├── main_menu.tscn
│   │   ├── character_select.tscn
│   │   ├── arena.tscn
│   │   ├── results.tscn
│   │   ├── characters/
│   │   ├── objectives/
│   │   ├── powerups/
│   │   └── ui/
│   │
│   ├── scripts/
│   │   ├── game_manager.gd
│   │   ├── match_manager.gd
│   │   ├── team_manager.gd
│   │   ├── score_manager.gd
│   │   ├── objective_manager.gd
│   │   ├── powerup_manager.gd
│   │   ├── character_base.gd
│   │   ├── ability_base.gd
│   │   ├── projectile.gd
│   │   └── camera_controller.gd
│   │
│   ├── characters/
│   │   ├── kael/
│   │   ├── nyx/
│   │   ├── jax_ryder/
│   │   ├── orion/
│   │   ├── zuri/
│   │   └── kage/
│   │
│   ├── data/
│   │   ├── characters/
│   │   ├── abilities/
│   │   ├── objectives/
│   │   └── game_balance.gd
│   │
│   ├── map/
│   │   ├── arena_layout.tscn
│   │   ├── objectives/
│   │   ├── power_zones/
│   │   └── environment/
│   │
│   └── ui/
│       ├── hud/
│       ├── menus/
│       └── mobile_controls/
│
├── assets/
│   ├── characters/
│   ├── environment/
│   ├── effects/
│   ├── icons/
│   ├── ui/
│   ├── audio/
│   └── fonts/
│
└── .github/
    └── workflows/
        └── android-build.yml
```

---

# 47. INITIAL PROTOTYPE PRIORITY

Do NOT attempt to create the complete polished game first.

Build in this order:

## Phase 1 — Playable Core

Implement:

- Arena
- Two teams
- 3 players per team
- Character movement
- Basic attacks
- Health
- Death
- Respawn
- Two objectives per team
- Main Tower
- Three-minute timer
- Score
- Victory/defeat

## Phase 2 — Characters

Implement the six characters.

Start with basic versions of their abilities.

## Phase 3 — Power-ups

Implement purple zones.

## Phase 4 — UI

Implement:

- HUD
- Timer
- Score
- Objectives
- Minimap
- Ability buttons
- Character health
- Respawn

## Phase 5 — Visual polish

Add:

- Character models
- Effects
- Animations
- Sounds
- Environmental details
- Particles

## Phase 6 — Android optimization

Optimize:

- Draw calls
- Texture sizes
- Effects
- Physics
- Lighting
- UI scaling

---

# 48. OFFLINE PROTOTYPE REQUIREMENT

The first APK should work without requiring a server.

Recommended initial architecture:

**Single-device local simulation**

The game can simulate both teams using AI-controlled teammates/enemies.

This is extremely important because implementing true online multiplayer significantly increases project complexity.

---

# 49. AI SYSTEM

For the prototype, AI-controlled characters should be available.

Basic AI states:

```text
SPAWN
↓
MOVE_TO_CENTER
↓
CHOOSE_OBJECTIVE
↓
ATTACK_OBJECTIVE
↓
FIGHT_ENEMY
↓
RETREAT
↓
GET_POWERUP
↓
DEFEND
↓
RESPAWN
```

AI priorities should be weighted.

Example:

```text
If enemy Main Tower is unlocked:
    attack Main Tower

Else if enemy Target A is vulnerable:
    attack Target A

Else if enemy Target B is vulnerable:
    attack Target B

Else:
    contest center

If health is low:
    retreat / seek healing
```

---

# 50. TEAM AI

AI teammates should not all perform the same action.

A 3-person team should ideally behave as:

- Attacker
- Defender
- Roamer

For example:

### Attacker
Pushes objectives.

### Defender
Protects friendly targets.

### Roamer
Controls center and power-ups.

This makes the prototype feel like a real team game.

---

# 51. ONLINE MULTIPLAYER — FUTURE VERSION

Do NOT require online multiplayer for the first APK.

However, the code should avoid making future networking impossible.

Gameplay systems should separate:

- Input
- Game state
- Character state
- Damage
- Objective state
- Score

Future online architecture could use a server-authoritative model.

---

# 52. ART DIRECTION

The provided character reference image establishes the visual direction.

Overall style:

**Stylized cinematic sci-fi/fantasy action.**

Characteristics:

- High contrast
- Strong character silhouettes
- Team-colored energy
- Dramatic lighting
- Detailed armor/clothing
- Neon ability effects
- Dark environmental backgrounds
- Vibrant ability colors

Character color identities:

| Character | Primary Visual Identity |
|---|---|
| Kael | Green |
| Nyx | Red |
| Jax Ryder | Gold |
| Orion | Blue |
| Zuri | Purple |
| Kage | Black / Red |

The map should use neutral environmental colors so character/team effects remain readable.

---

# 53. TEAM COLORS

Team Blue:

Primary:

`#1976D2`

Secondary:

`#64B5F6`

Energy:

Bright blue/cyan.

Team Red:

Primary:

`#C62828`

Secondary:

`#EF5350`

Energy:

Bright red/orange.

Purple power system:

Primary:

`#8E24AA`

Secondary:

`#CE93D8`

Power-up effects should clearly look neutral rather than belonging to either team.

---

# 54. AUDIO DIRECTION

The prototype should include basic audio placeholders.

Required sound categories:

- Weapon fire
- Hit
- Critical hit
- Character ability
- Objective hit
- Objective destroyed
- Main Tower unlocked
- Player death
- Respawn
- Power-up pickup
- Match countdown
- Victory
- Defeat

Important:

Main Tower unlock should have a distinctive audio cue.

---

# 55. MATCH COUNTDOWN

Before the match begins:

```text
3
2
1
FIGHT!
```

Use large center-screen text.

After `FIGHT!`, the timer begins.

---

# 56. MATCH END SCREEN

Victory screen:

```text
VICTORY

BLUE TEAM

Main Tower Destroyed

Score: 27

Kills: 7
Objectives: 2
```

Defeat screen:

```text
DEFEAT

RED TEAM

Score: 24
```

Exact layout is flexible.

---

# 57. CHARACTER SELECT SCREEN

Character cards should contain:

- Character portrait
- Name
- Role
- Health
- Damage
- Speed
- Difficulty
- Abilities
- Short description

The six characters should use the provided character reference image as the initial visual/design reference.

---

# 58. DIFFICULTY

Suggested:

### Kael
Medium

### Nyx
Medium

### Jax Ryder
Medium

### Orion
Easy/Medium

### Zuri
Medium/Hard

### Kage
Hard

Difficulty should be based on mechanical complexity, NOT power.

---

# 59. GAME BALANCE PRINCIPLES

No character should be universally best.

Each character should have:

- Strengths
- Weaknesses
- Counters
- Team synergies

Examples:

Orion can protect Zuri while she sets up gadgets.

Kage can exploit enemies distracted by Orion.

Kael can provide ranged support while Nyx attacks.

Jax can finish targets marked by other characters.

---

# 60. OBJECTIVE DAMAGE RULE

Players must be able to damage objectives with normal attacks and/or abilities.

However, some abilities may be restricted from damaging structures.

Each ability should specify:

```text
can_damage_players
can_damage_objectives
```

Example:

```text
Soul Cut:
can_damage_players = true
can_damage_objectives = false
```

This gives the designer fine control over balance.

---

# 61. OBJECTIVE ATTACK FEEDBACK

When an objective is attacked:

- Health bar appears
- Hit effects play
- Structure reacts
- Team notification appears

Example:

> **BLUE TARGET A UNDER ATTACK**

When destroyed:

> **BLUE TARGET A DESTROYED**

When both are destroyed:

> **BLUE MAIN TOWER UNLOCKED**

---

# 62. OBJECTIVE HEALTH BARS

Objective health bars should be visible when:

- Player is nearby
- Objective is damaged
- Objective is currently under attack

Do not permanently cover the screen with health bars.

---

# 63. MAP POWER-UP LOCATIONS

Initial map should contain approximately:

- 2 health zones
- 2 speed/damage zones
- 1 central high-value power-up

Total:

**5 neutral power-up locations**

The central power-up should be more valuable and more dangerous to contest.

---

# 64. POWER-UP CONTEST DESIGN

Power-ups should create tactical decisions.

Example:

A player is attacking Target A.

A nearby purple Health Boost becomes available.

The player must decide:

**Continue attacking objective OR leave objective to secure health.**

This is intentional.

---

# 65. ENVIRONMENT

Recommended environment:

**Floating fortress / ruined futuristic citadel**

Features:

- Floating platforms
- Bridges
- Ancient stone structures
- Futuristic machinery
- Energy cores
- Trees/vegetation
- Broken ruins
- Vertical cliffs
- Fog/clouds below the arena

The arena should feel like a battlefield suspended above a larger world.

---

# 66. PERFORMANCE TARGET

Target Android performance:

**30 FPS minimum on mid-range devices**

Preferred:

**60 FPS on capable devices**

Avoid excessive:

- Dynamic shadows
- Particle effects
- High-poly meshes
- Transparent objects
- Real-time lights

Use baked/static lighting where practical.

---

# 67. MOBILE RESOLUTION

The game should support:

- 16:9
- 18:9
- 19.5:9
- Modern tall Android displays

UI must use responsive anchors.

Never hardcode UI positions based on one resolution.

---

# 68. APK BUILD

The GitHub repository should include a GitHub Actions workflow.

Example workflow responsibilities:

1. Checkout repository
2. Install/configure Godot
3. Import project
4. Run basic validation
5. Build Android APK
6. Upload APK as GitHub Actions artifact

The workflow should be designed so a developer can download the generated APK from the Actions run.

---

# 69. GITHUB ACTIONS REQUIREMENTS

Create:

```text
.github/workflows/android-build.yml
```

The workflow should:

- Trigger on push
- Trigger on manual workflow dispatch
- Build the Android project
- Fail if the project does not compile
- Upload the APK

Do not require paid services for the basic build.

---

# 70. PROJECT CONFIGURATION

The project must define:

```text
Application Name:
STRIKEPOINT

Package:
com.strikepoint.game

Version:
0.1.0

Orientation:
Landscape
```

Landscape is strongly recommended for the 3v3 combat UI.

---

# 71. INPUT ACTIONS

Define centralized actions:

```text
move_up
move_down
move_left
move_right

attack

ability_1
ability_2
ability_3

interact

open_map
pause
```

Touch controls should map to the same gameplay actions.

This allows keyboard testing in the editor while preserving mobile compatibility.

---

# 72. SAVE SYSTEM

The prototype only needs to save:

- Settings
- Audio volume
- Graphics settings
- Selected character
- Basic progression if implemented

Do NOT create a complex account system for the first prototype.

---

# 73. SETTINGS

Include:

- Music volume
- SFX volume
- Graphics quality
- Vibration on/off
- Aim assist strength
- UI scale

---

# 74. VIBRATION

Mobile feedback should be used for:

- Taking heavy damage
- Objective destroyed
- Power-up pickup
- Player death
- Main Tower unlock
- Victory

Keep it subtle.

---

# 75. ACCESSIBILITY

Include:

- Adjustable UI scale
- Color-safe objective icons
- Clear text labels
- Audio cues
- Visual indicators
- Optional vibration

Do not rely exclusively on red vs blue color.

Use shapes/icons too.

---

# 76. DEBUG MODE

Add a developer/debug menu accessible only in development builds.

Options:

```text
[ ] God Mode
[ ] Infinite Ability
[ ] Instant Kill
[ ] Destroy Target A
[ ] Destroy Target B
[ ] Unlock Main Tower
[ ] Spawn Power-Up
[ ] Add XP
[ ] Reset Match
```

This will dramatically speed up testing.

---

# 77. TEST CASES

The project must be tested against these scenarios.

## Test 1

Blue destroys Target A.

Expected:

- Target A destroyed
- Blue receives points
- Target B remains active
- Main Tower remains locked

## Test 2

Blue destroys Target B.

Expected:

- Target B destroyed
- Blue receives points
- Main Tower unlocks

## Test 3

Blue destroys both targets and then Main Tower.

Expected:

- Immediate Blue victory

## Test 4

Timer reaches zero.

Expected:

- Match stops
- Score calculated
- Higher score wins

## Test 5

Score tied at zero.

Expected:

- Tiebreaker calculation
- No crash

## Test 6

Player dies.

Expected:

- Death state
- Respawn timer
- Player returns to match

## Test 7

Player collects Health Boost.

Expected:

- Health increases
- Power-up enters cooldown
- UI shows effect

## Test 8

Player collects Speed Boost.

Expected:

- Speed increases temporarily
- Effect expires correctly

## Test 9

Main Tower is attacked before both outer targets are destroyed.

Expected:

- Damage is blocked
- Tower remains locked

## Test 10

Both targets destroyed at nearly the same time.

Expected:

- Main Tower unlocks exactly once

---

# 78. IMPORTANT CODE QUALITY REQUIREMENTS

Claude must NOT produce one enormous script.

Separate responsibilities.

Avoid:

```text
game.gd
```

containing every system.

Instead use modular components.

Recommended:

```text
MatchManager
ScoreManager
ObjectiveManager
CharacterManager
PowerupManager
UIManager
AIController
AbilitySystem
AudioManager
```

---

# 79. DATA-DRIVEN DESIGN

Character statistics should be stored as data.

Do not hardcode:

```text
if character == "Kael":
    health = ...
```

throughout gameplay code.

Instead use character data resources.

For example:

```text
CharacterData:
    character_name
    role
    max_health
    damage
    movement_speed
    abilities
```

This makes adding future characters easy.

---

# 80. FUTURE CHARACTER SUPPORT

The architecture should allow:

```text
Kael
Nyx
Jax
Orion
Zuri
Kage
```

plus future characters without rewriting the character system.

---

# 81. FUTURE GAME MODES

The architecture should leave room for:

- Ranked 3v3
- Casual 3v3
- 1v1
- 2v2
- Training
- Custom matches
- Capture-the-flag variant
- Time attack
- Survival

Do not implement these now.

---

# 82. TRAINING MODE

A simple training mode would be useful after the core prototype.

It should allow:

- One player
- Stationary targets
- Ability testing
- Damage numbers
- Character switching

---

# 83. DAMAGE NUMBERS

Optional but recommended.

Examples:

```text
124
CRITICAL 248
-80
+150
```

Use different visual treatment for:

- Damage
- Critical damage
- Healing
- Shield
- Objective damage

---

# 84. STATUS EFFECTS

Create a generic status system capable of supporting:

```text
slow
stun
blind
mark
silence
damage_boost
speed_boost
armor_boost
stealth
shield
heal_over_time
damage_over_time
```

---

# 85. DEATH LOG

Optional initial HUD:

```text
KAGE eliminated ORION
```

Keep it small.

---

# 86. KILL ASSISTS

Recommended.

If multiple players damage an enemy before they die:

- Killer receives kill point
- Assisting teammates receive assist credit

This encourages team play.

---

# 87. TEAM ROLES

Characters are NOT locked into traditional MMO classes.

Roles are tags.

Example:

Kael:

```text
ARCHER
SCOUT
SURVIVALIST
```

Nyx:

```text
SHOOTER
SPEEDSTER
SABOTEUR
```

Jax:

```text
GUNSLINGER
TACTICIAN
BOUNTY HUNTER
```

Orion:

```text
CYBORG
TANK
SUPPORT
```

Zuri:

```text
ENGINEER
TRICKSTER
AREA CONTROL
```

Kage:

```text
ASSASSIN
ILLUSIONIST
DISRUPTOR
```

---

# 88. CHARACTER SELECT BALANCE

The game should eventually discourage three identical characters if that produces unhealthy balance.

However:

**Do not enforce character uniqueness in version 0.1.**

Allow duplicates while the prototype is being tested.

---

# 89. VISUAL LANGUAGE

Every major gameplay system should have a visual language.

### Blue
Friendly objectives/team.

### Red
Enemy objectives/team.

### Purple
Neutral power/resource zones.

### Green
Kael-related effects.

### Red/orange
Nyx-related effects.

### Gold
Jax-related effects.

### Blue/cyan
Orion-related effects.

### Purple
Zuri-related effects.

### Black/red
Kage-related effects.

---

# 90. USER EXPERIENCE PRIORITY

A new player should understand within the first 10 seconds:

1. Who they are
2. Who their teammates are
3. Where the enemy is
4. Where the objectives are
5. What the timer is
6. What they need to destroy
7. How to attack

Do not overload the screen with information.

---

# 91. FIRST PLAYABLE PROTOTYPE

The minimum successful APK is:

- Main menu
- Character selection
- One arena
- Blue team
- Red team
- Three characters per team
- Movement
- Basic attack
- Health
- Death
- Respawn
- Target A
- Target B
- Main Tower
- Tower lock/unlock
- Three-minute timer
- Score
- Win/lose screen
- Basic AI
- Basic mobile controls

The six characters should be selectable, but the first prototype can use simplified placeholder abilities before every ability is fully polished.

---

# 92. DEVELOPMENT ORDER FOR CLAUDE

Claude should follow this sequence.

## Step 1
Create Godot project.

## Step 2
Create arena scene.

## Step 3
Create teams and spawn points.

## Step 4
Create player controller.

## Step 5
Create AI controller.

## Step 6
Create health/damage system.

## Step 7
Create objectives.

## Step 8
Create objective destruction logic.

## Step 9
Create Main Tower unlock logic.

## Step 10
Create scoring.

## Step 11
Create timer.

## Step 12
Create victory/defeat.

## Step 13
Create mobile UI.

## Step 14
Create character data.

## Step 15
Create six characters.

## Step 16
Create abilities.

## Step 17
Create power-ups.

## Step 18
Add audio/visual effects.

## Step 19
Optimize Android.

## Step 20
Create GitHub Actions APK build.

---

# 93. DEFINITION OF DONE

The first milestone is complete when:

- The project opens without errors.
- The game launches.
- Character selection works.
- A 3v3 match begins.
- Players can move.
- Players can attack.
- Players can damage enemies.
- Enemies can damage players.
- Players can die.
- Players respawn.
- Objectives can be damaged.
- Target A can be destroyed.
- Target B can be destroyed.
- Main Tower remains locked until both are destroyed.
- Main Tower unlocks after both are destroyed.
- Main Tower can be destroyed.
- Main Tower destruction immediately ends the match.
- Timer ends match at 0:00.
- Score determines winner when timer expires.
- Purple power-ups work.
- Android controls work.
- APK builds through GitHub Actions.

---

# 94. CLAUDE IMPLEMENTATION INSTRUCTION

Claude should treat this document as the **master design specification**.

When implementing:

1. Prefer a playable feature over placeholder documentation.
2. Build the smallest working version first.
3. Keep systems modular.
4. Keep balancing values configurable.
5. Avoid unnecessary dependencies.
6. Do not require paid APIs.
7. Do not require cloud infrastructure for the first prototype.
8. Ensure the project can build offline after dependencies are installed.
9. Ensure Android export is configured correctly.
10. Keep the code understandable enough for a student/developer to modify later.

If a design detail is not explicitly defined, choose the simplest implementation that preserves the intended gameplay.

Do NOT change the central game rule:

> **Destroy both enemy outer targets to unlock the enemy Main Tower. Destroying the Main Tower wins the match immediately.**

---

# 95. CORE GAME LOOP SUMMARY

```text
PLAYER SELECTS CHARACTER
        ↓
TEAM OF 3 FORMS
        ↓
MATCH STARTS — 03:00
        ↓
TEAM LEAVES SPAWN
        ↓
CONTEST CENTRAL AREA / POWER ZONES
        ↓
ATTACK TARGET A OR TARGET B
        ↓
TARGET DESTROYED
        ↓
ATTACK REMAINING TARGET
        ↓
BOTH TARGETS DESTROYED
        ↓
MAIN TOWER UNLOCKS
        ↓
TEAM PUSHES MAIN TOWER
        ↓
MAIN TOWER DESTROYED
        ↓
INSTANT VICTORY
```

Alternative:

```text
MATCH TIMER → 00:00
        ↓
CALCULATE SCORE
        ↓
HIGHER SCORE WINS
```

---

# 96. FINAL DESIGN PHILOSOPHY

STRIKEPOINT should feel like a game where every three-minute match tells a small story.

The opening is about positioning.

The middle is about choosing which objective to attack.

The power-up zones create moments of conflict.

Kills create opportunities.

Character abilities create tactical plays.

Destroying both outer objectives creates a dramatic turning point.

Then the Main Tower becomes vulnerable and the entire match can suddenly end.

The goal is not simply:

> "Kill everyone."

The goal is:

> **"Break through the enemy team, destroy their defenses, and strike the core before time runs out."**

---

# 97. ASSET REFERENCE

The supplied character lineup image should be treated as the primary visual reference for the initial six-character roster:

- KAEL — THE VERDANT MARK
- NYX — THE CHAOS KID
- JAX RYDER — THE LAST GUNSLINGER
- ORION — THE PROTOCOL
- ZURI — THE WILD SPARK
- KAGE — THE SHADOW BLADE

The reference establishes the intended cinematic character-card aesthetic and should guide future character art, UI portraits, color identity, and promotional assets.

Do not embed the image into the game automatically unless the developer has permission to use it as an actual game asset. It can instead be treated as a design reference.

---

# 98. VERSION ROADMAP

## Version 0.1
Playable offline prototype.

## Version 0.2
Improved character abilities, effects, power-ups and UI.

## Version 0.3
Improved AI and balancing.

## Version 0.4
Online multiplayer prototype.

## Version 0.5
Matchmaking/lobbies.

## Version 1.0
Polished public release candidate.

---

# 99. IMMEDIATE NEXT TASK

Create the GitHub-ready Godot project according to this specification.

The first generated APK does NOT need final art.

Use clean placeholders where necessary, but make the complete gameplay loop functional.

The priority order is:

**PLAYABLE > CORRECT > BALANCED > POLISHED**

Once the complete gameplay loop works, replace placeholders with final character art, animations, effects, sounds and environmental assets.
