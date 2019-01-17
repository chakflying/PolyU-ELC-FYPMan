# frozen_string_literal: true

if Rails.env.development? or Rails.env.production?
  require "rack-mini-profiler"

  # initialization is skipped so trigger it
  Rack::MiniProfilerRails.initialize!(Rails.application)
  Rack::MiniProfiler.config.authorization_mode = :whitelist
end
