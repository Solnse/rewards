require 'yaml'
require 'rspec'
require_relative '../lib/reward'

describe "Amtrak Guest Rewards balance" do  
  before(:all) do 
    @accounts = YAML.load_file('./secrets.yml')
    @username = @accounts['amtrak']['username']
    @password = @accounts['amtrak']['password']
    @result = Reward.new(type: 'amtrak', username: @username, password: @password).card_balance
    @result.freeze
  end

  it "returns 'amtrak' type" do 
    expect(@result[:type]).to eq('amtrak')
  end

  it "returns an account number" do 
    expect(@result[:account_number]).not_to be_nil
  end

  it "returns a balance" do 
    expect(@result[:balance]).not_to be_nil
  end

  it "returns year-to-date tier-qualifying-points" do 
    expect(@result[:ytd_tqp]).not_to be_nil
  end

  it "returns year-to-date tier-qualifying-points til next level" do 
    expect(@result[:ytd_tqp_togo]).not_to be_nil
  end

  it "returns the name of the next level to earn" do 
    expect(@result[:next_level]).not_to be_nil
  end
end
