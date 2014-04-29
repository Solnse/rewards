require 'reward/starbucks'
require 'reward/united'

class Card
  def initialize(params)
    @type     = params[:type]
    @username = params[:username]
    @password = params[:password]
    @klass    = Object.const_get(@type.capitalize) if Object.const_defined?(@type.capitalize)
  end

  def reward_balance
    @klass.card_balance(@username, @password) unless @klass.nil?
  end
end