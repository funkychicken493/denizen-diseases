disease_sounds:
    type: data
    swallow:
        - playsound <player.location> sound:entity_painting_place pitch:0.5 volume:2.0 sound_category:master
        - playsound <player.location> sound:entity_item_frame_add_item pitch:0.5 volume:2.0 sound_category:master
    sanitization:
        - playsound <player.location> sound:block_honey_block_place pitch:0.5 volume:2.0 sound_category:master
    error:
        - playsound <player.location> sound:entity_villager_no pitch:1.2 volume:2.0 sound_category:master

get_duration:
    type: procedure
    definitions: disease
    debug: false
    script:
        - define disease_map <server.flag[diseases].get[<[disease]>]>
        - if <[disease_map].deep_get[time.chronic].if_null[false]>:
            - determine forever
        - determine <duration[<util.random.int[<duration[<server.flag[diseases].deep_get[<[disease]>.time.min_duration]>].in_ticks>].to[<duration[<server.flag[diseases].deep_get[<[disease]>.time.max_duration]>].in_ticks>]>t]>

factor_natural_infect_chance:
    type: procedure
    definitions: disease|player|source|source_data
    debug: false
    script:
        #If source isn't specified, set it as special source "null"
        - define source null if:<[source].exists.not>
        #If source data isn't specified, set it as special source data "null"
        - define source_data null if:<[source_data].exists.not>
        #Grab the disease information from server flags
        - define disease_map <server.flag[diseases].get[<[disease]>]>
        #Check if the player has washed their hands
        - define washed_hands <[player].has_flag[washed_hands]>
        #Check if the player has sanitized their hands
        - define sanitized_hands <[player].has_flag[sanitized_hands]>
        #If the player has washed their hands, factor in the washed-hands-chance
        - if <[washed_hands]>:
            - define washed_chance <[disease_map].get[wash_effectiveness]>
        - else:
            - define washed_chance 1.0
        #If the player has sanitized their hands, factor in the sanitized-hands-chance
        - if <[sanitized_hands]>:
            - define sanitized_chance <[disease_map].get[hand_sanitizer_effectiveness]>
        - else:
            - define sanitized_chance 1.0
        #Grab the transmission contraction chance from the disease map
        - define player_contraction_chance <[disease_map].deep_get[spread.player.contraction_chance].if_null[1.0]>
        #If the source is null, set the source_contraction_chance to the player_contraction_chance divided by 2
        - if <[source]> == null:
            #This a completely arbitrary number, but it is only for weird cases where the source is null
            - define source_contraction_chance <[player_contraction_chance].div[2]>
        #If the source is a player, simply set the source_contraction_chance to the player_contraction_chance
        - else if <[source]> == player:
            - define source_contraction_chance <[player_contraction_chance]>
        #Items are really the same as blocks or entities, but require different tags
        - else if <[source]> == item:
            - define source_contraction_chance <[disease_map].deep_get[spread.item.<[source_data].material.name>].if_null[1.0]>
        #If the source is a block or entity, grab their chances from the disease map
        - else:
            - define source_contraction_chance <[disease_map].deep_get[spread.<[source]>.<[source_data].name>].if_null[1.0]>
        #Multiply all the chances by 100 to reflect the arguments of util.random_chance
        - define washed_chance <[washed_chance].mul[100]>
        - define sanitized_chance <[sanitized_chance].mul[100]>
        - define source_contraction_chance <[source_contraction_chance].mul[100]>
        #If the disease ignores wash effectiveness, set the washed_chance to 100
        - if !<[disease_map].get[washed_hands]>:
            - define washed_chance 100
        #Same with sanitization, if the disease ignores sanitization, set the sanitized_chance to 100
        - if !<[disease_map].get[sanitized_hands]>:
            - define sanitized_chance 100
        #Roll all three chances and if they all pass, return true
        - if <util.random_chance[<[washed_chance]>]> and <util.random_chance[<[sanitized_chance]>]> and <util.random_chance[<[source_contraction_chance]>]>:
            - determine true
        - else:
            - determine false
