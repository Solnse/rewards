class United < Reward
  attr_accessor :type, :username, :password
  
  def self.card_balance(username, password)
    puts "call to united card_balance."
    puts "card_balance @username: #{self.inspect}"
  end
end