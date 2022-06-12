diseases_core:
    type: world
    debug: false
    events:
        after script reload:
            - flag server diseases:<map[<script[diseases].data_key[diseases]>]>
            - announce to_console "Diseases successfully loaded."
        after server start:
            - flag server diseases:<map[<script[diseases].data_key[diseases]>]>
            - announce to_console "Diseases successfully loaded."
        after delta time secondly:
            - foreach <server.online_players> as:p:
                - if <[p].flag[diseases].if_null[<map[]>].is_empty>:
                    - foreach next
                - foreach <[p].flag[diseases].keys> as:disease:
                    - define disease_map <script[diseases].data_key[diseases].get[<[disease]>]>
                    - if <util.time_now.is_after[<[p].flag[diseases.<[disease]>]>].if_null[false]>:
                        - flag <[p]> diseases.<[disease]>:!
                        - foreach next
                    - define random_effects <[disease_map].deep_get[effects.random_effects]>
                    - foreach <[random_effects].keys> as:effect:
                        - define split_effect <[random_effects].get[<[effect]>].split>
                        - define duration <duration[<[split_effect].get[1]>s]>
                        - define amplifier <[split_effect].get[2].sub[1]>
                        - define chance <[split_effect].get[3].mul[100]>
                        - if <util.random_chance[<[chance]>]>:
                            - cast <[effect]> <[p]> amplifier:<[amplifier]> duration:<[duration]> hide_particles no_ambient


disease_cure_methods:
    type: world
    debug: false
    events:
        after player damaged:
            - foreach <player.flag[disease].if_null[<map[]>]> as:disease:
                - if <context.cause> in fire|fire_tick and <util.random_chance[<server.flag[diseases].deep_get[<[disease]>.cure.fire].if_null[0].mul[100]>]>:
                    - run force_cure_disease def:<player>|<[disease]>

force_infect_player:
    type: task
    debug: false
    definitions: player|disease|duration
    script:
        - flag <[player]> diseases <map[]> if:<player.flag[diseases].object_type.equals[Map].not>
        - if <[duration].in_ticks> == 0:
            - flag <[player]> diseases.<[disease]>:forever
        - else:
            - flag <[player]> diseases.<[disease]>:<util.time_now.add[<[duration]>]>
        - narrate "Infected with <[disease]> for <[duration].formatted_words>" targets:<[player]>

natural_infect_player:
    type: task
    debug: false
    definitions: player|disease
    script:
        - define duration <[disease].proc[get_duration]>
        - define disease_map <server.flag[diseases].get[<[disease]>]>
        - flag <[player]> diseases <map[]> if:<player.flag[diseases].object_type.equals[Map].not>
        - flag <[player]> diseases.<[player].flag[diseases]>.<[disease]>:<util.time_now.add[<[duration]>]>
        - narrate "Infected with <[disease]> for <[duration].formatted_words>" targets:<[player]>

force_cure_disease:
    type: task
    debug: true
    definitions: player|disease
    script:
        - if <[player].has_flag[diseases].not>:
            - stop
        - if <[player].flag[diseases.<[disease]>].exists>:
            - flag <[player]> diseases.<[disease]>:!
            - narrate "Cured of <[disease]>" targets:<[player]>

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
            - flag <[player]> diseases.<[disease]>:!
            - narrate "Cured of <[disease]>" targets:<[player]>

