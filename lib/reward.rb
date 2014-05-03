require 'reward/starbucks'
require 'reward/united'

class Reward
  def initialize params
    @type     = params[:type]
    @username = params[:username]
    @password = params[:password]
    @klass    = Object.const_get(@type.capitalize) if Object.const_defined?(@type.capitalize)
  end

  def self.card_balance
    @klass.balance(@username, @password) unless @klass.nil?
  end
end