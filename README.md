# NS2 Balance Beta
**SteamWorks Mod ID**: *77FAFE74*

This mod contains various balance changes based on various ideas of the NS2 balance team.

Join the official ns2 discord server (discord.gg/ns2) to leave feedback!

## Recent Changes
- 08/03/2020
    - Reverted innate regen limitation.
    - Reverted Carapace changes.
    - Reverted Hydra changes for now. There will be another iteration of hydra changes.
    - Fixed that heal spray increase maturity for unbuilt structures
    - Decreased heal spray gestate boost by 50%. Each heal spray now decreases gestate time by 0.5 second (instead of 1 second).
    - Decreased HMG clip size to 100 (from 125)
    - Decreased Exosuit self repair rate to 8 armor/second (from 10)
    - Decreased Ink Cloud cooldown to 15 seconds (from 16).
    - Decreased weight of Mines and Hand Grenades to 0 (from 0.1). So they no longer affect marine's speed.
    - Increased Skulk bite cone to to 0.8x1.2  (from 0.8x1.0).
    
## Full Changelog:

- Added a "changelog" console command to show this webpage.
- (Experimental) The health and armor status (hp bar) is now hidden for enemy players for all field players. We recommend to enable damage numbers

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
        - Mines can now be properly killed during their arming period when first deployed. In this case, they do not explode or deal               damage.
        - Marines now keep unused mines when they die and receive them back when they respawn (like hand grenades).
        - Change hit points to 30 health and 9 armor (from 40 health and 5 armor). Tip: With crush it takes only 4 parasites (instead of 5) to destroy a mine.
        - Lerk spikes deal 2x damage to mines (Damage: 5 -> 10).
        - Mines now award 5 score points when killed by an alien.
        - Display Mines at the minimap for Marines.
        - Decrease weight to 0 (from 0.1). So that mines don't slow down Marines.
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
        - Aura
            - No longer displays any health information (marker will always be yellow)
        - Focus
            - Replaced with new upgrade: Blight (experimental):
                - With Blight each primary attack parasites the target
                - The timeout for that parasite is 5/10/15 seconds on players and 15/30/45 seconds on structures for 1/2/3 Veils
        
    - Skulk
        - Reduced bite cone to 0.8 x 1.2 (down from 1.2 x 1.2)
        - Model size decreased by 10% (90% original size).
        - Skulk sneak speed reduced to 4.0 (down from 4.785)
        - Skulks now only receive a speed boost from a consecutive jump.
        
    - Gorge
        - Heal spray
            - Now also adds maturity to alien structures and speeds up player evolutions while they are embryos.
        - Web
            - Gorges can finish placing webs from much further away.  Starting placement range is unchanged.
            - Now break on contact.
            - Snare now reduces movement speed by 66% and tapers off gradually over 2.5 seconds (up from 1.5 seconds)
            - Webs now turn invisible, only fading into view at 5 meters or closer.
            - No longer parasite marines.
            - No longer appears in the kill-feed.
        - Babbler
            - Do not gain hp with each biomass anymore (they received 1.5 hp for each biomass)
    - Lerk
        - Spike
            - Projectile size is now 60mm (up from 45mm)
    - Fade
        - Stab
            - Decrease base damage to 120 (from 160)
            - Stab now deals 2x damage to structures (equivalent to skulk structure DPS).
            - Fades can now blink, jump and move freely while performing stab.
        - Fades now only receive speed bonuses from consecutive blinks when using celerity.
        
    - Drifter abilities
        - All abilities have now a cool down of 12 seconds (instead of only 1 second for mucous and hallucinations)
        
    - Ink Cloud
        - Decreased cooldown to 15 seconds (from 16).
        
    - Misc
        - Maturity information is now visible in the nameplate for alien structures.
        - Crag, Shade, and Shift supply cost: 25 -> 20.
        - Added score points for destroying a dropped HMG with Bile Bomb.
        - Onos taunt now uses the charge sound (instead of the stomp sound)
