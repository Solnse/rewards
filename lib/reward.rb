class Reward
  def self.reward_balance(params = {})
    card = Card.new(params)
    card.reward_balance
  end
end

require 'card'