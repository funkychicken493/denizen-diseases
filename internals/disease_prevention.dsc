wash_basin:
    type: world
    debug: false
    events:
        on player right clicks water_cauldron with:air:
            - if <context.location.material.level> > 0:
                - if <context.location.material.level> == 1:
                    - modifyblock <context.location> cauldron
                - else:
                    - modifyblock <context.location> <context.location.material.with[level=<context.location.material.level.sub[1]>]>
                - playsound <context.location> sound:item_bucket_fill sound_category:master volume:2.0
                - playeffect at:<context.location.center.above[0.5]> effect:block_dust special_data:water quantity:50 offset:0.2,0,0.2
                - define already_washed <player.has_flag[washed_hands]>
                - flag <player> washed_hands:!
                - flag <player> washed_hands expire:<duration[<util.random.int[12000].to[36000]>t]>
                - if <[already_washed]>:
                    - narrate "You washed your hands again!"
                - else:
                    - narrate "You washed your hands!"
                - if !<[already_washed]>:
                    - while <player.has_flag[washed_hands]>:
                        - wait 60t
                        - if <player.exists> and <player.location.exists> and <player.has_flag[washed_hands]>:
                            - playeffect at:<player.location.above[0.7]> effect:block_crack special_data:water quantity:7 offset:0.1,0,0.1
        after player damaged chance:50:
            - if <context.cause> in fire|fire_tick|hot_floor and <context.entity.has_flag[washed_hands]>:
                - flag <context.entity> washed_hands:!
                - playsound <context.entity.location> sound:block_fire_extinguish sound_category:master volume:2.0
                - playeffect at:<context.entity.location.above[0.7]> effect:smoke_normal quantity:50 offset:0.1,0.1,0.1
