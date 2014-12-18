=begin
Future Goals:
  -Give Player ability to Play again
  -Give Player a "Pot" of money with a total that changes
  -End game when player is out of money
  -Give Player ability to bet befor each hand is dealt
  -Add style, name, readability, sleep, etc.

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

system "clear"
say("Let's play Blackjack")

# Create Deck
cards = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace']
suits = ["Spades", "Diamonds", "Hearts", "Clubs"]

deck = suits.product(cards)
deck.shuffle!

# Deal Initial Cards
player_hand = []
dealer_hand = []

player_hand << deck.pop
dealer_hand << deck.pop
player_hand << deck.pop
dealer_hand << deck.pop

dealer_total = calculate_total(dealer_hand)
player_total = calculate_total(player_hand)

# Display
say("Dealer has: #{dealer_hand[0]} and #{dealer_hand[1]}, for a total of #{dealer_total}")
say("You have: #{player_hand[0]} and #{player_hand[1]}, for a total of: #{player_total} ")
puts " "

#Player turn
if player_total == 21 && dealer_total == 21
  say("Push! You both hit Blackjack. It's a tie!")
  exit
elsif player_total == 21
  say("You hit Blackjack! You win!")
  exit
elsif dealer_total == 21
  say("Sorry, dealer hit blackjack. You lose!")
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
    say("You hit 21! You win!")
    exit
  elsif player_total > 21
    say("BUST! Sorry you lose.")
    exit
  end
end

# Dealer Turn

while dealer_total < 17
  #hit
  new_card = deck.pop
  say("Dealing new card for dealer: #{new_card}")
  dealer_hand << new_card
  dealer_total = calculate_total(dealer_hand)
  say("Dealer total is now: #{dealer_total}")

  if dealer_total == 21
    puts "Sorry, dealer hit 21. You lose!"
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
say("Dealer's total is #{dealer_total}")
puts " "
say("Your Cards: ")
player_hand.each do |card|
  say(" " + card.to_s)
end
puts " "
say("Your total is #{player_total}")
puts " "

if dealer_total > player_total
 say("Sorry, dealer wins!")
elsif dealer_total < player_total
  say("Congratulations, you win!")
else
  say("Push. It's a tie!")
end

exit




