diseases_core:
    type: world
    debug: false
    events:
        after script reload:
            - wait 20t
            - flag server diseases:<map[<script[diseases].data_key[diseases]>]>
            - announce to_console "Diseases successfully loaded."
        after server start:
            - wait 20t
            - flag server diseases:<map[<script[diseases].data_key[diseases]>]>
            - announce to_console "Diseases successfully loaded."
        after delta time secondly:
            - foreach <server.offline_players> as:p:
                - if <[p].has_flag[diseases].not>:
                    - foreach next
                - foreach <[p].flag[diseases].keys> as:disease:
                    - define disease_map <script[diseases].data_key[diseases].get[<[disease]>]>
                    - if <[p].is_online> || <[disease_map].deep_get[time.offline_tick].if_null[false]>:
                        - if <[p].flag[diseases].get[<[disease]>]> < 1:
                            - run force_cure_disease def:<[p]>|<[disease]>
                            - stop
                        - else:
                            - flag <[p]> diseases.<[disease]>:<[p].flag[diseases].get[<[disease]>].sub[1]>
                    - if <[p].is_online.not>:
                        - foreach next
                    - define random_effects <[disease_map].deep_get[effects.random_effects]>
                    - foreach <[random_effects].keys> as:effect:
                        - define split_effect <[random_effects].get[<[effect]>].split>
                        - define duration <duration[<[split_effect].get[1]>s]>
                        - define amplifier <[split_effect].get[2].sub[1]>
                        - define chance <[split_effect].get[3].mul[100]>
                        - if <util.random_chance[<[chance]>]>:
                            - cast <[effect]> <[p]> amplifier:<[amplifier]> duration:<[duration]> hide_particles no_ambient
        on player potion effects modified:
            - foreach <player.flag[diseases]> as:disease:
                - define disease_map <server.flag[diseases].get[<[disease]>]>
                - foreach <[disease_map].deep_get[effects.prevent_effects]> as:effect:
                    - if <context.effect_type> == <[effect]> and <context.action> == added:
                        - determine cancelled
        after player dies:
            - foreach <player.flag[diseases]> as:disease:
                - define disease_map <server.flag[diseases].get[<[disease]>]>
                - if <player.flag[diseases].get[<[disease]>].in_ticks> == 0 or <[disease_map].deep_get[time.death_penalty]> == 0:
                    - foreach next
                - flag <player> diseases.<[disease]>:<player.flag[diseases].get[<[disease]>].add[<[disease_map].deep_get[time.death_penalty]>]>

disease_cure_methods:
    type: world
    debug: false
    events:
        after player damaged:
            - foreach <player.flag[disease].if_null[<map[]>]> as:disease:
                - if <context.cause> in fire|fire_tick and <util.random_chance[<server.flag[diseases].deep_get[<[disease]>.cure.fire].if_null[0].mul[100]>]>:
                    - run force_cure_disease def:<player>|<[disease]>
        after player damaged by entity:
            - foreach <context.entity.flag[disease].if_null[<map[]>]> as:disease:
                - define disease_map <server.flag[diseases].get[<[disease]>]>
                - define hit_effects <[disease_map].deep_get[effects.hit_effects]>
                - foreach <[hit_effects].keys> as:effect:
                    - define split_effect <[hit_effects].get[<[effect]>].split>
                    - define duration <duration[<[split_effect].get[1]>s]>
                    - define amplifier <[split_effect].get[2].sub[1]>
                    - define chance <[split_effect].get[3].mul[100]>
                    - if <util.random_chance[<[chance]>]>:
                        - cast <[effect]> <context.entity> amplifier:<[amplifier]> duration:<[duration]> hide_particles no_ambient
        after player dies:
            - foreach <player.flag[disease].if_null[<map[]>]> as:disease:
                - if <server.flag[diseases].deep_get[<[disease]>.cure.death].if_null[false]>:
                    - run force_cure_disease def:<player>|<[disease]>
        after player quits:
            - foreach <player.flag[disease].if_null[<map[]>]> as:disease:
                - if <server.flag[diseases].deep_get[<[disease]>.cure.disconnect].if_null[false]>:
                    - run force_cure_disease def:<player>|<[disease]>

apply_infection:
    type: task
    debug: false
    definitions: player|disease|duration
    script:
        - flag <[player]> diseases <map[]> if:<[player].has_flag[diseases].not.or[<[player].flag[disease].object_type.equals[Map].not>]>
        - if <[duration].in_ticks.if_null[1]> == 0 || <[duration]> == forever:
            - flag <[player]> diseases.<[disease]>:forever
        - else:
            - flag <[player]> diseases.<[disease]>:<[duration].in_seconds>
        - define disease_map <script[diseases].data_key[diseases].get[<[disease]>]>
        - define contraction_effects <[disease_map].deep_get[effects.contraction_effects]>
        - foreach <[contraction_effects].keys> as:effect:
            - define split_effect <[contraction_effects].get[<[effect]>].split>
            - define duration <duration[<[split_effect].get[1]>s]>
            - define amplifier <[split_effect].get[2].sub[1]>
            - define chance <[split_effect].get[3].mul[100]>
            - if <util.random_chance[<[chance]>]>:
                    - cast <[effect]> <[player]> amplifier:<[amplifier]> duration:<[duration]> hide_particles no_ambient
        - define cure_other_diseases <[disease_map].deep_get[cure.cure_other_infections]>
        - foreach <[cure_other_diseases].exclude[null]> as:other_disease:
            - run force_cure_disease def:<player>|<[other_disease]>

force_infect_player:
    type: task
    debug: false
    definitions: player|disease|duration
    script:
        - run apply_infection def:<player>|<[disease]>|<[duration]>

natural_infect_player:
    type: task
    debug: false
    definitions: player|disease
    script:
        - define duration <[disease].proc[get_duration]>
        - run apply_infection def:<player>|<[disease]>|<[duration]>

force_cure_disease:
    type: task
    debug: true
    definitions: player|disease
    script:
        - if <[player].has_flag[diseases].not>:
            - stop
        - if <[player].flag[diseases.<[disease]>].exists>:
            - flag <[player]> diseases.<[disease]>:!
            - define disease_map <script[diseases].data_key[diseases].get[<[disease]>]>
            - define cure_effects <[disease_map].deep_get[effects.cure_effects]>
            - foreach <[cure_effects]> as:effect:
                - cast <[effect]> <[player]> remove

natural_cure_disease:
    type: task
    debug: false
    definitions: player|disease|source
    script:
        - define disease_map <server.flag[diseases].get[<[disease]>]>
        - if <[source].exists.not>:
            - define source null
        - if <[player].has_flag[diseases].not> || <[player].flag[diseases].get[<[disease]>].exists.not>:
            - stop
        - if <[source]> in antibiotic|null:
            - define source antibiotics
        - define source_chance <[disease_map].deep_get[cure.<[source]>]>
        - if <util.random_chance[<[source_chance].mul[100]>]>:
            - run force_cure_disease def:<player>|<[disease]>
