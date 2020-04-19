# NS2 Balance Beta
**SteamWorks Mod ID**: *77FAFE74*

This mod contains various balance changes based on various ideas of the NS2 balance team.

Join the official ns2 discord server (discord.gg/ns2) to leave feedback!

## Recent
- 19/4/2020
    - Fixed structures being detected but not visible if scanned
- 17/4/2020
    - Fixed Gorge webs only cloaking from one endpoint. Will now use the shortest distance of both endpoints and midpoint.
    - Mines now only are revealed on the map for aliens when they are parasited or in combat.
- 14/4/2020
    - Gorge webs now properly have multiple "charges", so that marines can be webbed from them multiple times. When 0 charges are reached the web dies.
    - Changed gorge web full visibility distance to 5 meters.
    - Changed gorge web base hp to 10.
    - Changed gorge web charge hp to 10. (Max 30 hp)
    - Made gorge web invisibility client-side. Friends of the web will have the "cloaked" shader applied when not in range.
    - Made gorge web distortion less visible the further away the player is.
- 12/04/2020
    - Reverted Blight and Aura changes.
- 11/04/2020
    - Reverted Skulk bite cone changes for now (A/B test)
- 10/04/2020
    - Decreased Gorge web full visibility distance to 6.5 meters.
- 04/04/2020
    - Fixed commanders forced to repress the grid key for dual action items.
        - A commander can now keep the medpack key pressed, and drop one medpack for each subsequent mouse click.
    - Fixed scan not having a visual range displayed
- 03/04/2020
    - Added 3 new colors to be used with Blight.
    - New Colors used are based on player or structure health, respectively.
        - For players, Blue >= 4 bites, Yellow = 3 bites, Red < 2 Bites
        - For Structures, Blue >= 66% eHP, Yellow >= 33% eHP, Red < 33% eHP
- 02/04/2020
    - Gorge webs now have a "hardening" mechanic.
        - 10 seconds per charge.
        - 3 charges max.
        - 13 hp per charge, in addition to the base health.
    - Gorge webs now only placeable on the ground from one endpoint. (fix "duct tape" webs)
    - Gorge Webs now fade into view at 10 meters (up from 5)
    - Gorge web ghost model stalk now stays visible even when placement is invalid. (Will turn red instead)
    - Gorge web snare duration is now 5 seconds (from 2.5)
    - Added a Player Status icon for blight.
    - Decreased mine damage to 130 (from 150)
- 18/03/2020
    - Lerk Spike now penetrates soft targets (MACs)
    - Fixed dead players displaying nameplate
    - Fixed various script errors
    
## Full Changelog:

- Added a "changelog" console command to show this webpage.
- (Experimental) The health and armor status (hp bar) is now hidden for enemy players for all field players. We recommend to enable damage numbers
- Decreased re-drop block times for cysts and resource towers to 1 second (from 5-7 seconds)
- Fixed commanders forced to repress the grid key for dual action items
- Fixed scan not having a visual range displayed
- Fixed structures being detected but not visible if scanned

