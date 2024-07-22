extends Node

#card events
signal card_aim_started(card_ui: CardUI)
signal card_aim_ended(card_ui: CardUI)
signal card_dragging_started(card_ui: CardUI)
signal card_dragging_ended(card_ui: CardUI)
signal card_played(card: Card)

#player evetns
signal player_hand_drawn
signal player_turn_ended
