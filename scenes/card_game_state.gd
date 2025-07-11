class_name CardGameState extends Node

# Keeps track of the state of a single card game. Contains decks, hands, played cards, life totals, etc
# Turn flow: 
#   current player resolves all "before-turn" effects left-to-right
#   check if either player lost
#   current player is dealt cards
#   current player can select cards to pay mana costs + cast cards
#   casted card resolves (if its a spell, its effect happens. if its a creature, its placed on the right side of the board)
#   check if either player lost
#   current player's board resolves left-to-right (creatures attack, permanents do their thing)
#   check if either player lost
#   current player discards down to max hand size
#   current player resolves all "at-end-of-turn" effects left-to-right
#   check if either player lost
#   advance to next players turn

@export var player_list: Array[CardPlayer]

var current_player: int = 0 #index corresponding to the current active player in the player_list
var tapped_cards: Array[int] = [] #array of indeces corresponding to cards in the players hand they've selected to pay with / discard
var played_card: int = -1 #card index in the players hand selected for casting
