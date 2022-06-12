infect_command:
    type: command
    name: infect
    description: Infects someone with a virus.
    usage: /infect player infection_name duration
    aliases:
        - contract
    tab completions:
        1: <server.online_players.parse[name]>
        2: <server.flag[diseases].keys>
        3: 10m|3h|forever
    script:
        - if <context.args.get[1].exists.not>:
            - narrate "<red>You must specify a player to infect!"
            - narrate "<red>Usage: <script[infect_command].data_key[usage]>"
            - stop
        - else if <server.match_offline_player[<context.args.get[1]>].exists.not>:
            - narrate "<red>We couldn't find the player <context.args.get[1]>!"
            - stop
        - define player <server.match_offline_player[<context.args.get[1]>]>
        - if <context.args.get[2].exists.not>:
            - narrate "<red>You must specify a disease to infect the player with!"
            - narrate "<red>Usage: <script[infect_command].data_key[usage]>"
            - stop
        - else if <context.args.get[2]> not in <server.flag[diseases].keys>:
            - narrate "<red>The disease <context.args.get[2]> doesn't exist!"
            - narrate "<red>Usage: <script[infect_command].data_key[usage]>"
            - stop
        - define disease <context.args.get[2]>
        - if <context.args.get[3].exists.not>:
            - define duration <duration[<[disease].proc[get_duration]>]>
        - else if <context.args.get[3]> == forever:
            - define duration <duration[infinite]>
        - else:
            - define duration <duration[<context.args.get[3]>]>
        - narrate "<green>Infected <[player].name> with <[disease]> for <[duration].formatted_words>!"
        - run force_infect_player def:<[player]>|<[disease]>|<[duration]>

cure_commands:
    type: command
    name: cure
    description: Cures someone from a disease.
    usage: /cure player disease
    aliases:
        - disinfect
    tab completions:
        1: <server.online_players.parse[name]>
        2: <server.flag[diseases].keys>
    script:
        - if <context.args.get[1].exists.not>:
            - narrate "<red>You must specify a player to cure!"
            - narrate "<red>Usage: <script[cure_command].data_key[usage]>"
            - stop
        - else if <server.match_offline_player[<context.args.get[1]>].exists.not>:
            - narrate "<red>We couldn't find the player <context.args.get[1]>!"
            - stop
        - define player <server.match_offline_player[<context.args.get[1]>]>
        - if <context.args.get[2].exists.not>:
            - narrate "<red>You must specify a disease to cure the player from!"
            - narrate "<red>Usage: <script[cure_command].data_key[usage]>"
            - stop
        - else if <context.args.get[2]> not in <server.flag[diseases].keys>:
            - narrate "<red>The disease <context.args.get[2]> doesn't exist!"
            - narrate "<red>Usage: <script[cure_command].data_key[usage]>"
            - stop
        - define disease <context.args.get[2]>
        - narrate "<green>Cured <[player].name> from <[disease]>!"
        - run force_cure_player def:<[player]>|<[disease]>
