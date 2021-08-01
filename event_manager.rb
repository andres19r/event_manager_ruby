require 'csv'
puts 'EventManager Initialized!'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

contents.each do |row|
  name = row[:first_name]
  home_phone = row[:homephone]
  puts "#{name} #{home_phone}"
end
