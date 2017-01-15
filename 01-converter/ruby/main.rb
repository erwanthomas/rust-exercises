def f2c(temperature)
  (temperature - 32.0) / 1.8
end

def c2f(temperature)
  temperature * 1.8 + 32
end

def input(type_cast)
  send(type_cast, gets.chomp)
rescue => error
  puts error
end

puts <<~out
  Available conversions:

    0: Fahrenheit => Celsius
    1: Celsius => Fahrenheit

out

conversion = nil

loop do
  print 'Your choice ? '

  conversion = input(:Integer)

  if [0, 1].include?(conversion)
    break
  else
    puts 'Please enter a valid conversion.'
  end
end

temperature = nil

loop do
  print 'Your temperature ? '

  temperature = input(:Float)

  if temperature
    break
  else
    puts 'Please enter a valid temperature.'
  end
end

case conversion
when 0
  puts "#{temperature} Fahrenheit => #{f2c(temperature)} Celsius"
when 1
  puts "#{temperature} Celsius => #{c2f(temperature)} Fahrenheit"
else
  puts 'Unknown conversion'
end
