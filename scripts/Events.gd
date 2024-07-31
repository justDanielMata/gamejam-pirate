extends Node

#card events
signal card_aim_started(card_ui: CardUI)
signal card_aim_ended(card_ui: CardUI)
signal card_dragging_started(card_ui: CardUI)
signal card_dragging_ended(card_ui: CardUI)
signal card_played(card: Card)
signal card_canceled(card: Card)
signal reparent_requested(which_card_ui: CardUI, new_parent: String)
signal add_fused_card_to_hand(card: Card)

#player evetns
signal player_hand_drawn
signal next_card_changed(card: Card)
signal player_turn_ended
signal player_died
signal player_moved

#enemy events
signal enemy_moved(enemy: Enemy)
signal enemy_action_completed(enemy: Enemy)
signal enemy_turn_ended
signal enemy_died
