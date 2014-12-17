=begin
** Pseudocode**
  Give cards Values
    -Face cards are whatever they are worth (2, 3, 4, etc..)
    -Suit cards are worth 10 (Jack, Queen, King)
    -Aces worth either 11 or 1. Defaults to 1 if total > 21

Player will need a cash pot to make bets from.
  -Make a minimum bet
  -Once Player is out of cash, game ends

Player dealt two cards
  -If total of two cards = 21 Blackack
Dealer dealt two cards
  -If total of two cards = 21 Blackjack
If both Dealer and Player have 21 from initial two cards, it's a tie.

If neither player hits blackjack. Game continues

Player can choose to "Hit", or "Stay"
  If sum > 21 player "busted" and lost
  If sum = 21 Player wins
  If sum less than 21 player can choose hit or stay again
  If player chooses to stay total value is saved, and turn moves to the dealer

Dealer
  Must hit until total >= 17 , then must stop
  If dealer bust player wins
  IF dealer hits 21 dealer wins

If neither player hits 21 or bust, and both stay, compare totals
  -highest total wins

=end
require 'pry'

# Method Definitions

def say(message)
  puts "=> #{message}"
end

def calculate_total(cards)
  cards.map {|x| x} 

end

#Main Program
loop do
  system "clear"
  say("Let's play Blackjack")

  say("Please enter your first name")
  player_name = gets.chomp.capitalize

  player_pot = 500
  say("Welcome #{player_name}. You have a $500 starting pot.")

#Create a deck
  cards = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
  suits = ["\u2660", "\u2663", "\u2665", "\u2666"]

  deck = suits.product(cards)
  deck.shuffle!

# Deal Cards
  player_hand = []
  dealer_hand = []

  player_hand << deck.pop
  dealer_hand << deck.pop
  player_hand << deck.pop
  dealer_hand << deck.pop

exit

# End game if player is out of money
  if player_total <= 0
    say("Sorry bub. It looks like you have run out of money")
    puts " "
    say("Would you like to play again (y/n)?  One more round wouldn't hurt...")
    play_again = gets.comp.downcase
      if play_again == 'y'
        sleep 1
        next
      else
        break
      end
  else
      next
    
  end
end

