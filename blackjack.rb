puts "what is card 1?"
card1 = gets.chomp
puts "what is card 2?"
card2 = gets.chomp
total = 0

if card1.downcase == "ace"
  total = 10+card2.to_i
  if total > 21
    total = 1+card2.to_i
  end
elsif card2.downcase == "ace"
  total = card1.to_i+10
  if total > 21
    total = card1.to_i+1
  end
else 
  total = card1.to_i + card2.to_i
end

puts "The total is #{total}."

if total > 21
  puts "You're busted!"
else
  puts "Want another card?"
end