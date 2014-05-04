require 'mechanize'
# 03109369496
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
      page = agent.get @signin_page
    rescue Timeout::Error
      return {error: "PAGE_UNAVAILABLE"}
    end

    begin
      params = {
        #"hdnServer" => ".92",
        #"hdnSID" => "E7E84E0EFB164CC1AE2D2648F102A5CE",
        #"hdnLangCode" => "en-US",
        #"hdnPOS" => "US",
        #"hdnClient" => "75.140.149.125",
        #"hdnInactive" => "false",
        #"hdnAccountNumber" => nil,
        #"hdnAccountNumberE" => nil,
        "hdnAccountStatus" => nil,
        "__EVENTTARGET" => nil,
        "__EVENTARGUMENT" => nil,
        #"hdnTiming" => "0.2343375 seconds",
        #"__VIEWSTATE" => "/wEPDwUKMTQzNjgzNDA3NA9kFgJmD2QWAgIDDxYCHghvbnVubG9hZAUSUHVyY2hhc2VBYmFuZG9uKCk7FgICAQ8WAh4GYWN0aW9uBTlodHRwczovL3d3dy51bml0ZWQuY29tL3dlYi9lbi1VUy9hcHBzL2FjY291bnQvc2lnbmluLmFzcHgWBAIFD2QWAgIJD2QWBAIJD2QWAgIBDw8WAh4LTmF2aWdhdGVVcmwFOWh0dHBzOi8vd3d3LnVuaXRlZC5jb20vd2ViL2VuLVVTL2FwcHMvYWNjb3VudC9lbnJvbGwuYXNweGRkAg0PZBYCAgEPZBYIAgEPZBYEAgIPDxYEHgxFcnJvck1lc3NhZ2UFRiEgUGxlYXNlIGVudGVyIGEgTWlsZWFnZVBsdXMgTnVtYmVyIG9yIFVzZXJuYW1lLjwhLS1FcnJDb2RlOlYxLS0+PGJyLz4eD1ZhbGlkYXRpb25Hcm91cAUKU2lnbkluRm9ybWRkAgQPDxYEHwMFTSEgUGxlYXNlIGVudGVyIGEgdmFsaWQgTWlsZWFnZVBsdXMgTnVtYmVyIG9yIFVzZXJuYW1lLjwhLS1FcnJDb2RlOlYxNS0tPjxici8+HwQFClNpZ25JbkZvcm1kZAIDD2QWAmYPDxYCHwIFX34vZW4tVVMvYXBwcy9hY2NvdW50L3NldHRpbmdzL2FjY291bnROdW1iZXJSZXNvbHV0aW9uLmFzcHg/U0lEPUU3RTg0RTBFRkIxNjRDQzFBRTJEMjY0OEYxMDJBNUNFZGQCBQ9kFgRmDw8WAh8EBQpTaWduSW5Gb3JtZGQCAg8PFgIfBAUKU2lnbkluRm9ybWRkAgkPZBYCZg9kFgICAg8QDxYCHwQFClNpZ25JbkZvcm1kZGRkAgsPDxYCHgdWaXNpYmxlaGRkGAEFHl9fQ29udHJvbHNSZXF1aXJlUG9zdEJhY2tLZXlfXxYFBRhjdGwwMCRDdXN0b21lckhlYWRlciRyZDEFGGN0bDAwJEN1c3RvbWVySGVhZGVyJHJkMgUYY3RsMDAkQ3VzdG9tZXJIZWFkZXIkcmQzBRxjdGwwMCRDdXN0b21lckhlYWRlciRjaGtTYXZlBSxjdGwwMCRDb250ZW50SW5mbyRTaWduSW4kcmVtZW1iZXJtZSRjaGtSZW1NZen9lf3n5uQol4+Aa3M/RT301pco",
        #"ctl00$CustomerHeader$countryText" =>  nil,
        #"ctl00$CustomerHeader$langText" => nil,
        #"ctl00$ContentInfo$hdnReturnPage" => "/web/en-US/apps/account/account.aspx?SID=E7E84E0EFB164CC1AE2D2648F102A5CE",
        "ctl00$ContentInfo$SignIn$onepass$txtField" => @username,
        "ctl00$ContentInfo$SignIn$password$txtPassword" => @password,
        "ctl00$CustomerHeader$ddlCountries" => "US"
      }
      result = agent.post("https://www.united.com/web/en-US/apps/account/signin.aspx", params)
      document = Nokogiri::HTML(result.body)
      #File.open("united_result.html", "w") { |file| file.write(document)}
    rescue => e
      puts e.message
      return {error: "RESOURCE_CHANGED"}
    end

    balance = document.css('#ctl00_ContentInfo_AccountSummary_lblMileageBalanceNew').text

    puts balance
    return {balance: balance}

  end
end