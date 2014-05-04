require 'yaml'
require 'rspec'
require_relative '../lib/reward'

accounts = YAML.load_file('secrets.yml')

describe "Starbucks stars balance" do  
  before(:all) do 
    @username = accounts['starbucks']['username']
    @password = accounts['starbucks']['password']
    @result = Reward.new(type: 'starbucks', username: @username, password: @password).card_balance
  end
  
  it "returns a balance" do 
    expect(@result[:balance]).not_to be_nil
  end

  it "returns stars until next reward" do 
    expect(@result[:stars_to_go]).not_to be_nil
  end

  it "returns current rewards available" do 
    expect(@result[:earned_available]).not_to be_nil
  end
end