# frozen_string_literal: true

if Rails.env.development?
  Rails.application.config.session_store :cookie_store, key: 'user_id', expire_after: 30.minutes
else
  Rails.application.config.session_store :cookie_store, key: 'user_id'
end
