require 'mechanize'

# Amtrak Guest Rewards program
class Amtrak < Reward

  def self.balance(username, password)
    @username = username
    @password = password
    @signin_page = "https://amtrakguestrewards.com/members/login"

    agent = Mechanize.new
    agent.user_agent_alias = 'Mac Safari'
    agent.read_timeout = 10
    agent.follow_meta_refresh = true

    begin
      page = agent.get @signin_page
    rescue Timeout::Error
      return {error: "PAGE_UNAVAILABLE"}
    end

    begin
      form = page.form_with(action: "/members/validate-login")
      form.field_with(id: "member-uid").value = @username
      form.field_with(id: "member-memberpassword").value = @password
      agent.submit form

      result   = agent.get('https://amtrakguestrewards.com/account')
      document =  Nokogiri::HTML(result.body)
    rescue => e 
      puts e.message
      return {error: "RESOURCE_CHANGED"}
    end

    begin
      account_number = document.css('span.secondary').text
    rescue => e 
      puts e.message
      return {error: "UNAUTHORIZED"}
    end

    begin
      balance      = document.css('td.points').text
      ytd_tqp      = document.css('div#tierSummary td').text
      ytd_tqp_togo = document.css('div#tierSummary p.total-tqps').to_s.match(/[\d,]+/)[0]
      next_level   = document.css('div#tierSummary p.total-tqps a.infobox').text
    rescue => e 
      puts e.message
      return {error: "ATTRIBUTES_CHANGED"}
    end

    result = {type:           "amtrak",
              account_number: account_number,
              balance:        balance,
              ytd_tqp:        ytd_tqp,
              ytd_tqp_togo:   ytd_tqp_togo,
              next_level:     next_level
             }
  end
end