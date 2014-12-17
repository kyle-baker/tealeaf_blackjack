=begin
** Pseudocode**

Player will need a cash pot to make bets from.
  -Make a minimum bet
  -Once Player is out of cash, game ends

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
#[['D', '3'], ['S', '10'], ...]
  array = cards.map{|e| e[1]}
  total = 0
  array.each do |value|
    if value == "Ace"
      total += 11
    elsif value.to_i == 0 # Jack, Queen, King
      total += 10
    else
      total += value.to_i
    end
  end
  #correct for aces
  array.select{|e| e == "Ace"}.count.times do
    total -= 10 if total > 21
  end
  total
end

#Main Program
loop do
  system "clear"
  say("Let's play Blackjack")

  say("Please enter your first name")
  player_name = gets.chomp.capitalize

  say("Welcome #{player_name}.")

#Create a deck
  cards = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace']
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

  dealer_total = calculate_total(dealer_hand)
  player_total = calculate_total(player_hand)

# Show Cards
  say("Dealer has: #{dealer_hand[0]} and #{dealer_hand[1]}, for a total of #{dealer_total}")
  say("You have: #{player_hand[0]} and #{player_hand[1]}, for a total of: #{player_total} ")
  puts " "

  
#Player turn
  if player_total == 21
    puts "You hit BlackJack! You win!"
    exit
  end

  while player_total < 21 
    say("Would you like to hit or stay? 1) Hit 2) Stay")
    hit_or_stay = gets.chomp
    if !['1','2'].include?(hit_or_stay)
      say("Error: you must enter 1 or 2")
      next
    end
    if hit_or_stay == "2"
      break
    end

    #Player chooses Hit
    new_card = deck.pop
    say("Dealing card to player: #{new_card}")
    player_hand << new_card
    player_total = calculate_total(player_hand)
    say("Your total is now: #{player_total}")

    if player_total == 21
      say("You hit BlackJack! You win!")
      exit
    elsif player_total > 21
      say("BUST! Sorry you lose.")
      exit
    end
  end

  # Dealer Turn
  
  if dealer_total == 21
    say("Sorry, dealer hit blackjack. You lose!")
    exit
  end

  while dealer_total < 17
    #hit
    new_card = deck.pop
    say("Dealing new card for deadler: #{new_card}")
    dealer_hand << new_card
    dealer_total = calculate_total(dealer_hand)
    say("Dealer total is now: #{dealer_total}")

    if dealer_total == 21
      puts "Sorry, dealer hit blackjack. You lose."
      exit
    elsif dealer_total > 21
      puts "Congratulations, dealer busted! You win!"
      exit
    end
  end

  # Compare hands
  
  say("Dealer's cards: ")
  dealer_hand.each do |card|
    say(" " + card.to_s)
  end
  puts ""
  
  say("Your Cards: ")
  player_hand.each do |card|
    say(" " + card.to_s)
  end
  puts ""

if dealer_total > player_total
  say("Sorry, dealer wins!")
elsif dealer_total < player_total
  say("Congratulations, you win!")
else
  say("Push. It's a tie!")
end

exit

# End game if player is out of money
  # if pot_total <= 0
  #   say("Sorry bub. It looks like you have run out of money")
  #   puts " "
  #   say("Would you like to play again (y/n)?  One more round wouldn't hurt...")
  #   play_again = gets.comp.downcase
  #     if play_again == 'y'
  #       sleep 1
  #       next
  #     else
  #       break
  #     end
  # else
  #     next
    
  # end
end

