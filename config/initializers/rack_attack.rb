class Rack::Attack
  
  cache.store = ActiveSupport::Cache::MemoryStore.new

  # If any single client IP is making tons of requests, then they're
  # probably malicious or a poorly-configured scraper. Either way, they
  # don't deserve to hog all of the app server's CPU. Cut them off!
  #
  # Note: If you're serving assets through rack, those requests may be
  # counted by rack-attack and this throttle may be activated too
  # quickly. If so, enable the condition to exclude them from tracking.

  # Throttle all requests by IP (60rpm)
  #
  # Key: "rack::attack:#{Time.now.to_i/:period}:req/ip:#{req.ip}"
  throttle('req/ip', limit: 10, period: 1.seconds) do |req|
    req.ip if (Rails.env.production?) || (Rails.env.test? && ENV["THROTTLE_DURING_TEST"])
  end

end
