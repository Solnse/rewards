require 'yaml'
require 'rspec'
require_relative '../lib/reward'

describe "United MileagePlus balance" do  
  before(:all) do 
    @accounts = YAML.load_file('./secrets.yml')
    @username = @accounts['united']['username']
    @password = @accounts['united']['password']
    @result = Reward.new(type: 'united', username: @username, password: @password).card_balance
    @result.freeze
  end

  it "returns 'united' type" do 
    expect(@result[:type]).to eq('united')
  end

  it "returns a balance" do 
    expect(@result[:balance]).not_to be_nil
  end

  it "returns the account number" do 
    expect(@result[:account_number]).not_to be_nil
  end

  it "returns year-to-date qualifying miles" do 
    expect(@result[:ytd_qualifying_miles]).not_to be_nil
  end

  it "returns year-to-date qualifying segments" do 
    expect(@result[:ytd_qualifying_segments]).not_to be_nil
  end

  it "returns year-to-date qualifying dollars" do 
    expect(@result[:ytd_qualifying_dollars]).not_to be_nil
  end

  it "returns year-to-date flight segment minimum" do 
    expect(@result[:flight_segment_minimum]).not_to be_nil
  end

  it "returns travel bank current balance" do 
    expect(@result[:travelbank_current_balance]).not_to be_nil
  end

  it "returns travel bank available balance" do 
    expect(@result[:travelbank_available_balance]).not_to be_nil
  end
end