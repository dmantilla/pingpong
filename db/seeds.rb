['inigo', 'edrizio', 'daniel', 'marcelo'].each do |u|
  User.create!(email: "#{u}@regalii.com", password: 'secret123')
end
puts "-- Added 4 users to your database"
