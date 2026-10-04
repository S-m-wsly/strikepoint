# STRIKEPOINT

A 3v3 objective-combat prototype built with Godot 4.

## Core rule

Destroy both enemy outer targets to unlock the enemy Main Tower. Destroying the Main Tower wins immediately.

If the 3-minute timer expires first, the higher score wins.

## Prototype controls

- WASD / Arrow keys: Move
- Space: Basic attack
- 1 / 2 / 3: Abilities

## Characters

- Kael — Archer / Scout
- Nyx — Shooter / Speedster
- Jax Ryder — Gunslinger / Tactician
- Orion — Tank / Support
- Zuri — Engineer / Area Control
- Kage — Assassin / Disruptor

## Current prototype

This version intentionally uses procedural primitive 3D visuals so the complete gameplay loop can be tested before final art and animation are added.

## Android

The repository includes a GitHub Actions workflow intended to build an Android APK using Godot's Android export tooling. For a signed production APK, add the appropriate Android keystore/export credentials as repository secrets.

## Next development targets

1. Improve character-specific abilities.
2. Add proper objective health bars and attack feedback.
3. Add touch controls.
4. Add polished character models/animations.
5. Improve AI team tactics.
6. Add audio and VFX.
7. Add online multiplayer in a later milestone.


## Mobile controls

The prototype includes basic on-screen movement and combat buttons in landscape orientation. Keyboard controls remain available for desktop testing.
