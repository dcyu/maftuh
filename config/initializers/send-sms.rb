# $twilio = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
 
# from = "+14159998888" # Your Twilio number
 
# friends = {
# "+14153334444" => "Curious George",
# "+14155557775" => "Boots",
# "+14155551234" => "Virgil"
# }
# friends.each do |key, value|
#   client.account.messages.create(
#     :from => from,
#     :to => key,
#     :body => "Hey #{value}, Monkey party at 6PM. Bring Bananas!"
#   )
#   puts "Sent message to #{value}"
# end