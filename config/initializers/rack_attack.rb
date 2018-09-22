# Throttle login attempts for a given email parameter to 6 reqs/minute
# Return the email as a discriminator on POST /login requests
Rack::Attack.throttle('limit logins per email', limit: 6, period: 60) do |req|
    if req.path == '/login' && req.post?
      req.params['email']
    end
end

Rack::Attack.blocklisted_response = lambda do |env|
    # Using 503 because it may make attacker think that they have successfully
    # DOSed the site. Rack::Attack returns 403 for blocklists by default
    [ 503, {}, ['Blocked']]
end
  
Rack::Attack.throttled_response = lambda do |env|
    # NB: you have access to the name and other data about the matched throttle
    #  env['rack.attack.matched'],
    #  env['rack.attack.match_type'],
    #  env['rack.attack.match_data'],
    #  env['rack.attack.match_discriminator']
  
    # Using 503 because it may make attacker think that they have successfully
    # DOSed the site. Rack::Attack returns 429 for throttling by default
    [ 503, {}, ["Server Error\n"]]
end