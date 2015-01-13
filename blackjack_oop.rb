require 'rubygems'
require 'pry'

# Object Oriented Blackjack
#   1) Abstraction
#   2) Encapsulation
#   
class Card
  attr_accessor :suit, :face_value

  def initialize(suit, face_value)
    @suit = suit
    @face_value = face_value
  end

  def find_suit
    case suit
      when 'H' then 'Hearts'
      when 'D' then 'Diamonds'
      when 'S' then 'Spades'
      when 'C' then 'Clubs'
    end
  end

  def pretty_output
    "The #{face_value} of #{find_suit}"
  end
  
  def to_s
    pretty_output
  end
end

class Deck
  attr_accessor :cards

  def initialize
    @cards = []
    ['H', 'D', 'S', 'C'].each do |suit|
      ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace'].each do |face_value|
        @cards << Card.new(suit, face_value)
      end
    end
    shuffle_deck!
  end
  
  def shuffle_deck!
    5.times {cards.shuffle!}
  end

  def deal_one
    cards.pop
  end

  def size
    cards.size
  end
end

module Hand
  def show_hand
    puts "---- #{name}'s Hand ----"
    cards.each do |card|
      puts "=> #{card}"
    end
    puts "=> Total: #{total}"
  end

  def total
    face_values = cards.map { |card| card.face_value}

    total = 0
    face_values.each do |val|
      if val == "Ace"
        total += 11
      else
        total += (val.to_i == 0 ? 10 : val.to_i)
      end
    end

    #correct for Aces
    face_values.select{|val| val == "Ace"}.count.times do
    break if total <= 21
    total -= 10
    end
    total
  end

  def add_card(new_card)
    cards << new_card
  end

  def is_busted?
    total > Blackjack::BLACKJACK_AMOUNT
  end
end

class Player
  include Hand

  attr_accessor :name, :cards

  def initialize(name)
    @name = name
    @cards = []
  end

  def show_flop
    show_hand
  end
end

class Dealer
  include Hand

  attr_accessor :name, :cards

  def initialize
    @name = "Dealer"
    @cards = []
  end

  def show_flop
    puts "---- Dealer's Hand ----"
    puts "=> First card is hidden"
    puts "=> Second card is #{cards[1]}"
  end
end

class Blackjack
  attr_accessor :player, :dealer, :deck

  BLACKJACK_AMOUNT = 21
  DEALER_HIT_MIN = 17

  def initialize
    @player = Player.new("Player1")
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def set_player_name
    puts "What's your name?"
    puts " "
    player.name = gets.chomp
  end

  def deal_cards
    puts " "
    puts "Dealing initial cards..."
    puts " "
    2.times do
      player.add_card(deck.deal_one)
      dealer.add_card(deck.deal_one)
    end
  end

  def show_flop
    player.show_flop
    puts " "
    dealer.show_flop
  end

  def greeting
    system 'clear'
    puts "Let's play Blackjack!"
  end

  def blackjack_or_bust?(player_or_dealer)
    if player_or_dealer.total == BLACKJACK_AMOUNT
      if player_or_dealer.is_a?(Dealer)
        puts "Sorry, the dealer hit blackjack. #{player.name} loses."
      else
        puts "Congratulations, #{player.name} hit blackjack! #{player.name} is the winner!"
      end
      play_again?
    elsif player_or_dealer.is_busted?
      if player_or_dealer.is_a?(Dealer)
        puts "Congratulations, dealer busted. #{player.name} is the winner!"
      else
        puts "Sorry, it looks like #{player.name} busted. #{player.name} loses."
      end
      play_again?
    end
  end

  def player_turn
    puts " "
    puts "#{player.name}'s turn."

    blackjack_or_bust?(player)
    while !player.is_busted?
      puts "What would you like to do? 1) Hit 2) Stay"
      response = gets.chomp

      if !['1','2'].include?(response)
      say("Error: you must enter 1 or 2")
      next
      end

      if response == '2'
        puts "#{player.name} chose to stay."
        break
      end

      #hit
      new_card = deck.deal_one
      puts "#{player.name} hits!"
      puts "Dealing card to #{player.name}: #{new_card}"
      player.add_card(new_card)
      puts "#{player.name}'s total is now: #{player.total}"

      blackjack_or_bust?(player)
    end
    puts "#{player.name} stays at #{player.total}"
  end

  def dealer_turn
    puts " "
    puts "Dealer's turn."
    puts " "
    dealer.show_hand
    puts " "
    blackjack_or_bust?(dealer)
    while dealer.total < DEALER_HIT_MIN
      new_card = deck.deal_one
      puts "Dealer hits!"
      puts "Dealing card to dealer: #{new_card}"
      dealer.add_card(new_card)
      puts "Dealer total is now: #{dealer.total}"
      blackjack_or_bust?(dealer)
    end
    puts "Dealer stays at #{dealer.total}"
  end

  def who_won?
    puts " "
    puts "#{player.name} has a total of #{player.total}"
    puts "The Dealer has a total of #{dealer.total}"
    puts " "
    if player.total > dealer.total
      puts "Congratulations, #{player.name} is the winner"
    elsif player.total < dealer.total
      puts "Sorry, #{player.name} loses. The dealer has a higher score."
    else
      puts "It's a tie!"
    end
    play_again?
  end

  def play_again?
    puts ""
    puts "Would you like to play again? 1) Yes 2) No, exit"
    if gets.chomp == '1'
      puts "starting new game..."
      puts ""
      deck = Deck.new
      player.cards = []
      dealer.cards = []
      start
    else
      puts "Thanks for playing. Goodbye!"
      exit
    end
  end

  def start
    greeting
    set_player_name
    deal_cards
    show_flop
    player_turn
    dealer_turn
    who_won?
  end
end

Blackjack.new.start


