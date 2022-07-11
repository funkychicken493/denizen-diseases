antibiotics:
    type: item
    material: player_head
    display name: <white>Antibiotics
    lore:
        - <gray>Cures some diseases.
    mechanisms:
        skull_skin: 0fc958a6-7bdb-46b4-8d59-965c2be15597|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMmYwN2EwYzNmOGM5OGViZjMyOTU4ZWU1NTBlNzgzZDBmNmY3YzFhNDYxOTQ0ZmQ1NmZkYmRiNjJiNjAyM2ZmOSJ9fX0=
    flags:
        no_stack: <util.random_uuid>
        uses: 5

antibiotics_use:
    type: world
    debug: true
    events:
        on player right clicks block with:antibiotics:
            - determine passively cancelled
            - narrate "You feel better"
            - take item:antibiotics quantity:1 from:<player.inventory>
            - foreach <player.flag[diseases].if_null[<map[]>].keys> as:disease:
                - run natural_cure_disease def:<player>|<[disease]>|antibiotics
            - inject <script[disease_sounds]> path:swallow

panacea:
    type: item
    material: player_head
    display name: <red>Panacea
    lore:
        - <gray>Can cure everything but the common cold.
    mechanisms:
        skull_skin: de3cb8d9-cfed-49a7-9f47-ba89af3ed797|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvOGI2M2Q0ZjEzNGJkZWYxZTFhNWQxMzA2YTUwZmRjZjkzMjVjYjU5MjhhNTA3ZGMzMDUyNDI3OTI3ZDgzZmNiMiJ9fX0=

panacea_use:
    type: world
    debug: true
    events:
        on player right clicks block with:panacea:
            - determine passively cancelled
            - narrate "You feel much better"
            - take item:panacea quantity:1 from:<player.inventory>
            - foreach <player.flag[diseases].if_null[<map[]>].keys> as:disease:
                - run natural_cure_disease def:<player>|<[disease]>|panacea
            - inject <script[disease_sounds]> path:swallow

hand_sanitizer:
    type: item
    material: player_head
    display name: <green>Hand Sanitizer
    lore:
        - <gray>Stop disease before it starts.
    mechanisms:
        skull_skin: 5ef4aba4-8358-4102-a4fb-3ffa077e5aae|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMjNhMzFlODczMTBlOGNkYmExZmRhMmQ2YjY1MmNmYTdlODZiMjZjN2MzNDUzYmI5MzNhYzAzNjExNDFkNTI4NyJ9fX0=

hand_sanitizer_use:
    type: world
    debug: true
    events:
        on player right clicks block with:hand_sanitizer:
            - determine passively cancelled
            - if <player.has_flag[sanitized_hands]>:
                - narrate "Your hands are already sanitized."
                - inject <script[disease_sounds]> path:error
                - stop
            - narrate "Your hands have been sanitized!"
            - flag <player> sanitized_hands expire:<duration[<util.random.int[12000].to[36000]>t]>
            - inject <script[disease_sounds]> path:sanitization

hand_sanitizer_use_on_player:
    type: world
    debug: true
    events:
        on player damages player with:hand_sanitizer:
            - determine passively cancelled
            - if <context.entity.has_flag[sanitized_hands]>:
                - narrate "Their hands are already sanitized." targets:<context.damager>
                - inject <script[disease_sounds]> path:error
                - stop
            - narrate "Your hands have been sanitized!" targets:<context.entity>
            - narrate "<context.entity.name>'s hands have been sanitized!" targets:<context.damager>
            - flag <context.entity> sanitized_hands expire:<duration[<util.random.int[12000].to[36000]>t]>
            - inject <script[disease_sounds]> path:sanitization

sugar_pills:
    type: item
    material: player_head
    display name: <white>Antibiotics
    lore:
        - <gray>Cures some diseases.
    mechanisms:
        skull_skin: 0fc958a6-7bdb-46b4-8d59-965c2be15597|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMmYwN2EwYzNmOGM5OGViZjMyOTU4ZWU1NTBlNzgzZDBmNmY3YzFhNDYxOTQ0ZmQ1NmZkYmRiNjJiNjAyM2ZmOSJ9fX0=
    flags:
        no_stack: <util.random_uuid>
        uses: 5

sugar_pills_use:
    type: world
    debug: true
    events:
        on player right clicks block with:sugar_pills:
            - determine passively cancelled
            - narrate "You feel better"
            - if <context.item.flag[uses].if_null[0]> == 0:
                - take item:<context.item> quantity:1 from:<player.inventory>
            - else:
                - inventory flag uses:<context.item.flag[uses].sub[1]> d:<player.inventory>
            - foreach <player.flag[diseases].if_null[<map[]>].keys> as:disease:
                - run natural_cure_disease def:<player>|<[disease]>|placebo
            - inject <script[disease_sounds]> path:swallow

mask:
    type: item
    material: player_head
    display name: <white>Mask
    mechanisms:
        skull_skin: 04fae65f-6801-4685-b176-50ea973bc97f|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZWM2ZjcxZDFkNjc3NTgyYjU2Y2YxMjc3YzE0M2Y5ODYzZTgyMjJmMmM5ZTFhYmEyMmFmMGYwZDhjMGQyM2Y2MyJ9fX0=
    flags:
        no_stack: <util.random_uuid>

mask_use:
    type: world
    debug: true
    events:
        on player right clicks block with:mask:
            - determine cancelled
