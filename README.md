A unified call for popular reward programs.

Calls to each program will require 3 attributes: type, username, and password.
The reward gem will take this information and use it to call the apropriate 
reward program and return information the program provides. At a minimum you 
can expect type and balance to be returned. Any additional information that 
may be useful will be also included.

EXAMPLE: Reward.new(type: "starbucks", username: "user@example.com", password: "pass").card_balance

ERRORS:
there are 5 possible errors that could be returned from a call.

    {error: "UNKNOWN_CARD_TYPE"} can be returned if the type: field in your 
                                 call does not match any reward program call 
                                 included in the gem.
    {error: "PAGE_UNAVAILABLE"} can be returned if it took too long for the 
                                login page for the program to load. Perhaps 
                                their server is down.
    {error: "RESOURCE_CHANGED"} can be returned if the login page has changed 
                                and the gem cannot find the expected fields to 
                                enter credentials.
    {error: "UNAUTHORIZED"} can be returned if the result page (after posting 
                                credentials) is not as expected. On success, a 
                                balance should exist.
    {error: "ATTRIBUTES_CHANGED"} can be returned if login was successful but 
                                the fields we expect to find for account information 
                                is not found.

One of the main goals of this gem is to NOT use selenium-webdriver or other solutions
that use a web browser object so this gem can be included on projects that choose
not to allow browsers on their servers.

if you have any questions or comments, feel free to contact me at chad@therailsroad.com