# frozen_string_literal: true

require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'
require 'time'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0, 5]
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    ).officials
  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def save_thank_you_letter(id, form_letter)
  Dir.mkdir('output') unless Dir.exist?('output')

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

def clean_phone_number(phone)
  phone_numbers = 0
  0.upto(phone.length - 1) do |i|
    phone_numbers += 1 if phone[i] !~ /\D/
  end
  phone = 'bad number' if phone_numbers < 10 || phone_numbers > 11
  if phone_numbers == 11
    phone = phone[0] == '1' ? phone[1, 10] : 'bad number'
  end
  phone
end

puts 'EventManager Initialized!'

template_letter =  File.read('form_letter.erb')
erb_template = ERB.new template_letter
hours = []

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  phone = clean_phone_number(row[:homephone])

  reg_date = row[:regdate]
  h = Time.strptime(reg_date, '%m/%d/%y %k:%M').hour
  hours << h

  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)

  # save_thank_you_letter(id, form_letter)
end

reg_hours = hours.reduce(Hash.new(0)) do |v,k|
  v[k] += 1
  v
end
p reg_hours
