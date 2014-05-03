class Reward
  def initialize params
    @type     = params[:type]
    @username = params[:username]
    @password = params[:password]
    @klass    = Object.const_get(@type.capitalize) if Object.const_defined?(@type.capitalize)
  end

  def card_balance
    return {error: "UNKNOWN_CARD_TYPE"} if @klass.nil?
    @klass.balance(@username, @password) unless @klass.nil?
  end
end

require 'reward/starbucks'
require 'reward/united'