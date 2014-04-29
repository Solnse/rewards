require 'mechanize'

class Starbucks < Reward
  def self.card_balance(username, password)
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
      #File.open("starbucks_result.html", "w") { |f| f.write(result.body) }
    rescue => e 
      puts e.message
      puts "ERROR"
    end

  end
end