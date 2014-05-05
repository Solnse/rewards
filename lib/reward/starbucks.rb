require 'mechanize'

# My Starbucks Rewards program.
class Starbucks < Reward
  
  def self.balance(username, password)
    @username = username
    @password = password
    @signin_page = "https://www.starbucks.com/account/signin"

    agent = Mechanize.new
    agent.user_agent_alias = 'Mac Safari'
    agent.read_timeout = 10

    begin
      page = agent.get @signin_page
    rescue Timeout::Error
      return {error: "PAGE_UNAVAILABLE"}
    end

    begin
      form = page.form_with(id: "accountForm")
      form.field_with(id: "Account_UserName").value = @username
      form.field_with(id: "Account_PassWord").value = @password
      result = agent.submit form 
      document = Nokogiri::HTML(result.body)     
    rescue => e
      puts e.message
      return {error: "RESOURCE_CHANGED"}
    end

    begin
      balance = document.css('.balance-amount')[0].text[/\$[0-9\.]+/]
    rescue => e
      puts e.message
      return {error: "UNAUTHORIZED"}
    end

    begin
      stars_to_go      = document.css('.stars-until').text[/[0-9\.]+/]
      earned_available = document.css('.rewards_cup_gold').text
    rescue => e
      puts e.message
      return {error: "ATTRIBUTES_CHANGED"}
    end

    result = { type:             "starbucks",
               balance:          balance,
               stars_to_go:      stars_to_go,
               earned_available: earned_available
             }
  end
end