puts 'EventManager Initialized!'

# Read the file contents
# puts File.exists?('event_attendees.csv')
# contents = File.read('event_attendees.csv')
# puts contents

# Read the file line by line
# Display the first names of all attendees
lines = File.readlines('event_attendees.csv')
lines.each do |line|
# Skipping the header row
  next if line == " ,RegDate,first_Name,last_Name,Email_Address,HomePhone,Street,City,State,Zipcode\n"
  columns = line.split(",")
  name = columns[2]
  p name
end
