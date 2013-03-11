
deck = [['Three of Clubs', 3], ['Ten of Clubs', 10], ['Four of Clubs', 4]]
dealer_hand = [0]
player_hand = [0]



# draw a  card
def draw(deck, player, hand)
   deck_length = deck.length
   rando = random_number(deck_length)
   card = deck[rando]
   card_value = card[1]
   hand.push(card_value)
   card = card[0]
   say_who_drew_what(player,card)
end


#draw a hidden card
def draw_hidden(deck, player, hand)
   deck_length = deck.length
   rando = random_number(deck_length)
   card = deck[rando]
   hand[0]=card
   puts "Dealer draws a face-down card"
end

# check the hand
def check_hand(hand)
  values = []
  hand.each do |a|
    values.push a[1]
    end
  total = sum(values)
  if total > 21
   aces = find_aces(hand)
   if aces == true
     total = subtract_10(total)
   end  
  end
  return total    
end

#pick a random number and return it to caller
def random_number(number)
  x = rand(number)
  return x
end 

#see if there are aces
def find_aces(array) 
  for i in array
    if i[0[0]] == "A"
    return true
    end
  end
end

#subtract 10
def subtract_10(number) 
  number = number-10
  return number
end
    
#sum everything
def sum(array) 
  total = 0
  total = array.inject(:+)
  return total
end

#tell the user who drew what
def say_who_drew_what(player, card) 
 puts "#{player} drew #{card}."
end

#ask user what to do
def ask_for_next_move 
  puts "What do you want to do next?"
  puts "H: Hit!\nS: Stand"
  input = gets.chomp
    if input.downcase == "h"
      puts "OK, another card for you"
      return "h"
    elsif input.downcase == "s"
      #not sure what happens in this case 
      #we'll just tell the caller we're done
      return "s"
    else 
     puts "I only understand 'H' or 'S'"
     ask_for_next_move
    end
end   

#announce blackjack
def announce_blackjack(player) 
  player = player.capitalize
  verb = ''
  if player.downcase == 'you'
    verb = 'win'
  else
    verb = 'wins'
  end
  puts "Blackjack! #{player} #{verb}!" 
  puts "Thanks for playing!"
end

#announce bust
def announce_bust(loser, winner)
  verb = ''
  if winner == 'You'
    verb = 'win'
  else
    verb = 'wins'
  end
  puts "#{loser} busted. #{winner} #{verb}!"
end


def deal (deck = deck, dealer_hand = dealer_hand, player_hand = player_hand)
  draw_hidden(deck, 'Dealer', dealer_hand)
  draw(deck, 'You', player_hand)
  draw(deck, 'Dealer', dealer_hand)
  draw(deck, 'You', player_hand)
  result = check_hand(player_hand)
     if result == 21
       announce_blackjack('You')
     else
       hidden_card = dealer_hand[0]
       hidden_value = hidden_card[0]
       puts "Dealer shows #{hidden_value}"
       player_move(deck, dealer_hand, player_hand, 'You')
     end
end

def player_move(player_hand, dealer_hand, deck, player = 'You') 
  next_move = ask_for_next_move
  if next_move.downcase == 'h'
  draw(deck, player, player_hand)
  result = check_hand(player_hand)
    if result > 21
      announce_bust(player, 'Dealer')
    else
     player_move(deck, player_hand, player)
    end
  else
     dealer_move(player_hand, dealer_hand, deck, result)
  end
end

#dealer move
def dealer_move(player_hand, dealer_hand, deck, player_total)
  card1 = dealer_hand[0]
  card1_val = card1[0]
  puts "Dealer turns over #{card1_val}."
  dealer_sum = check_hand(dealer_hand)
  if dealer_sum > player_total
    puts 'Dealer wins!'
  elsif dealer_sum < 17
    draw(deck, dealer, dealer_hand)
    dealer_sum = check_hand(dealer_hand)
      puts "ok, I got this far..."
  else
    puts 'You win!'
  end     
end



puts "Welcome to Blackjack!"

deal(deck, dealer_hand, player_hand)
















