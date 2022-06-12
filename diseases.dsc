#@ DISEASES
#A file for all those lovely diseases that your players can have.

diseases:
    type: data
    diseases:
        slimelung:
            name: Slimelung
            diagnosis:
                - You have contracted slimelung.
            description:
                - Slimelung is a respiratory disease contracted by being near slime.
            severity: 1
            type:
                - respiratory
                - virus
            time:
                #Minimum length of time that the disease will last using dsc <duration[]> tag.
                min_duration: 10m
                #Maximum length of time that the disease will last using dsc <duration[]> tag.
                max_duration: 3h
                #Will the disease last forever? (overrides min_duration and max_duration)
                chronic: false
                #Will the disease time continue to tick down if the player is offline?
                offline_tick: false
                #Amount the disease time will increase after the host dies using dsc <duration[]> tag.
                death_penalty: 0s
            spread:
                player:
                    enabled: true
                    #Chance per second of slimelung being transmitted to nearby players.
                    transmit_chance: 0.01
                    #Maximum distance to spread slimelung.
                    max_radius: 10
                    #Animation task to play when slimelung is transmitted.
                    effect: sneeze
                    #Chance of a player being infected when slimelung is transmitted.
                    contraction_chance: 0.1
                    #Chance for transmission to be cancelled on masked players.
                    mask_effectiveness: 0.5
                    #Can the infection go through solid objects?
                    solid_objects: false
                    #Chance for the infection to be transmitted when a player dies.
                    death_transmission_chance: 1.0
                    #Contraction chance for the infection when a nearby player dies.
                    death_contraction_chance: 0.9
                entity_proximity:
                    #Chance per second of slimelung being contracted by being near entities.
                    entities:
                        slime: 0.05
                entity_death:
                    #Chance per second of slimelung being contracted by being near entities as they die.
                    entities:
                        slime: 0.1
                entity_attack:
                    #Chance per second of slimelung being contracted by being hit by an entity.
                    entities:
                        slime: 0.1
                block:
                    #Chance per second of slimelung being contracted by being near certain blocks.
                    blocks:
                        slime_block: 0.0001
                        sticky_piston: 0.0001
                item:
                    #Chance per second of slimelung being contracted by holding/being near certain items.
                    items:
                        slime_ball: 0.0001
                        slime_block: 0.001
                        sticky_piston: 0.0001
            #Will the infection care about washed hands?
            washed_hands: true
            #Will the infection care about sanitized hands?
            sanitized_hands: true
            #Chance that newly washed hands will prevent slimelung from infecting a player.
            #For example: 0.3 means that 30% of the time slimelung will not infect a player with washed hands.
            wash_effectiveness: 0.3
            #Hand sanitizer effectiveness (same as wash_effectiveness, but for hand sanitizer).
            #For example: 0.5 means that 50% of the time slimelung will not infect a player with their hands sanitized.
            hand_sanitizer_effectiveness: 0.7
            cure:
                #Chance for the infection to be cured by antibiotics.
                #This chance is multiplied by the antibiotics effectiveness.
                antibiotics: 0.1
                #Chance for the infection to be cured by placebo sugar pills, which are a lot more specialized than antibiotics.
                placebo: 0.0
                #Chance for the infection to be cured by direct fire damage.
                fire: 0.0
                #Chance per second for the infection to be cured by being submerged in water.
                water: 0.0
                #Chances for this infection to cure other infections from contraction.
                cure_other_infections:
                    null: 0.0
                #Will the disease be cured on player death?
                death: false
                #Will the disease be cured on player disconnect?
                disconnect: false
            #Uses effects from https://hub.spigotmc.org/javadocs/spigot/org/bukkit/potion/PotionEffectType.html
            #Formatting: <effect>: <duration> <amplifier> <chance>
            #Example: slow: 1:1:0.5
            effects:
                #Effects that will be applied to the player when the disease is contracted.
                contraction_effects:
                    poison: 0 0 0.0
                #Effects that will be removed the player when the disease is cured.
                #Formatting: - effect
                cure_effects:
                    - null
                #Effects that have a chance to be applied each second.
                #Use the same format as contraction_effects.
                random_effects:
                    poison: 10 1 0.5
                #Effects that will be applied to the player whenever they transmit the disease.
                #Use the same format as contraction_effects.
                transmit_effects:
                    slow: 0:0:0.0
                #Effects that cannot be gained by the player while infected.
                #Uses the same format as cure_effects.
                prevent_effects:
                    - null
                #Effects that will be applied to the player whenever they are hit.
                #Use the same format as contraction_effects.
                hit_effects:
                    slow: 0:0:0.0



