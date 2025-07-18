class_name CardGameState extends Node

# Keeps track of the state of a single card game. Contains decks, hands, played cards, life totals, etc
# Turn flow: 
#   0. determine play order, deal initial cards
#   1. handle mulligans
#   2. current player resolves all "before-turn" effects left-to-right
#   3. current player is dealt cards
#   4. current player can select cards to pay mana costs + cast cards
#   5. casted card resolves (if its a spell, its effect happens. if its a creature, its placed on the right side of the board)
#   6. current player's board resolves left-to-right (creatures attack, permanents do their thing)
#   7. current player discards down to max hand size, then resolves all "at-end-of-turn" effects left-to-right
#   8. advance to next players turn at step 2
#   note: there is an implicit "check if any player won/lost" after each step

enum GAME_STEP {SETUP, MULLIGAN, BEFORE_TURN, UPKEEP, MAIN_PHASE, PLAYED_CARD, BOARD_PHASE, END_OF_TURN}

signal dealt_damage(player_index: int, damage: int)
signal drew_card(player_index: int, card: CardData)

@export var player_list: Array[CardPlayer]
var initial_cards_dealt: int = 7
var max_hand_size: int = 7
var max_mulligans: int = 1

var current_player: CardPlayer = null
var current_player_index: int = 0 #index corresponding to the current active player in the player_list
var tapped_cards: Array[int] = [] #array of indeces corresponding to cards in the players hand they've selected to pay with / discard
var played_card_index: int = -1 #card index in the players hand selected for casting
var current_game_step: GAME_STEP = GAME_STEP.SETUP

var turn_count: int = 1
var number_of_losers: int = 0
var number_of_mulligans: int = 0

@export var debug: bool = true
var debug_state_format_1: String = "TURN %d CURRENT_PLAYER %d GAME_STEP %s"
var debug_state_format_2: String = "PLAYER1 CARD_COUNT %d HP %d PLAYER2 CARD_COUNT %d HP %d"

#func _ready() -> void:
	#drew_card.connect(%UICardGameRenderer._on_drew_card)
	#current_player = player_list.get(0)
	#init_game()

# deal 7 cards to each player
func init_game() -> void:
	print_debug_state()
	for player_index in range(player_list.size()):
		draw_cards(player_index, initial_cards_dealt)
		#player.hand.cards.append_array(player.deck.deal_cards(initial_cards_dealt))
	if number_of_mulligans < max_mulligans:
		current_game_step = GAME_STEP.MULLIGAN
	else:
		current_game_step = GAME_STEP.BEFORE_TURN
	execute_game_step_func()

func mulligan():
	print_debug_state()
	#await await_mulligan_input()
	var did_player_mull: bool = true # await_mulligan_input()
	if did_player_mull:
		number_of_mulligans += 1
		reshuffle_everything()
		current_game_step = GAME_STEP.SETUP
		execute_game_step_func()
	else:
		advance_game_step()

func before_turn():
	#handle all before-turn effects left-to-right on playzone, hand, whatever
	print_debug_state()
	advance_game_step()

func upkeep():
	print_debug_state()
	#var drawn_cards: Array[CardData] = current_player.deck.deal_cards(current_player.draw_per_turn)
	#current_player.change_health(drawn_cards.size() - current_player.draw_per_turn)
	# handle card-drawn effects?
	advance_game_step()

func main_phase():
	print_debug_state()
	# await await_main_phase_input()
	advance_game_step()

func played_card():
	#resolve whatever effect the played card has
	print_debug_state()
	advance_game_step()

func board_phase():
	#resolve board left-to-right for current player
	print_debug_state()
	#for card in current_player.play_zone.cards:
		#execute card's effect
	#	continue
	advance_game_step()

func end_of_turn():
	print_debug_state()
	#if current_player.hand.cards.size() > max_hand_size:
	#	await_discard_input()
	#resolve all cards with end-of-turn effects left-to-right
	advance_game_step()

# sets current_game_step to next step in the turn (or the next player if the turn is over),
# checks if any player lost (has zero health), sets their "is_loser" flag to true if so
func advance_game_step():
	#for player in player_list:
	#	if player.life_total <= 0:
	#		player.is_loser = true
	#		number_of_losers += 1
			
	
	if number_of_losers >= 2:
		declare_draw()
		pass
	if number_of_losers == 1:
		declare_winner()
		pass
	else:
		set_next_game_step()

func set_next_game_step():
	if current_game_step == GAME_STEP.END_OF_TURN:
		set_next_player()
		turn_count += 1
		current_game_step = GAME_STEP.BEFORE_TURN
	else:
		current_game_step += 1
	execute_game_step_func()

func set_next_player():
	current_player_index = (current_player_index + 1) % player_list.size()
	current_player = player_list.get(current_player_index) as CardPlayer

func declare_winner():
	# not sure what thisll do yet... emit a signal to view layer?
	print("SOMEONE WON!")
	pass

func declare_draw():
	#emit a signal or something?
	print("IT WAS A DRAW!")
	pass

#returns true if player clicked mulligan button, false if not
func await_mulligan_input() -> bool:
	await_test_input()
	return true

func await_main_phase_input() -> void:
	#set highlighted cards, targets, whatever
	await_test_input()

func await_discard_input() -> void:
	#player clicks the needed number of cards to discard
	await_test_input()

func await_test_input():
	await %UICardGameLayer.get_node("AdvanceStateButton").pressed

func reshuffle_everything():
	for player in player_list:
		#player.deck.cards.append_array(player.hand.cards)
		#player.deck.cards.append_array(player.discard_pile.cards)
		#player.deck.cards.append_array(player.play_zone.cards)
		#player.deck.cards.shuffle()
		#player.hand.cards.clear()
		#player.discard_pile.cards.clear()
		#player.play_zone.cards.clear()
		pass

func execute_game_step_func():
	match current_game_step:
		GAME_STEP.SETUP:
			init_game()
		GAME_STEP.MULLIGAN:
			mulligan()
		GAME_STEP.BEFORE_TURN:
			before_turn()
		GAME_STEP.UPKEEP:
			upkeep()
		GAME_STEP.MAIN_PHASE:
			main_phase()
		GAME_STEP.PLAYED_CARD:
			played_card()
		GAME_STEP.BOARD_PHASE:
			board_phase()
		GAME_STEP.END_OF_TURN:
			end_of_turn()

func deal_damage(player_index: int, damage: int):
	player_list.get(player_index).life_total -= damage
	dealt_damage.emit(player_index, damage)

func draw_cards(player_index: int, number_of_cards: int):
	for ii in range(number_of_cards):
		#if not player_list.get(player_index).deck.cards.is_empty():
		#	var drawn_card: CardData = player_list.get(player_index).deck.deal_card()
		#	player_list.get(player_index).hand.cards.append(drawn_card)
		#	drew_card.emit(player_index, drawn_card)
		#else:
		#	deal_damage(player_index, 1)
		pass
	# TODO handle any on-draw effects

func print_debug_state():
	if debug:
		pass
		#print(debug_state_format_1 % [turn_count, current_player_index, current_game_step])
		#print(debug_state_format_2 % [player_list.get(0).hand.cards.size(), player_list.get(0).life_total, player_list.get(1).hand.cards.size(), player_list.get(1).life_total])
