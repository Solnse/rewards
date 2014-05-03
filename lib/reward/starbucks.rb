require 'mechanize'

class Starbucks < Reward
  def self.balance(username, password)
    @username = username
    @password = password

    agent = Mechanize.new
    agent.user_agent_alias = 'Mac Safari'

    begin
      page = agent.get "https://www.starbucks.com/account/signin"
      form = page.form_with(id: "accountForm")
      form.field_with(id: "Account_UserName").value = @username
      form.field_with(id: "Account_PassWord").value = @password
      result = agent.submit form      
    rescue => e
      puts e.message
      return {error: "RESOURCE_CHANGED"}
    end
    
    document = Nokogiri::HTML(result.body)

    begin
      balance = document.css('.balance-amount')[0].text[/\$[0-9\.]+/]
    rescue => e
      puts e.message
      return {error: "UNAUTHORIZED"}
    end

    begin
      stars_to_go = document.css('.stars-until').text[/[0-9\.]+/]
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

    return result

  end
end