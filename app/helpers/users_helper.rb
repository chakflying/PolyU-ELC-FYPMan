# frozen_string_literal: true

module UsersHelper
  def gravatar_for(user, size: 100)
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.username, class: 'gravatar')
  end

  def is_admin?
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    else
      return false
    end
    @current_user.admin
  end

  def set_last_seen_at
    current_user.update_column(:last_seen_at, Time.now)
  end
end
