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
    $deck = make_deck
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
  
  def get_card
    # calls Deck.deal_card to get a card
    # adds it to @cards
    @draw = @deck.deal_card
    @cards <<@draw
    return @draw.name
  end
  
  def check_hand
    # populates the values array
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
    @sum = @values.inject(:+)
    # if value > 21, replaces an 11 with a 1
    return eval
  end

  def eval
    if @sum < 21
      @sum
    elsif  @sum == 21
     'blackjack'
    elsif @sum > 21 && @aces == 0
      'busted'
    else
      @sum = @sum - 10
      eval
    end
  end
end

class Talker
  
  #pings various places for variables
  #communicates with the user
  #gets.chomp, converts it, makes it available

  attr_accessor :input

  def announce_start
    puts 'Welcome to Blackjack!'
  end

  def announce_card player, card
    @player = player
    @card = card
    puts "#{@player.capitalize} drew the #{card}."
   end

  def announce_hidden player
    @player = player
    puts "#{@player} drew a face-down card"
  end

  def announce_show player, card
    @player = player
    @card = card
    puts "#{@player} shows the #{@card}"
  end

  def announce_winner winner 
    @winner = winner
    @verb = 'win'
    if @winner != 'You'
      @verb = 'wins'
    end
    puts "#{@winner} #{@verb}!"
  end

  def announce_blackjack
    puts "Blackjack!"
  end
  
  def announce_push
    puts "It's a push! No winner."
  end
  
  def announce_bust player
    @player = player
    if @player.downcase == 'you'
      puts "You busted. Game over!"
    else
      puts "Dealer busted. You win!"
    end
  end

  def get_next_move
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
    @say = Talker.new
    @deck = Deck.new
    @user_hand = Hand.new('user', @deck)
    @dealer_hand = Hand.new('dealer', @deck)
    @say.announce_start
    first_deal
  end

  def first_deal   # still very procedural!!!!
    
    # draw face-up card for player
    @first = @user_hand.get_card
    @say.announce_card('You', @first)
    
    # draw hidden card for dealer
    @second = @dealer_hand.get_card #figure out to make this hidden
    @say.announce_hidden('Dealer')
    
    # draw face-up card for player
    @third = @user_hand.get_card
    @say.announce_card('You', @third)
    
    # draw face-up card for dealer
    @fourth = @dealer_hand.get_card
    @say.announce_card('Dealer', @third)
    
    # check player hand for blackjack before next turn
    @result = @user_hand.check_hand
    if @result == 'blackjack'
      @say.announce_blackjack
      if dealer_hand.check_hand != 'blackjack'
        @say.announce_winner('You')
      else
        #show the dealer's hidden card
        @say.announce_push
      end
    else
      player_turn
    end
    # if player == blackjack, does dealer show 10 or A?
    # if yes, flip dealer card
    # calculate & announce winner
    # if not, player wins
    # if player != blackjack, player turn
  end

  def player_turn
    @move = @say.get_next_move
    if @move == 'h'
      @next = @user_hand.get_card
      @say.announce_card('You', @next)
      @user_hand.check_hand
    elsif @move == 's'
      dealer_turn
    end 
    # if stand, dealer turn
    # while hit
    #  - draw card
    # - announce card
    # - check value
    #  - blackjack, bust, or ask again
  end

  def dealer_turn
    # analyze user hand vs dealer hand
    # while < user and < 17, hit
    # else stand
    # calculate and announce winner
  end
  
  def who_won
    @user_sum = @user_hand.sum
    @dealer_sum = @dealer_hand.sum
    if @user_sum > @dealer_sum
      return ['You','Dealer']
    elsif @user_sum == @dealer_sum
      return ['Push','Push']
    elsif @user_sum < @dealer_sum
      return ['Dealer','You']
    end
  end

end	

game = Game.new

# classes: Deck, Card, Hand, Talker, Game
