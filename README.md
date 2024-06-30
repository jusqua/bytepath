# jusqua's BYTEPATH

A naive [BYTEPATH](https://store.steampowered.com/app/760330/BYTEPATH/) implementation as a final project for
CS50’s Introduction to Game Development based on [BYTEPATH Tutorial](https://github.com/a327ex/blog/issues/30).

## Description

This game it's a small, replayable, arcade score-chaser where the only goal is beat every enemy and survive.

The `Stage` state is responsible for managing the entire game and controlling the `Director` and `Area` game objects.

The `Director` is responsible for spawning enemies and resources, and count the game round to increase the difficulty by spawning more enemies.

The `Area` controls, renders and check collisions in the game world like enemies, resources and the `Player`.

The `Player` controls a ship that navigate in the `Stage` where enemies and resources appears, enemies can be beaten and resources can be collected.

The resources can be:
- `Boost`: increase boost gauge, `Player` uses boost to make ship faster or slower;
- `Health`: increase health gauge, `Player` uses health to keep alive and enemies and enemy project reduce this gauge;
- `Ammo`: increase ammo gauge, `Player` uses ammo to shoot special attacks;
- `Attack`: change attack type, `Player` use different types of attacks:
  - `Back`: shoot front and back;
  - `Double`: double shoot;
  - `Rapid`: shoot faster;
  - `Side`: shoot front and from both sides;
  - `Spread`: shoot faster and randomly;
  - `Triple`: triple shoot.

The enemies can be:
- `Rock`: common rock, just float around;
- `Shooter`: ship that spawns projectiles.

The game scenes are:
- `Console`: manage game start by showing a console where player can type commands:
  - `start`: attach `Stage` scene to start game;
  - `resolution`: change game resolution;
  - `exit`: exit game;
- `Stage`: formelly game loop where `Player` plays around, provides some sub-states:
  - `pause`: pause the game;
  - `game over`: show game over screen while game still running in background.

`Console` inputs:
- The own keyabord to execute console commands;
- [Enter] to run command.

`Scene` inputs:
- in-game sub-state:
  - [Arrow Up] to accelarate ship;
  - [Arrow Down] to deaccelarate ship;
  - [Arrow Left] to turn ship left;
  - [Arrow Right] to turn ship right;
  - [Escape] toggles pause menu;
- pause or game over sub-state:
  - [Q] return to `Console`;
  - [R] restart `Stage`;

## Missing features

From the tutorial, those features are not implemented for lack of time:
- Player passives to provide in-game features and make the game more enjoyable;
- Skill tree to provide passive structures;
- Playable different ships;
- Shaders and visual effects;
- Achivements; and
- Save states.

## Submodules

Built with [LÖVE2D 11.5](https://love2d.org/) and Lua

- [Sheepolution/classic](https://github.com/Sheepolution/classic) for objects
- [xiejiangzhi/input](https://github.com/xiejiangzhi/input) for input handling
- [vrld/hump](https://github.com/vrld/hump) for timer, vector creation and camera handling
- [Yonaba/Moses](https://github.com/Yonaba/Moses) for table utils
- [Ulydev/push](https://github.com/Ulydev/push) for resolution management
- [idbrii/love-windfield](https://github.com/idbrii/love-windfield) for advanced box2D utils
- [utf8](https://gist.github.com/9d1f7463c207b7b6c7d28aefec7f5c2d) for utf8 string handling in LuaJIT

## Usage

```shell
git clone --recursive https://github.com/jusqua/bytepath
love .
```

## Credits

Thanks to [a327ex](https://github.com/a327ex) for the incredible source of learning.
