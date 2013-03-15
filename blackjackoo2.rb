# classes: Deck, Card, Hand, Talker, Game
# decided I didn't need a player class with only 2 players
# but of course we'd need one for multiplayer
# probably with subclasses for humans and computer players

class Deck 

  attr_accessor :cards
  
  def initialize
    @suits = ['Clubs', 'Diamonds', 'Hearts', 'Spades']
    @ranks = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace']
    @cards = [] 
    @deck = make_deck
  end

  def make_deck
    @suits.each do |suit| 
      @ranks.each do|rank| 
        @cards << Card.new(suit,rank)
      end
    end
    cards.shuffle!
  end

  def deal_card
     #returns a card to caller
     @cards.pop
  end
end


class Card
  
  attr_accessor :suit, :rank, :name, :value, :hidden
  
  def initialize suit, rank, hidden=false
    @suit = suit
    @rank = rank
    @name = ''
    @value = 0
    @hidden = false
    make_name
    make_value
  end
  
  def make_value
    if @rank.to_i != 0
      @value = @rank.to_i
    elsif @rank == 'Ace'
      @value = 11
    else 
      @value = 10
    end
  end
  
  def make_name
    @name = "#{@rank} of #{@suit}"
  end
end

class Hand 

  attr_accessor :endstate, :sum, :cards, :values

  def initialize player,deck
    @cards = []
    @values = []
    @aces = 0
    @endstate = nil
    @player = player
    @deck = deck
    @sum = 0
  end
  
  def get_card hidden = false
    # calls Deck.deal_card to get a card
    # adds it to @cards
    @hidden = hidden
    @draw = @deck.deal_card
    if @hidden == true
    @draw.hidden = true
    end
    @cards << @draw
    return @draw.name
  end
  
  def show_hidden
    @cards.each do |card|
     if card.hidden == true
       return "the #{card.name}."
     else
       return 'no hidden cards'
    end
    end
  end
  
  def check_hand
    # populates the values array
    @values = []
    @cards.each do |card|
      @values << card.value
    end
    #counts up the aces in the hand
    @cards.each do |card|
      if card.rank == 'Ace'
        @aces +=1
      end
    end
    # sums value
    @sum = 0
    for i in @values
      @sum = @sum + i
    end
    # if value > 21, replaces an 11 with a 1
    return evaluate
  end

  def evaluate
    if @sum < 21
      @sum
    elsif  @sum == 21
     @sum
    elsif @sum > 21 && @aces == 0
     86
    else
      @aces.times do
        until @sum < 21
        @sum = @sum - 10
        end
      end
      @sum
    end
   end
end

class Say
  
  #pings various places for variables
  #communicates with the user
  #gets.chomp, converts it, makes it available

  attr_accessor :input

  def self.announce_start
    puts 'Welcome to Blackjack!'
  end

  def self.announce_card player, card
    puts "#{player.capitalize} drew the #{card}."
   end
   

  def self.announce_hidden player
    puts "#{player} drew a face-down card"
  end

  def self.announce_show player, card
    puts "#{player} shows #{card}"
  end

  def self.announce_winner winner 
    @verb = 'wins'
    if winner == 'You'
      @verb = 'win'
    end
    puts "#{winner} #{@verb}!"
  end

  def self.announce_blackjack
    puts "Blackjack!"
  end
  
  def self.announce_push
    puts "It's a push! No winner."
  end
  
  def self.announce_bust player
    if player.downcase == 'you'
      puts "You busted. Game over!" 
      exit
    else
      puts "Dealer busted. Game over!"
      exit
    end
  end

  def self.get_next_move
    # asks user for next move
    puts "What do you want to do?"
    puts "H = Hit, S = Stand"
    @input = gets.chomp
    if @input.downcase == 'h'
      @input
    elsif @input.downcase == 's'
      @input
    else
      puts "I only understand 'H' or 'S'"
      get_next_move
    end
  end
end


class Game

  def initialize
    Say.announce_start
    @deck = Deck.new
    @user_hand = Hand.new('user', @deck)
    @dealer_hand = Hand.new('dealer', @deck)
  end
  
  def start
  	first_deal 
  	player_turn 
  	dealer_turn 
  end  

  def first_deal   
    @done = false
    # draw face-up card for player
    @first = @user_hand.get_card
    Say.announce_card('You', @first)
    
    # draw hidden card for dealer
    @second = @dealer_hand.get_card(true) #figure out to make this hidden
    Say.announce_hidden('Dealer')
    
    # draw face-up card for player
    @third = @user_hand.get_card
    Say.announce_card('You', @third)
    
    # draw face-up card for dealer
    @fourth = @dealer_hand.get_card
    Say.announce_card('Dealer', @fourth)
    
    # check player hand for blackjack before next turn
    @result = @user_hand.check_hand
       if @result == 21
      Say.announce_blackjack
      if @dealer_hand.check_hand != 21
        Say.announce_winner('You')
      else
        @hidden = @dealer_hand.show_hidden
        Say.announce_show('Dealer', @hidden)
        Say.announce_push
      end
    else
      @done = true
    end
    # if player == blackjack, does dealer show 10 or A?
    # if yes, flip dealer card
    # calculate & announce winner
    # if not, player wins
    # if player != blackjack, player turn
  end

  def player_turn
   @done2 = false
   while @done2 == false
     @move = Say.get_next_move
     if @move == 'h'
       @next = @user_hand.get_card
       Say.announce_card('You', @next)
       @result = @user_hand.check_hand
       if @result == 'blackjack'
         Say.announce_blackjack
         Say.announce_winner('You')
         @done2 = true
         exit
       elsif @result == 'busted'
         Say.announce_bust('You')
         @done2 = true 
         exit
       end
     elsif @move == 's'
       @done2 = true
     end 
   end
    # if stand, dealer turn
    # while hit
    #  - draw card
    # - announce card
    # - check value
    #  - blackjack, bust, or ask again
  end

  def dealer_turn
    @done3 = false
    @hidden = @dealer_hand.show_hidden
    Say.announce_show('Dealer', @hidden)
    @done3 = true
    @user_sum = @user_hand.check_hand
    puts "user total is #{@user_sum}"
    @dealer_sum = @dealer_hand.check_hand
    puts "dealer total is #{@dealer_sum}"
    # while < user and < 17, hit
    until @dealer_sum > 16
      @next_card = @dealer_hand.get_card
      Say.announce_card('Dealer',@next_card)
      @dealer_sum = @dealer_hand.check_hand
    end
    if @dealer_sum == 21
      Say.announce_blackjack
      Say.announce_winner('Dealer')
      exit
    elsif @dealer_sum == 86
      Say.announce_bust('Dealer')
      Say.announce_winner('You')
      exit
    else
      who_won
    end
  end
  
  def who_won 
    @winner = ''
    @user_sum = @user_hand.check_hand
    @dealer_sum = @dealer_hand.check_hand
    if @user_sum > @dealer_sum
      @winner = 'You'
    elsif @user_sum == @dealer_sum
      @winner = 'Nobody'
    elsif @user_sum < @dealer_sum
      @winner = 'Dealer'
    else
      puts "Sorry, we're having technical difficulties"
    end
  Say.announce_winner(@winner)
  exit
  end

end	

game = Game.new
game.start

# classes: Deck, Card, Hand, Say, Game
 