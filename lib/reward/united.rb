require 'mechanize'

# United Mileage Plus rewards program.
class United < Reward

  def self.balance(username, password)
    @username = username
    @password = password
    @signin_page = "https://www.united.com/web/en-US/apps/account/account.aspx"

    agent = Mechanize.new
    agent.user_agent_alias = 'Mac Safari'
    agent.read_timeout = 10
    agent.follow_meta_refresh = true

    begin
      page     = agent.get @signin_page
      document = Nokogiri::HTML(page.body)
    rescue Timeout::Error
      return {error: "PAGE_UNAVAILABLE"}
    end

    begin
      # iterate through all the hidden input fields to preserve for the post action.
      params   = document.css('input').map { |input| [input['name'], input['value']] }.to_h
      params["ctl00$ContentInfo$SignIn$onepass$txtField"]     = @username
      params["ctl00$ContentInfo$SignIn$password$txtPassword"] = @password
      # this hidden input field must be deleted or the post fails.
      params.delete("ctl00$CustomerHeader$ChangeBtn")

      page     = agent.post("https://www.united.com/web/en-US/apps/account/signin.aspx", params)
      document = Nokogiri::HTML(page.body)
    rescue => e
      puts e.message
      return {error: "RESOURCE_CHANGED"}
    end

    begin
      balance = document.css('#ctl00_ContentInfo_AccountSummary_lblMileageBalanceNew').text
    rescue => e
      puts e.message
      return {error: "UNAUTHORIZED"}
    end

    begin
      account_number               = document.css('#ctl00_ContentInfo_AccountSummary_lblOPNumberNew').text
      ytd_qualifying_miles         = document.css('#ctl00_ContentInfo_AccountSummary_spanEliteMilesNew').text
      ytd_qualifying_segments      = document.css('#ctl00_ContentInfo_AccountSummary_spanEliteSegmentsNew').text
      ytd_qualifying_dollars       = document.css('#ctl00_ContentInfo_AccountSummary_spanEliteQualifyDollar').text
      flight_segment_minimum       = document.css('#ctl00_ContentInfo_AccountSummary_spanFlightSegMin').text
      travelbank_current_balance   = document.css('#ctl00_ContentInfo_lblGiftBalance').text
      travelbank_available_balance = document.css('#ctl00_ContentInfo_lblGiftAvailBalance').text
    rescue => e
      puts e.message
      return {error: "ATTRIBUTES_CHANGED"}
    end

    result = {type:                         "united",
              balance:                      balance, 
              account_number:               account_number,
              ytd_qualifying_miles:         ytd_qualifying_miles,
              ytd_qualifying_segments:      ytd_qualifying_segments,
              ytd_qualifying_dollars:       ytd_qualifying_dollars,
              flight_segment_minimum:       flight_segment_minimum,
              travelbank_current_balance:   travelbank_current_balance,
              travelbank_available_balance: travelbank_available_balance
              }
  end
end