- Marine
    - Shotgun
        - Reverted to build 326-behavior.
            - 17 pellets, each deal 10 damage.
            - Divided into 4 rings of 4 pellets each, +1 pellet in the middle.
            - Pellet sizes are all 16mm.
            - No Damage Falloff.
    - HMG
        - Reload time is now 3.5 seconds (down from 5 seconds)
        - Decreased clip size to 100 (from 125)
    - Flamethrower
        - Removed energy damage (1 energy per hit)
    - Mines
        - Decreased damage to 130 (from 150)
        - Mines can now be properly killed during their arming period when first deployed. In this case, they do not explode or deal damage.
        - Marines now keep unused mines when they die and receive them back when they respawn (like hand grenades).
        - Change hit points to 30 health and 9 armor (from 40 health and 5 armor). Tip: With crush it takes only 4 parasites (instead of 5) to destroy a mine.
        - Lerk spikes deal 2x damage to mines (Damage: 5 -> 10).
        - Mines now award 5 score points when killed by an alien.
        - Display Mines at the minimap for Marines.
        - Decrease weight to 0 (from 0.1). So that mines don't slow down Marines.
        - Now only appear on map for aliens when parasited or in combat.
    - Hand Grenades
        - Removed lengthy deploy animation so grenades are now thrown much faster. (quickthrow and regular throw)
        - Pulse grenade
            - "Electrified" effect now also nullifies and prevents targets from benefiting from drifter Enzyme and Mucous abilities
        - Decreased weight to 0 (from 0.1) so hand grenades do not affect the marine's speed.
    - Exosuit
        - Reduced opacity of "scanlines" UI texture to be less obstructive (25% of original value).
        - Exos are now free to fire their weapons while thrusters are being used.
        - Thrusters can now be toggled on and off freely without waiting for maximum charge between use.
            - Thruster fuel now has a 0.75 second cooldown before recharging after last use.
        - Exosuits now "self-repair" when out of combat at a rate of 8 armor/second.
        - Alien Vampirism no longer has any effect when used against exos.
        - Railgun
            - Both railguns can now fire simultaneously.
            - Full-charge duration is now 1 second
            - Cooldown between shots is now 0.3 seconds.
            - Anything short of a full-charge shot no longer penetrates targets.
            - Shots with 75% power and above now convert to "heavy" damage type (double damage to armor), 74% power and below charge shots are regular damage.
            - Distortion tracer effect and steam effects no longer play if the shot didn't deal heavy damage (75% charge).
            - Damage ramps up from 25 to 50 as you charge.
            - Decreased projectile size of uncharged (below 75 % charge) shots to 0.075 (from 0.3)
            - Decreased projectile size of charged (above 75% charge) shots to 0.15 (from 0.3)
        - Minigun
            - Damage type is now "heavy" (double damage to armor).
            - Damage: 10 -> 6
            - Overheat animation sped up such that the time out of combat now matches up exactly with the heat meter for that weapon (before, the overheat animation would finish well-after the heat meter was empty).
    - Powernodes
        - All Powernodes now start socketed but unbuilt. The
            Powernodes in the Marine Base start built and Alien Hive
            start destroyed upon round start.
        - Powernodes that have no health are not highlighted for either team and
            can't be damaged.
        - Powernodes that haven't been build yet don't
            affect the location's light state.
        - The construction progress of a Powernode is synchronized with their
            hit points. This means when an enemy damages an unbuild Powernode by 1%
            hp it also looses 1% construction progress.
        - Marines receive no automated order to construct a Powernode unless
            there is a structure or blueprint inside the given location that requires power.
    - Misc
        - Marine dropped weapon decay timer is now 16 seconds (down from 25)
        - Nanoshield duration is now 3 seconds when used on players (down from 5) 
        - Nanoshield used on structures remains unchanged at 5 seconds
        - Fixed cluster grenade burn damage numbers being displayed to the target
- Alien
        
    - Fixed Healing Soft clamp
        - If an Alien structure or player is healed by more than 14%/sec of their total effective hit points any additional healing is reduced by 66% .
    - Upgrades
        - Vampirism
            - Now each hit with your primary attack charges hp shield
            - The shields will last for a maximum time of 5 seconds after your last hit. However it will start decaying after 0.5 seconds
            - The maximum shield amount is 1.5 times the value of the charge of a single hit with 3 shells.
            - The shield does stack with mucous and babblers
            - Skulks only charge 14% health per bite (decreased from 20%)
            - Vampirism no longer has any effect when used against Exosuits
    - Skulk
        - Model size decreased by 10% (90% original size).
        - Skulk sneak speed reduced to 4.0 (down from 4.785)
        - Skulks now only receive a speed boost from a consecutive jump.
    - Gorge
        - Heal spray
            - Now also adds maturity to alien structures and speeds up player evolutions while they are embryos.
        - Web
            - Web GhostModel stalk will now stay visible even if the placement is invalid. (Will be colored red)
            - Webs are now only placeable on the ground from one endpoint. (to fix "duct tape" webs)
            - Gorges can finish placing webs from much further away.  Starting placement range is unchanged.
            - Snare now reduces movement speed by 66% and tapers off gradually over 5 seconds (up from 2.5 seconds)
            - Webs now turn invisible, only fading into view at 5 meters or closer, with a distortion effect at longer range. (Client-side)
            - No longer parasite marines.
            - No longer appears in the kill-feed.
            - Now have a "hardening" mechanic, where a gorge web will have "charges", which will allow them to web enemies multiple times. 
                - When charges run out, the web will die.
                - Each charge gives the web 10 hp.
                - Webs start with 10 hp.
                - Max 30 hp.
        - Babbler
            - Do not gain hp with each biomass anymore (they received 1.5 hp for each biomass)
    - Lerk
        - Spike
            - Projectile size is now 60mm (up from 45mm)
            - Now penetrates soft targets (MACs)
    - Fade
        - Stab
            - Decrease base damage to 120 (from 160)
            - Stab now deals 2x damage to structures (equivalent to skulk structure DPS).
            - Fades can now blink, jump and move freely while performing stab.
        - Fades now only receive speed bonuses from consecutive blinks when using celerity.
        - Advanced Metabolize now heals according to effective HP. (Heals 15 eHP, so when armor is healed you should get 7.5 armor)
        
    - Drifter abilities
        - All abilities have now a cool down of 12 seconds (instead of only 1 second for mucous and hallucinations)
        
    - Ink Cloud
        - Decreased cooldown to 15 seconds (from 16).
        
    - Misc
        - Maturity information is now visible in the nameplate for alien structures.
        - Crag, Shade, and Shift supply cost: 25 -> 20.
        - Added score points for destroying a dropped HMG with Bile Bomb.
        - Onos taunt now uses the charge sound (instead of the stomp sound)
