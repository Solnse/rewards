require 'reward/starbucks'
require 'reward/united'

class Card
  def initialize(params)
    @type     = params[:type]
    @username = params[:username]
    @password = params[:password]
    begin
      @klass  = Object.const_get(@type.capitalize)
    rescue => e
      puts e.message
      puts "unknown class #{@type.capitalize}"
    end
  end

  def reward_balance
    @klass.card_balance(@username, @password)
  end
end