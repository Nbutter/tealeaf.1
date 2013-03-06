puts "This is a calculator app."
puts "You can add, subtract, divide, or multiply two numbers."
puts "Let's begin. What's the first number?"
firstnum = gets.chomp
puts "Great! Now, what's the second number?"
secondnum = gets.chomp
puts "First number is #{firstnum} and second number is #{secondnum}"
puts "What should I do? (1 = add, 2 = subtract, 3 = multiply, 4 = divide)"
operator = gets.chomp.to_i	

result = 0

if operator == 1
  result = firstnum.to_i + secondnum.to_i
elsif operator == 2
  result = firstnum.to_i - secondnum.to_i
elsif operator == 3
  result = firstnum.to_i * secondnum.to_i
elsif operator = 4
  result = firstnum.to_f / secondnum.to_f
end

puts "The result is #{result}"
